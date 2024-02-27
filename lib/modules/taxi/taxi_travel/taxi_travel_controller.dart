import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:app_pasajero_ns/data/models/cancelaciones_servicios.dart';
import 'package:app_pasajero_ns/data/models/conductor.dart';
import 'package:app_pasajero_ns/data/models/ruta.dart';
import 'package:app_pasajero_ns/data/models/sosservicio.dart';
import 'package:app_pasajero_ns/data/models/travel_info.dart';
import 'package:app_pasajero_ns/data/providers/cancelaciones_servicios_provider.dart';
import 'package:app_pasajero_ns/data/providers/conductor_provider.dart';
import 'package:app_pasajero_ns/data/providers/geofire_provider.dart';
import 'package:app_pasajero_ns/data/providers/ruta_provider.dart';
import 'package:app_pasajero_ns/data/providers/servicio_provider.dart';
import 'package:app_pasajero_ns/data/providers/sosservicio_provider.dart';
import 'package:app_pasajero_ns/data/providers/travel_info_provider.dart';
import 'package:app_pasajero_ns/modules/auth/auth_controller.dart';
import 'package:app_pasajero_ns/modules/taxi/taxi_travel/emergency_options.dart';
import 'package:app_pasajero_ns/routes/app_pages.dart';
import 'package:app_pasajero_ns/themes/ak_ui.dart';
import 'package:app_pasajero_ns/themes/fresh_map_theme.dart';
import 'package:app_pasajero_ns/utils/utils.dart';
import 'package:app_pasajero_ns/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as lct;
import 'package:maps_curved_line/maps_curved_line.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class TaxiTravelArguments {
  final int idServicio;
  final int idSolicitud;
  TaxiTravelArguments({required this.idServicio, required this.idSolicitud});
}

enum TravelView { viajando }

class TaxiTravelController extends GetxController with WidgetsBindingObserver {
  // TODO: AGREGAR SELF VALIDATIONS
  // Instances
  final lct.Location location = lct.Location.instance;
  final _authX = Get.find<AuthController>();
  final _travelInfoProvider = TravelInfoProvider();
  final _geofireProvider = GeofireProvider();
  final _servicioProvider = ServicioProvider();
  final _rutaProvider = RutaProvider();
  final _conductorProvider = ConductorProvider();
  final _polylinePointsLib = PolylinePoints();
  final _cancelacionesServiciosProvider = CancelacionesServiciosProvider();
  // View
  final modoVista = (TravelView.viajando).obs;

  // Mapa
  bool existsPosition = false;
  final isLocalizando = true.obs;
  CameraPosition? initialPosition;
  final defaultZoom = 18.0;
  final _mapController = Completer<GoogleMapController>();
  EdgeInsets mapInsetPadding = EdgeInsets.all(0);
  final Set<Marker> markers = HashSet<Marker>();
  final Set<Polyline> polylines = HashSet<Polyline>();

  // Mi ubicación
  late Position _myPosition;
  Position get myPosition => this._myPosition;
  StreamSubscription<Position>? _myPositionStream;

  // Ruta
  Ruta? ruta;
  StreamSubscription<DocumentSnapshot>? _streamDriverSub;

  StreamSubscription<DocumentSnapshot>? _streamTravelSub;

  int code = 1111;

  // Markers
  static const MARKER_ORIGEN_ID = 'origen';
  static const MARKER_DESTINO_ID = 'destino';
  static const MARKER_DRIVER_ID = 'driver';
  final markerOrigenKey = GlobalKey();
  final markerDestinoKey = GlobalKey();
  final markerDriverKey = GlobalKey();
  BitmapDescriptor? _markerOrigen;
  BitmapDescriptor? _markerDestino;
  BitmapDescriptor? _markerDriver;

  // Default StylePolyline
  static const POLYPARTIDAKEY = 'polypartidakey';
  Polyline _polyPartida = new Polyline(
      polylineId: PolylineId(POLYPARTIDAKEY),
      width: 2,
      patterns: [PatternItem.dash(30), PatternItem.gap(10)],
      color: akPrimaryColor);

  static const POLYVIAJEKEY = 'polyviajekey';
  Polyline _polyViaje = new Polyline(
      polylineId: PolylineId(POLYVIAJEKEY), width: 3, color: akPrimaryColor);

