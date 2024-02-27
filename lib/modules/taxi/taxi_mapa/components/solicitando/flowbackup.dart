import 'dart:async';
import 'dart:developer';

import 'package:app_pasajero_ns/config/config.dart';
import 'package:app_pasajero_ns/data/models/notification_taxi_request.dart';
import 'package:app_pasajero_ns/data/models/travel_info.dart';
import 'package:app_pasajero_ns/data/providers/conductor_provider.dart';
import 'package:app_pasajero_ns/data/providers/geofire_provider.dart';
import 'package:app_pasajero_ns/data/providers/travel_info_provider.dart';
import 'package:app_pasajero_ns/data/services/push_notifications_service.dart';
import 'package:app_pasajero_ns/modules/auth/auth_controller.dart';
import 'package:app_pasajero_ns/modules/taxi/taxi_mapa/taxi_mapa_controller.dart';
import 'package:app_pasajero_ns/routes/app_pages.dart';
import 'package:app_pasajero_ns/utils/utils.dart';
import 'package:app_pasajero_ns/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class LayerSolicitandoCtlr extends GetxController {
  final taxiMapaX = Get.find<TaxiMapaController>();
  final _authX = Get.find<AuthController>();

  // **************************************************
  // *********** SOLICITANDO CONDUCTORES **************
  // **************************************************
  final _geofireProvider = GeofireProvider();
  final _travelInfoProvider = TravelInfoProvider();
  final _conductorProvider = ConductorProvider();

  // GetBuilders ID's
  final gbSlidePanel = 'gbSlidePanel';

  final panelTitleKey = GlobalKey();
  final panelBodyKey = GlobalKey();
  bool panelHeightUpdated = false;
  bool heightFromWidgets = false;
  double panelHeightOpen = 400;
  double panelHeightClosed = 180.0;

  Timer? _timerTravel;
  int _travelTimeout = 0;
  Timer? _timerEachDriver;
  int _eachDriverTimeout = 0;
  StreamSubscription<DocumentSnapshot>? _travelStatusSub;
  StreamSubscription<InternetConnectionStatus>? _networkStatusSubSub;

  bool internetConnected = false;
  List<String> nearbyDrivers = [];
  bool startTimers = false;
  int idxDriverRequest = 0;

  // Animations
  Timer? _timerAnimation;
  AnimatingMap _animateStatus = AnimatingMap.orig;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    _travelStatusSub?.cancel();
    _networkStatusSubSub?.cancel();

    _timerAnimation?.cancel();
    _timerTravel?.cancel();
    _timerEachDriver?.cancel();

    super.onClose();
  }

  //** ACTIONS BETWEEN LAYERS */
  void initialActions() {
    _startRequestService();
  }

  Future<void> _startRequestService() async {
    // Reset variables
    internetConnected = true;
    nearbyDrivers = [];
    startTimers = true;
    idxDriverRequest = 0;

    taxiMapaX.loading.value = true;
    await _findNearbyDrivers();
    if (nearbyDrivers.isEmpty) {
      _onDriversNotFound();
    } else {
      await _activeConnectionListener();
      _setupSolicitudLogic();
    }
  }

  void _setupSolicitudLogic() {
    taxiMapaX.createSolicitudPasajero(onSuccess: (resp) {
      _createTravelInfo(
        _authX.getUser!.uid,
        resp.idSolicitud,
        resp.idServicio,
        taxiMapaX.tarifaDistanciaM,
        _authX.backendUser!.fcm ?? '',
      );
    }, onCancel: () {
      taxiMapaX.cambiarModoVista(taxiMapaX.typeService == ServiceType.regular
          ? ModoVista.adondevamos
          : ModoVista.reserva);
    }, onRetry: () {
      _setupSolicitudLogic();
    });
  }

  Future<void> _onDriversNotFound({bool didNotAccept = false}) async {
    taxiMapaX.loading.value = false;
    await stopTimerAndListeners();
    await taxiMapaX.cambiarModoVista(ModoVista.tarifa);
    AppSnackbar().basic(
        message: didNotAccept
            ? 'No hay conductores disponibles cerca de ti. Por favor intenta de nuevo o comunícate al Call Center.'
            : 'No hay conductores disponibles.',
        duration: Duration(seconds: didNotAccept ? 5 : 3));
  }

  Future<void> _findNearbyDrivers() async {
    try {
      nearbyDrivers = [];
      final drivers = await _geofireProvider.getNearbyDriversList(
          taxiMapaX.myPosition.latitude, taxiMapaX.myPosition.longitude, 5);
      drivers.forEach((d) {
        final json = d.data() as Map<String, dynamic>;
        final lastUpdate = (json['lastUpdate'] as Timestamp).toDate();
        final now = DateTime.now();
        final diffMin = now.difference(lastUpdate).inMinutes;
        print('Diferencia $diffMin');
        // Si el conductor no emitido ninguna actualización desde hace 300 min.
        // Se infiere que se encuentra inactivo o ha cerrado la app.
        if (diffMin < 300) {
          nearbyDrivers.add(d.id);
        }
      });
    } catch (e) {
      Helpers.showError('!Opps! No se pudo encontrar conductores.',
          devError: e.toString());
    }
  }

  Future<void> _activeConnectionListener() async {
    internetConnected =
        ((await Connectivity().checkConnectivity()) != ConnectivityResult.none);
    _networkStatusSubSub?.cancel();
    _networkStatusSubSub =
        InternetConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case InternetConnectionStatus.connected:
          print('Data connection is available.');
          internetConnected = true;
          break;
        case InternetConnectionStatus.disconnected:
          print('You are disconnected from the internet.');
          internetConnected = false;

          break;
      }
    });
    // Sleep necesario para una primera evaluación
    // en el listen de onStatusChange;
    await Helpers.sleep(100);
  }

  Future<void> _createTravelInfo(
    String uidClient,
    int idSolicitud,
    int idServicio,
    int distancia,
    String fcmClientToken,
  ) async {
    try {
      // TODO: QUE PASA SI EL CLIENTE ENVÍA UNA SOLICITUD.. LA CANCELA.. LA NOTIFICACIÓN LLEGA AL CONDUCTOR.
      // Y LUEGO EL PASAJERO VUELVE A ENVIAR UNA NOTIFICACIÒN. Y EL CONDUCTOR ACEPTA LA NOTIFICACIÓN...
      // DEBERÍA HABER UN HASH O UNA VALIDACIÒN PARA COMPROBAR QUE LA INFO QUE HAYA RECIBIDO EL CONDUCTOR
      // MAS ALLÁ DE QUE EL CONDUCTOR SEA IGUAL A NULLL. QUE TAMBIÉN SEA UN HASH UNICO... COMO UN CÓDIGO AUTOGENERADO
      TravelInfo travelInfo = new TravelInfo(
          hash: Helpers.random(100000, 999999),
          estimatedDistance: distancia,
          uidClient: uidClient,
          idSolicitud: idSolicitud,
          idServicio: idServicio,
          status: TravelStatus.CREATED,
          fcmClientToken: fcmClientToken,
          // uidDriver: 'H6cMiSmeSNciDLISjrIsog3mvps2', // TODO: Retirar
          codeValidated: false,
          rejectedBy: [],
          code: 0,
          costo: 0,
          idCupon: 0,
          descuento: 0,
          total: 0);
      await _travelInfoProvider.create(travelInfo);
      log('${travelInfo.toJson()}');
      taxiMapaX.loading.value = false;
      _beginTravelListener(idSolicitud: idSolicitud, idServicio: idServicio);
    } catch (e) {
      taxiMapaX.loading.value = false;
      String _m = e is ApiException
          ? e.message
          : 'No se pudo crear la información de viaje';
      Helpers.showError(_m, devError: e.toString());
    }
  }

  void _beginTravelListener(
      {required int idSolicitud, required int idServicio}) async {
    _travelStatusSub?.cancel();
    Stream<DocumentSnapshot> stream =
        _travelInfoProvider.getByIdStreamWithMetaChanges(_authX.getUser!.uid);
    _travelStatusSub = stream.listen((DocumentSnapshot document) {
      if (document.data() == null) {
        stopTimerAndListeners();
        taxiMapaX.cambiarModoVista(ModoVista.adondevamos);
        Helpers.showError('No se encontró información del viaje');
        return;
      }

      // No se tomará en cuenta la data que viene de Caché
      if (document.metadata.isFromCache) {
        return;
      }

      if (startTimers) {
        startTimers = false;
        _beginTimers(idSolicitud: idSolicitud, idServicio: idServicio);
      }

      print('Hubo un cambio');
      print('Document ${document.data()}');

      TravelInfo travelInfo =
          TravelInfo.fromJson(document.data() as Map<String, dynamic>);
      if (travelInfo.status == TravelStatus.ACCEPTED) {
        stopTimerAndListeners();
        Get.offNamed(AppRoutes.TAXI_TRAVEL);
      }

      /* TravelInfo travelInfo = TravelInfo.fromJson(document.data());
      if (travelInfo.idDriver != null && travelInfo.status == 'accepted') {
        Navigator.pushNamedAndRemoveUntil(
            context, 'client/travel/map', (route) => false);
        // Navigator.pushReplacementNamed(context, 'client/travel/map');
      } else if (travelInfo.status == 'no_accepted') {
        utils.Snackbar.showSnackbar(
            context, key, 'El conductor no aceptó tu solicitud');

        Future.delayed(Duration(milliseconds: 4000), () {
          Navigator.pushNamedAndRemoveUntil(
              context, 'client/map', (route) => false);
        });
      } */
    });
  }

  Future<void> _beginTimers(
      {required int idSolicitud, required int idServicio}) async {
    print('start timers');
    _startTimerTravel();
    await Helpers.sleep(100); // Sleep necesario
    _startTimerEachDriver(idSolicitud: idSolicitud, idServicio: idServicio);
    print('fin');
  }

  Future<void> _startTimerTravel() async {
    _travelTimeout = Config.TIMEOUT_TOTAL_SOLICITUD; // Tiempo de espera total
    _timerTravel?.cancel();
    _timerTravel = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!internetConnected) return;
      print('TRAVEL RESTANTE: $_travelTimeout');
      if (_travelTimeout == 0) {
        timer.cancel();
        _onDriversNotFound(didNotAccept: true);
      } else {
        _travelTimeout--;
      }
    });
  }

  Future<void> _startTimerEachDriver(
      {required int idSolicitud, required int idServicio}) async {
    if (idxDriverRequest >= nearbyDrivers.length) {
      await _onDriversNotFound(didNotAccept: true);
      return;
    }
    await _sendDriverNotification(nearbyDrivers[idxDriverRequest],
        idSolicitud: idSolicitud, idServicio: idServicio);
    _eachDriverTimeout =
        Config.TIMEOUT_POR_CONDUCTOR; // Tiempo de espera por cada conductor
    _timerEachDriver?.cancel();
    _timerEachDriver = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!internetConnected) return;
      log('Esperando a ${nearbyDrivers[idxDriverRequest]}: $_eachDriverTimeout');
      if (_eachDriverTimeout == 0) {
        timer.cancel();
        idxDriverRequest++;
        _startTimerEachDriver(idSolicitud: idSolicitud, idServicio: idServicio);
      } else {
        _eachDriverTimeout--;
      }
    });
  }

  Future<void> _sendDriverNotification(String uid,
      {required int idSolicitud, required int idServicio}) async {
    try {
      if (taxiMapaX.tarifaOrigenCoords == null ||
          taxiMapaX.tarifaDestinoCoords == null) {
        Helpers.showError(
            'Hubo un error con las información de origen y/o destino');
      }

      log('SendDriverNotification to UID: $uid');

      final data = NotificationTaxiRequest(
        hash: 6516516165166161616,
        type: 'TAXI_REQUEST',
        idServicio: idServicio,
        idSolicitud: idSolicitud,
        origenName: taxiMapaX.tarifaOrigenName,
        destinoName: taxiMapaX.tarifaDestinoName,
        origenCoords:
            '${taxiMapaX.tarifaOrigenCoords!.latitude},${taxiMapaX.tarifaOrigenCoords!.longitude}',
        destinoCoords:
            '${taxiMapaX.tarifaDestinoCoords!.latitude},${taxiMapaX.tarifaDestinoCoords!.longitude}',
        uidClient: _authX.getUser!.uid,
      );

      final fcmToken = await _conductorProvider.getFcmTokenByUid(uid);
      if (fcmToken != null) {
        await PushNotificationsService.sendTaxiRequest(
            fcmToken,
            data,
            'Solicitud de servicio',
            'Un cliente requiere un servicio de taxi.');
      }
    } catch (e) {
      Helpers.logger.e('Error en _sendDriverNotification');
    }
  }

  void updatePanelMaxHeight() {
    if (panelHeightUpdated) return;
    try {
      final rObjectTitle = panelTitleKey.currentContext?.findRenderObject();
      final rBoxTitle = rObjectTitle as RenderBox;
      final rObjectBody = panelBodyKey.currentContext?.findRenderObject();
      final rBoxBody = rObjectBody as RenderBox;
      final totalHeight = rBoxTitle.size.height + rBoxBody.size.height;
      final maxPanelHeight = (Get.height * 0.8);

      if (totalHeight < maxPanelHeight) {
        panelHeightOpen = totalHeight;
        heightFromWidgets = true;
      } else {
        panelHeightOpen = maxPanelHeight;
      }
      panelHeightUpdated = true;
      update([gbSlidePanel]);
    } catch (e) {
      print(e);
    }
  }

  Future<void> onUserCancelTap() async {
    await stopTimerAndListeners();
    await taxiMapaX.cambiarModoVista(ModoVista.tarifa);
    // await Helpers.sleep(300);
    // centerToMyPosition();
  }

  Future<void> stopTimerAndListeners() async {
    _timerEachDriver?.cancel();
    _timerTravel?.cancel();
    _travelStatusSub?.cancel();
    _networkStatusSubSub?.cancel();
    _stopFlyAnimation();
  }

  void _startFlyAnimation() {
    _timerAnimation?.cancel();
    if (taxiMapaX.tarifaOrigenCoords == null ||
        taxiMapaX.tarifaDestinoCoords == null ||
        taxiMapaX.tarifaRouteBounds == null) {
      return;
    }
    _animateStatus = AnimatingMap.dest;
    taxiMapaX.centerTo(taxiMapaX.tarifaOrigenCoords!);
    _timerAnimation = Timer.periodic(Duration(seconds: 8), (timer) {
      switch (_animateStatus) {
        case AnimatingMap.orig:
          _animateStatus = AnimatingMap.dest;
          taxiMapaX.centerTo(taxiMapaX.tarifaOrigenCoords!);
          break;
        case AnimatingMap.dest:
          _animateStatus = AnimatingMap.both;
          taxiMapaX.centerTo(taxiMapaX.tarifaDestinoCoords!);
          break;
        case AnimatingMap.both:
          _animateStatus = AnimatingMap.orig;
          // _adjustMapToBounds(tarifaRouteBounds);
          break;
      }
    });
  }

  void _stopFlyAnimation() {
    _timerAnimation?.cancel();
  }
}