  final loading = false.obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance?.addObserver(this);
    _init();
  }

  @override
  void onClose() {
    WidgetsBinding.instance?.removeObserver(this);
    _myPositionStream?.cancel();
    _streamDriverSub?.cancel();
    _streamTravelSub?.cancel();
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      final controller = await _mapController.future;
      onMapCreated(controller);
    }
  }

  Future<void> _init() async {
    await Helpers.sleep(400);

    _markerOrigen = await Helpers.getCustomIcon(markerOrigenKey);
    _markerDestino = await Helpers.getCustomIcon(markerDestinoKey);
    _markerDriver = await Helpers.getCustomIcon(markerDriverKey);

    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (isLocationEnabled) {
      _configPosition();
    } else {
      bool gpsEnabled = await location.requestService();
      if (gpsEnabled) {
        _configPosition();
      }
    }
  }

  Future<void> _configPosition() async {
    try {
      final lastPosition = await Geolocator.getLastKnownPosition();
      _myPosition = lastPosition ?? await determineFirstPosition();
      await _initialConfigMap();
      print('fin _initialConfig');
      // update(['gbOnlyMap']);

      _getInitialData();
      await _myPositionStream?.cancel();
      _myPositionStream =
          Geolocator.getPositionStream().listen((Position position) {
        _myPosition = position;
        if (travelStatus == 'accepted') {
          if (_cameraType == MapCameraSelected.center) {
            onCenterButtonTap();
          }
        }
      });

      //  _getInitialData();
    } catch (e) {
      Helpers.logger.e('Error en: _configPosition');
    }
  }

  Future<void> sendPosition() async {
    var Url =
        'https://www.google.com/maps/search/?api=1&query=${_myPosition.latitude.toString()},${_myPosition.longitude.toString()}';
    await Share.share('this is my ubication \n\n$Url ');
    print('hello word');
  }

  // Mapa: Functions
  Future<void> _initialConfigMap() async {
    if (!existsPosition && isLocalizando.value) {
      existsPosition = true;
      initialPosition = CameraPosition(
        target: LatLng(_myPosition.latitude, _myPosition.longitude),
        zoom: defaultZoom,
      );
      update(['gbOnlyMap']);
      await Future.delayed(Duration(milliseconds: 400));
      await cambiarModoVista(TravelView.viajando);
      await Future.delayed(Duration(milliseconds: 2000));
      update(['gbOnlyMap']);
    }
  }

  void onMapCreated(GoogleMapController controller) {
    controller.setMapStyle(jsonEncode(freshMapTheme));
    if (!_mapController.isCompleted) {
      _mapController.complete(controller);
    }
  }

  Future<void> cambiarModoVista(TravelView modo) async {
    modoVista.value = modo;
    if (modo == TravelView.viajando) {
      updatePaddingMap(bottom: 200.0);
    }
  }

  void updatePaddingMap({double top = 40.0, double bottom = 0.0}) {
    mapInsetPadding = EdgeInsets.only(
        top: akContentPadding + top,
        bottom: akContentPadding + bottom,
        left: akContentPadding * 0.5,
        right: akContentPadding * 0.75);
    update(['gbOnlyMap']);
  }

  ConductorDto? conductor;

  Future<void> _getInitialData() async {
    print('empezar');
    bool dataComplete = false;
    try {
      final travelResp =
          await _travelInfoProvider.getByUidClient(_authX.getUser!.uid);

      code = travelResp!.code;

      if (travelResp != null &&
          travelResp.idConductor != null &&
          travelResp.uidDriver != null) {
        final conductorResp =
            await _conductorProvider.getById(travelResp.idConductor!);
        if (conductorResp.success) {
          conductor = conductorResp.data;

          final servicioResp =
              await _servicioProvider.getById(travelResp.idServicio);

          if (servicioResp.success && servicioResp.data != null) {
            final idRuta = servicioResp.data!.idRuta;
            if (idRuta != null) {
              final rutaResp = await _rutaProvider.getById(idRuta);
              if (rutaResp.success && rutaResp.data != null) {
                ruta = rutaResp.data;
                update(['gbSlidePanel']);
                origenCoords = convertStringToLatLng(ruta!.coordenadaOrigen!);
                destinoCoords = convertStringToLatLng(ruta!.coordenadaDestino!);

                final strPolyline = ruta!.polyline!;
                final points = _polylinePointsLib.decodePolyline(strPolyline);
                final routeCoords = points
                    .map((point) => LatLng(point.latitude, point.longitude))
                    .toList();
                _polyViaje = _polyViaje.copyWith(pointsParam: routeCoords);

                await _configMarkers(origenPos: origenCoords);

                _startStreamDriver(travelResp.uidDriver!);
                dataComplete = true;
              }
            }
          }
        }
      }
    } catch (e) {
      print('Error en getInitialData: ' + e.toString());
    }
    print('Data complete? $dataComplete');

    if (dataComplete) {
      isLocalizando.value = false;
    }
  }

  LatLng? origenCoords;
  LatLng? destinoCoords;
  LatLng? driverCoords;
  double? driverHeading;

  bool travelStreamStarted = false;

  void _startStreamDriver(String uidDriver) {
    Stream<DocumentSnapshot> stream =
        _geofireProvider.getLocationByIdStreamWithMetadata(uidDriver);
    _streamDriverSub?.cancel();

    _streamDriverSub = stream.listen((DocumentSnapshot document) {
      // si el conductor aparece cono status: drivers_avaliable quiere decir que cancelo el servicio
      if (document.data() == null) return;
      if (document.metadata.isFromCache) {
        return;
      }

      final data = document.data() as Map<String, dynamic>;
      GeoPoint geoPoint = data['position']['geopoint'];
      final heading = double.parse('${data['heading']}');
      driverCoords = LatLng(geoPoint.latitude, geoPoint.longitude);
      driverHeading = heading;
      _updateDriverPosition();

      if (!travelStreamStarted) {
        travelStreamStarted = true;
        _startStreamTravel();
      }

      if (travelStatus == 'arrived' || travelStatus == 'started') {
        if (_cameraType == MapCameraSelected.center) {
          onCenterButtonTap();
        }
      }
      // final status = double.parse('${data['status']}');
      // if (status == 'drivers_available') {
      //   travelFinished = true;
      //   Get.offAllNamed(AppRoutes.TAXI_FINISHED);
      // }
    });
  }

  String travelStatus = 'none';
  final travelStatusLabel = 'Cargando información...'.obs;
  final tiempoRestanteM = "0".obs;
  bool travelFinished = false;
  void _startStreamTravel() async {
    print('_startStreamTravel');
    Stream<DocumentSnapshot> stream =
        _travelInfoProvider.getByIdStreamWithMetaChanges(_authX.getUser!.uid);
    _streamTravelSub?.cancel();
    _streamTravelSub = stream.listen((DocumentSnapshot document) async {
      if (document.data() == null) return;

      if (document.metadata.isFromCache) {
        return;
      }

      final data = document.data() as Map<String, dynamic>;
      final travelInfo = TravelInfo.fromJson(data);
      travelStatus = statusValues.reverse?[travelInfo.status] ?? 'unknown';
      final distanceToFinish = Geolocator.distanceBetween(
          myPosition.latitude,
          myPosition.longitude,
          driverCoords!.latitude,
          driverCoords!.longitude);
      double distanceKm = distanceToFinish / 100;
      double tiempoRestanteH = distanceKm / 50;
      tiempoRestanteM.value = ((tiempoRestanteH * 60).toInt()).toString();
      Helpers.logger.i(tiempoRestanteM.value);
      if (travelStatus == 'accepted') {
        travelStatusLabel.value = 'Tu conductor está en camino...';
      } else if (travelStatus == 'arrived') {
        travelStatusLabel.value = 'Tu conductor ha llegado.';
      } else if (travelStatus == 'started') {
        travelStatusLabel.value = 'Viajando al lugar de destino...';
      } else if (travelStatus == 'finished') {
        if (!travelFinished) {
          // Para evitar llamadas twices
          travelFinished = true;

          Get.offAllNamed(AppRoutes.TAXI_FINISHED);
          return;
        }
      } else if (travelStatus == 'canceled') {
        Get.offAllNamed(AppRoutes.CANCELACION_SERVICIO);
        return;
      }

      if (!travelInfo.codeValidated) {
        if (travelStatus == 'arrived' || travelStatus == 'started') {
          showSecureSection = true;
          if (travelStatus == 'started') {
            secureCodeOk = true;
          } else {
            secureCodeOk = false;
          }
          _resizePanel(345.0);
          if (travelStatus == 'started') {
            hideSecureSection();
          }
        } else {
          showSecureSection = false;
          _resizePanel(210.0);
        }
      }

      _cameraType = MapCameraSelected.bounds;
      _updateDriverPosition();
    });
  }

  Future<void> _resizePanel(double sizeClosed) async {
    panelHeightClosed = sizeClosed;
    panelHeightUpdated = false;
    heightFromWidgets = false;
    update(['gbSlidePanel', 'gbMapButtons']);
    await Helpers.sleep(100); // Importart
    updatePanelMaxHeight();
  }

  Future<void> hideSecureSection({int seconds = 6}) async {
    await Future.delayed(Duration(seconds: seconds));
    showSecureSection = false;
    secureCodeOk = false;
    await _resizePanel(210.0);
    _travelInfoProvider.setCodeValidated(true, _authX.getUser!.uid);
  }

  Future<void> _configMarkers(
      {LatLng? origenPos,
      LatLng? destinoPos,
      LatLng? driverPos,
      double? heading}) async {
    if (origenPos != null) {
      markers
          .removeWhere((marker) => marker.markerId.value == MARKER_ORIGEN_ID);
      markers.add(Marker(
        zIndex: 1,
        anchor: Offset(0.15, 0.5),
        markerId: MarkerId(MARKER_ORIGEN_ID),
        position: origenPos,
        icon: _markerOrigen ?? BitmapDescriptor.defaultMarker,
      ));
    }

    if (destinoPos != null) {
      markers
          .removeWhere((marker) => marker.markerId.value == MARKER_DESTINO_ID);
      markers.add(Marker(
        zIndex: 2,
        anchor: Offset(0.15, 0.5),
        markerId: MarkerId(MARKER_DESTINO_ID),
        position: destinoPos,
        icon: _markerDestino ?? BitmapDescriptor.defaultMarker,
      ));
    }

    if (driverPos != null) {
      markers
          .removeWhere((marker) => marker.markerId.value == MARKER_DRIVER_ID);
      markers.add(Marker(
        zIndex: 3,
        anchor: Offset(0.6, 0.6),
        markerId: MarkerId(MARKER_DRIVER_ID),
        position: driverPos,
        rotation: heading ?? 0.0,
        icon: _markerDriver ?? BitmapDescriptor.defaultMarker,
        flat: true,
      ));
    }
  }

  Future<void> _updateDriverPosition() async {
    if (driverCoords == null ||
        origenCoords == null ||
        destinoCoords == null ||
        driverHeading == null) return;

    await _configMarkers(driverPos: driverCoords, heading: driverHeading);

    if (travelStatus == 'accepted') {
      _removePolyline(POLYPARTIDAKEY);
      markers.removeWhere((e) => e.markerId.value == MARKER_DESTINO_ID);
      polylines.removeWhere((e) => e.polylineId.value == POLYVIAJEKEY);
      _setPolylinePartida();
    } else if (travelStatus == 'arrived' || travelStatus == 'started') {
      _removePolyline(POLYPARTIDAKEY);
      bool existsDestinoMkr = false;
      markers.forEach((e) {
        if (e.markerId.value == MARKER_DESTINO_ID) {
          existsDestinoMkr = true;
        }
      });
      if (!existsDestinoMkr) {
        print('no existe MARKARDOR');
        await _configMarkers(destinoPos: destinoCoords);
      }

      bool existsPolyViaje = false;
      polylines.forEach((e) {
        if (e.polylineId.value == POLYVIAJEKEY) {
          existsPolyViaje = true;
        }
      });
      if (!existsPolyViaje) {
        print('no existe POLYLINA');
        polylines.add(_polyViaje);
      }
    }

    update(['gbOnlyMap']);

    if (_cameraType == MapCameraSelected.bounds) {
      onBoundsButtonTap();
    }
  }

  Future<void> centerTo(LatLng target) async {
    final cameraPosition = CameraPosition(target: target, zoom: defaultZoom);
    final cameraUpdate = CameraUpdate.newCameraPosition(cameraPosition);
    final controller = await _mapController.future;
    controller.animateCamera(cameraUpdate);
  }

  Future<bool> handleBack(BuildContext context) async {
    if (slidePanelController.isPanelOpen) {
      slidePanelController.close();
      return false;
    }

    bool canPop = Navigator.of(context).canPop();
    return canPop;
  }

  MapCameraSelected _cameraType = MapCameraSelected.center;

  void otherButton() {
    Get.toNamed(AppRoutes.TAXI_FINISHED);
    return;
  }

  void onCenterButtonTap() async {
    _cameraType = MapCameraSelected.center;

    if (travelStatus == 'accepted') {
      centerTo(LatLng(myPosition.latitude, myPosition.longitude));
    } else if (travelStatus == 'arrived' || travelStatus == 'started') {
      if (driverCoords != null) {
        centerTo(driverCoords!);
      }
    }
  }

  void onBoundsButtonTap() async {
    if (driverCoords != null && origenCoords != null) {
      _cameraType = MapCameraSelected.bounds;

      if (travelStatus == 'accepted') {
        final bounds = simulateBoundsFromCoords(origenCoords!, driverCoords!);
        _adjustMapToBounds(bounds);
      } else if (travelStatus == 'arrived' || travelStatus == 'started') {
        final bounds = simulateBoundsFromCoords(destinoCoords!, driverCoords!);
        _adjustMapToBounds(bounds);
      }
    }
  }

  void _adjustMapToBounds(LatLngBounds? bounds) async {
    if (bounds == null) return;
    final controller = await _mapController.future;
    try {
      await controller.getVisibleRegion();
    } catch (e) {
      print('Error _adjustMapToBounds');
    }
    var cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 40);
    controller.animateCamera(cameraUpdate);
  }

  void _setPolylinePartida() {
    if (origenCoords != null && driverCoords != null) {
      _polyPartida = _polyPartida.copyWith(
          pointsParam:
              MapsCurvedLines.getPointsOnCurve(origenCoords!, driverCoords!));
      polylines.add(_polyPartida);
    }
  }

  void _removePolyline(String polylineId) {
    polylines
        .removeWhere((polyline) => polyline.polylineId.value == polylineId);
  }

  // **************************************************
  // * ADITIONAL MAP CONTROL
  // **************************************************
  void onUserStartMoveMap(_) {
    if (_cameraType != MapCameraSelected.none) {
      _cameraType = MapCameraSelected.none;
    }
  }

  // **************************************************
  // * ON LOGIC SECURE CODE
  // **************************************************
  bool showSecureSection = false;
  bool secureCodeOk = false;

  // **************************************************
  // * SLIDER ACTIONS
  // **************************************************
  void onEmergencyBtnTap() {
    if (Get.overlayContext == null) return;
    showMaterialModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0))),
        context: Get.overlayContext!,
        builder: (_) => EmergencyOptions());
  }

  Future<void> canceledTravel() async {
    DateTime today = new DateTime.now();
    final travelResp =
        await _travelInfoProvider.getByUidClient(_authX.getUser!.uid);
    ParamsCancelacionesServicios dataParamsCancelacionesServicios =
        new ParamsCancelacionesServicios(
      idCancelacionesServiciosCli: 0,
      idCliente: _authX.backendUser!.idCliente,
      idServicio: travelResp!.idServicio,
      fecha: today,
    );
    print("aaaaaaaa");
    print(dataParamsCancelacionesServicios.idCliente);
    print(dataParamsCancelacionesServicios.idServicio);
    await _travelInfoProvider.update(
        _authX.getUser!,
        {
          'status': 'canceled',
          'startDate': FieldValue.serverTimestamp(),
          'finishDate': FieldValue.serverTimestamp()
        },
        _authX.getUser!.uid);
    final resp = await _cancelacionesServiciosProvider
        .create(dataParamsCancelacionesServicios);
    Helpers.logger.wtf(resp.toJson().toString());
    // Get.offAllNamed(AppRoutes.HOME);
  }

  // **************************************************
  // * SLIDER BOTTOM
  // **************************************************
  final slidePanelController = PanelController();
  final panelTitleKey = GlobalKey();
  final panelBodyKey = GlobalKey();
  bool panelHeightUpdated = false;
  bool heightFromWidgets = false;
  double panelHeightOpen = 400;
  double panelHeightClosed = 210.0;
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
      update(['gbSlidePanel']);
    } catch (e) {
      print(e);
    }
  }

  void call105() async {
    const number = '105';
    String url = 'tel:$number';
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      print('error ');
    }
  }

  final _sosservicioProvider = SosservicioProvider();

  void sendSOS() async {
    try {
      loading.value = true;

      final response =
          await Helpers.confirmDialog('¿Seguro(a) que desea enviar la alerta?');

      final travelResp =
          await _travelInfoProvider.getByUidClient(_authX.getUser!.uid);

      if (response!) {
        final lastPosition = await Geolocator.getCurrentPosition();
        _myPosition = lastPosition;
        final newSosservicio = new SosservicioDto(
            idSosServicio: 0,
            fechaHora: DateTime.now(),
            motivo: '',
            enable: 1,
            idServicio: travelResp!.idServicio,
            tipoPersona: 'pasajero',
            estado: 1,
            cordLat: _myPosition.latitude,
            cordLon: _myPosition.longitude);
        final result = await _sosservicioProvider.create(newSosservicio);
        AppSnackbar().info(message: 'ALERTA ENVIADA');
      }
    } on ApiException catch (e) {
      String errormsg = AppIntl.getFirebaseErrorMessage(e.message);
      Helpers.showError(errormsg);
    } catch (e) {
      Helpers.showError('¡Opps! Parece que hubo un problema.',
          devError: e.toString());
    } finally {
      loading.value = false;
    }
  }
}

enum MapCameraSelected { none, center, bounds }
