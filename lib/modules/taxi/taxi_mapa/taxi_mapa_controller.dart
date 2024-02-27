import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:app_pasajero_ns/config/config.dart';
import 'package:app_pasajero_ns/data/models/busqueda_select.dart';
import 'package:app_pasajero_ns/data/models/concepto.dart';
import 'package:app_pasajero_ns/data/models/driving_request_param.dart';
import 'package:app_pasajero_ns/data/models/google_driving_response.dart';
import 'package:app_pasajero_ns/data/models/solicitud_pasajero.dart';
import 'package:app_pasajero_ns/data/providers/concepto_provider.dart';
import 'package:app_pasajero_ns/data/providers/servicio_provider.dart';
import 'package:app_pasajero_ns/data/providers/solicitud_pasajero_provider.dart';
import 'package:app_pasajero_ns/data/providers/travel_info_provider.dart';
import 'package:app_pasajero_ns/data/services/autocomplete_place_service.dart';
import 'package:app_pasajero_ns/data/services/geocoding_service.dart';
import 'package:app_pasajero_ns/data/services/routing_service.dart';
import 'package:app_pasajero_ns/modules/auth/auth_controller.dart';
import 'package:app_pasajero_ns/modules/misc/error/misc_error_controller.dart';
import 'package:app_pasajero_ns/modules/taxi/taxi_mapa/components/adondevamos/layer_adondevamos_ctlr.dart';
import 'package:app_pasajero_ns/modules/taxi/taxi_mapa/components/buscar/layer_buscar_ctlr.dart';
import 'package:app_pasajero_ns/modules/taxi/taxi_mapa/components/buscar/widget/route_not_available.dart';
import 'package:app_pasajero_ns/modules/taxi/taxi_mapa/components/pickup/layer_pickup_cltr.dart';
import 'package:app_pasajero_ns/modules/taxi/taxi_mapa/components/programado/layer_programado_ctlr.dart';
import 'package:app_pasajero_ns/modules/taxi/taxi_mapa/components/reserva/layer_reserva_ctlr.dart';
import 'package:app_pasajero_ns/modules/taxi/taxi_mapa/components/solicitando/layer_solicitando_ctlr.dart';
import 'package:app_pasajero_ns/modules/taxi/taxi_mapa/components/tarifa/layer_tarifa_ctlr.dart';
import 'package:app_pasajero_ns/routes/app_pages.dart';
import 'package:app_pasajero_ns/themes/ak_ui.dart';
import 'package:app_pasajero_ns/themes/fresh_map_theme.dart';
import 'package:app_pasajero_ns/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as lct;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:uuid/uuid.dart';

enum BusquedaView { origen, destino }

enum ModoVista {
  adondevamos,
  reserva,
  searchaddress,
  calculando,
  tarifa,
  pickup,
  solicitando,
  programado,
}

enum AnimatingMap { orig, dest, both }

enum ServiceType { regular, reservation }

class TaxiMapaArguments {
  final ServiceType type;

  TaxiMapaArguments({required this.type});
}

class TaxiMapaController extends GetxController with WidgetsBindingObserver {
  // Instances
  late TaxiMapaController _self;
  TaxiMapaController get self => this._self;

  final _authX = Get.find<AuthController>();
  final _routing = RoutingService();
  final _solicitudProvider = SolicitudProvider();
  final _servicioProvider = ServicioProvider();
  final _travelInfoProvider = TravelInfoProvider();

  ServiceType _typeService = ServiceType.regular;
  ServiceType get typeService => this._typeService;

  // GetBuilders ID's
  final gbOnlyMap = 'gbOnlyMap';
  final gbMarkers = 'gbMarkers';

  GetStorage? box;

  // Google API Variables
  late String _sessionToken;
  late AutocompletePlaceService autocompletePlaceService;
  final lct.Location location = lct.Location.instance;
  final _geocoding = GeocodingService();
  final _polylinePointsLib = PolylinePoints();
  final _conceptoProvider = ConceptoProvider();
  final loading = false.obs;
  // Scaffoold
  final smKey = GlobalKey<ScaffoldMessengerState>();
  // View
  final modoVista = (ModoVista.adondevamos).obs;
  BusquedaSelectProvider tipoMarcadorManual = BusquedaSelectProvider.ORIGEN;
  // Mapa
  bool existsPosition = false;
  final isLocalizando = true.obs;
  CameraPosition? initialPosition;
  final defaultZoom = 16.0;
  final pickUpZoom = 17.5;
  final _mapController = Completer<GoogleMapController>();
  EdgeInsets mapInsetPadding = EdgeInsets.all(0);
  final Set<Marker> markers = HashSet<Marker>();
  final Set<Polyline> polylines = HashSet<Polyline>();
  // Mi ubicación
  late Position _myPosition;
  Position get myPosition => this._myPosition;
  StreamSubscription<Position>? _myPositionStream;
  String _myPositonName = 'Mi ubicación';
  String get myPositonName => this._myPositonName;
  // Markers
  static const MARKER_ORIGEN_ID = 'origen';
  static const MARKER_DESTINO_ID = 'destino';
  static const MARKER_PICKUP_ID = 'pickup';
  final markerOrigenKey = GlobalKey();
  final markerDestinoKey = GlobalKey();
  final markerPickupKey = GlobalKey();
  // Streams
  StreamSubscription<String>? _myPositionAddressNameFutureSub;
  // Default StylePolyline
  static const POLYLINE_RUTA_ID = 'mi_ruta';
  Polyline _miRutaDestino = new Polyline(
      polylineId: PolylineId(POLYLINE_RUTA_ID),
      width: 3,
      color: akPrimaryColor);

  @override
  void onInit() {
    super.onInit();
    _self = this;
    WidgetsBinding.instance?.addObserver(this);

    if (!(Get.arguments is TaxiMapaArguments)) {
      Helpers.showError('Falta pasar los argumentos');
      return;
    }

    final arguments = Get.arguments as TaxiMapaArguments;
    _typeService = arguments.type;

    _init();
  }

  @override
  void onClose() {
    WidgetsBinding.instance?.removeObserver(this);
    _myPositionStream?.cancel();
    _myPositionAddressNameFutureSub?.cancel();

    _pickAddressNameFutureSub?.cancel();

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
    // Config for Search address
    _sessionToken = Uuid().v4();
    autocompletePlaceService = AutocompletePlaceService(_sessionToken);

    _loadFavoritesFromStorage();

    // Config for Map
    await Helpers.sleep(400);
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();

    if (isLocationEnabled) {
      _configPosition();
    } else {
      bool gpsEnabled = await location.requestService();

      if (gpsEnabled) {
        _configPosition();
      } else {
        final ers = await Get.toNamed(AppRoutes.MISC_ERROR,
            arguments: MiscErrorArguments(
                content:
                    'Es necesario activar la localización para poder continuar'));
        if (ers == MiscErrorResult.retry) {
          await Helpers.sleep(1500);
          _init();
        }
      }
    }
  }

  Future<void> _loadFavoritesFromStorage() async {
    box = GetStorage();
    if (box != null) {
      final userUid = box!.read('user_uid');
      if (userUid != _authX.getUser!.uid) {
        await box!.write('user_uid', _authX.getUser!.uid);
        await box!.write('search_favorites', null);
      }
    }
  }

  Future<void> _configPosition() async {
    try {
      final lastPosition = await Geolocator.getCurrentPosition();
      _myPosition = lastPosition;
      await _initialConfigMap();

      update([gbOnlyMap]);
      // La primera búsqueda de dirección
      _findMyPositionAddressName(_myPosition);

      await _myPositionStream?.cancel();
      _myPositionStream =
          Geolocator.getPositionStream().listen((Position position) {
        _myPosition = position;
        if (modoVista.value == ModoVista.adondevamos) {
          centerToMyPosition();
          _findMyPositionAddressName(_myPosition);
        }
      });
    } catch (e) {
      Helpers.logger.e('Error en: _configPosition');
    }
  }

  Future<void> _initialConfigMap() async {
    if (!existsPosition && isLocalizando.value) {
      existsPosition = true;
      initialPosition = CameraPosition(
        target: LatLng(_myPosition.latitude, _myPosition.longitude),
        zoom: defaultZoom,
      );

      await cambiarModoVista(_typeService == ServiceType.regular
          ? ModoVista.adondevamos
          : ModoVista.reserva);
      await Future.delayed(Duration(milliseconds: 1100));
      update([gbOnlyMap]);
      isLocalizando.value = false;
    }
  }

  Future<void> _findMyPositionAddressName(Position pos) async {
    _myPositionAddressNameFutureSub?.cancel();
    _myPositionAddressNameFutureSub = _geocoding
        .getAddressName(LatLng(pos.latitude, pos.longitude))
        .asStream()
        .listen((String streetname) {
      _myPositonName = streetname;
    });
  }

  bool _cambiandoModoVista = false;
  Future<void> cambiarModoVista(ModoVista modo) async {
    if (_cambiandoModoVista) return;
    _cambiandoModoVista = true;

    await Get.delete<LayerAdondeVamosCtlr>();
    await Get.delete<LayerReservaCtlr>();
    await Get.delete<LayerBuscarCtlr>();
    await Get.delete<LayerTarifaCtlr>();
    await Get.delete<LayerPickupCtlr>();
    await Get.delete<LayerSolicitandoCtlr>();
    await Get.delete<LayerProgramadoCtlr>();

    final previousModo = modoVista.value;

    switch (modo) {
      case ModoVista.adondevamos:
        confirmedPickup = false;
        _tarifaDisplayed = false;
        Get.focusScope?.unfocus();
        await Get.putAsync(() async => LayerAdondeVamosCtlr());
        modoVista.value = modo;
        _updatePaddingMap(bottom: 120.0);
        _removeMarkersAndPolyline();
        await Helpers.sleep(300);
        centerToMyPosition();
        break;
      case ModoVista.reserva:
        _tarifaDisplayed = false;
        Get.focusScope?.unfocus();
        await Get.putAsync(() async => LayerReservaCtlr());
        modoVista.value = modo;
        _updatePaddingMap(bottom: 120.0);
        _removeMarkersAndPolyline();
        await Helpers.sleep(300);
        centerToMyPosition();
        break;
      case ModoVista.searchaddress:
        final _searchX = await Get.putAsync(() async => LayerBuscarCtlr());
        modoVista.value = modo;
        _updatePaddingMap(top: 130.0, bottom: 5.0);

        // Helpers.logger.wtf(previousModo);
        // Helpers.logger.wtf(modo);

        if (previousModo == ModoVista.adondevamos ||
            previousModo == ModoVista.reserva) {
          _searchX.actionsFromAdondeVamosLayer();
        } else if (previousModo == ModoVista.tarifa) {
          _searchX.actionsFromTarifaLayer();
        }
        break;
      case ModoVista.calculando:
        Get.focusScope?.unfocus();
        modoVista.value = modo;
        _updatePaddingMap(bottom: 182.0);
        break;
      case ModoVista.tarifa:
        Get.focusScope?.unfocus();
        final _tarifaX = await Get.putAsync(() async => LayerTarifaCtlr());
        modoVista.value = modo;
        if (typeService == ServiceType.regular) {
          _updatePaddingMap(
              bottom: _tarifaX.panelHeightClosed + _tarifaX.footerSpace - 12.0);
        } else {
          _updatePaddingMap(bottom: _tarifaX.footerSpace - 5.0);
        }
        await showHideMarkersPolyline(true);
        await Helpers.sleep(300);
        centerToRoute();
        break;
      case ModoVista.pickup:
        Get.focusScope?.unfocus();
        await Get.putAsync(() async => LayerPickupCtlr());
        modoVista.value = modo;
        _updatePaddingMap(bottom: 170.0);
        await showHideMarkersPolyline(false);
        await Helpers.sleep(300);
        final toc = tarifaOrigenCoords!;
        centerTo(LatLng(toc.latitude, toc.longitude), zoom: pickUpZoom);
        break;
      case ModoVista.solicitando:
        Get.focusScope?.unfocus();
        final _solicitandoX =
            await Get.putAsync(() async => LayerSolicitandoCtlr());
        modoVista.value = modo;
        _updatePaddingMap(bottom: 170.0);
        await showHideMarkersPolyline(true);
        await Helpers.sleep(300);
        centerToRoute();
        _solicitandoX.initialActions();
        break;
      case ModoVista.programado:
        Get.focusScope?.unfocus();
        await Get.putAsync(() async => LayerProgramadoCtlr());
        modoVista.value = modo;
        _updatePaddingMap(bottom: 182.0);
        break;
    }

    _cambiandoModoVista = false; // Termina de forma segura el cambio de vista
  }

  Future<bool> handleBack() async {
    if (loading.value || recalculating.value) {
      return false;
    }

    switch (modoVista.value) {
      case ModoVista.adondevamos:
        return true;
      case ModoVista.reserva:
        return true;
      case ModoVista.searchaddress:
        try {
          final _layerBuscarX = Get.find<LayerBuscarCtlr>();
          if (!_layerBuscarX.isSearchResultListVisible.value) {
            _layerBuscarX.setInputsWithPreviousSavedData();
            _layerBuscarX.isSearchResultListVisible.value = true;

            await Helpers.sleep(300);
            if (_layerBuscarX.busquedaView == BusquedaView.origen) {
              _layerBuscarX.focusNodeOrigen.requestFocus();
            } else {
              _layerBuscarX.focusNodeDestino.requestFocus();
            }
          } else {
            if (_tarifaDisplayed) {
              Get.focusScope?.unfocus();
              await cambiarModoVista(ModoVista.tarifa);
            } else {
              Get.focusScope?.unfocus();
              await cambiarModoVista(_typeService == ServiceType.regular
                  ? ModoVista.adondevamos
                  : ModoVista.reserva);
            }
          }
        } catch (e) {
          Helpers.logger.e('No se encontró controlador de buscar');
        }
        return false;
      case ModoVista.calculando:
        return false;
      case ModoVista.tarifa:
        await cambiarModoVista(_typeService == ServiceType.regular
            ? ModoVista.adondevamos
            : ModoVista.reserva);
        return false;
      case ModoVista.pickup:
        if (_tarifaDisplayed) {
          await cambiarModoVista(ModoVista.tarifa);
        }
        return false;
      case ModoVista.solicitando:
        return false;
      case ModoVista.programado:
        return false;
    }
  }

  // *******************************************
  // ******* VARIABLES ORIGEN/DESTINO **********
  // *******************************************
  // Search - Origen
  String savedOrigenName = '';
  String? savedOrigenPlaceId;
  LatLng? savedOrigenCoords;
  // Search - Destino
  String savedDestinoName = '';
  String? savedDestinoPlaceId;
  LatLng? savedDestinoCoords;

  void setSaveOrigenData({
    required String address,
    String? placeId,
    LatLng? coords,
  }) {
    if (placeId != null && coords != null) {
      Helpers.showError('No puede asignar placeId y Coords a la vez');
      return;
    }
    if (placeId == null && coords == null) {
      Helpers.showError('Debe asignar placeId o coords');
      return;
    }
    savedOrigenName = address;
    savedOrigenPlaceId = placeId;
    savedOrigenCoords = coords;
  }

  void setSaveDestinoData(
      {required String address, String? placeId, LatLng? coords}) {
    if (placeId != null && coords != null) {
      Helpers.showError('No puede asignar placeId y Coords a la vez');
      return;
    }
    if (placeId == null && coords == null) {
      Helpers.showError('Debe asignar placeId o coords');
      return;
    }
    savedDestinoName = address;
    savedDestinoPlaceId = placeId;
    savedDestinoCoords = coords;
  }

  // *******************************************
  // ********** MAP CONTROL FUNCTIONS **********
  // *******************************************
  void onMapCreated(GoogleMapController controller) {
    controller.setMapStyle(jsonEncode(freshMapTheme));
    if (!_mapController.isCompleted) {
      _mapController.complete(controller);
    }
  }

  void _updatePaddingMap({double top = 65.0, double bottom = 0.0}) {
    mapInsetPadding = EdgeInsets.only(
        top: akContentPadding + top,
        bottom: akContentPadding + bottom,
        left: akContentPadding,
        right: akContentPadding);
    update([gbOnlyMap]);
  }

  void centerToRoute() async {
    _adjustMapToBounds(tarifaRouteBounds);
  }

  Future<void> centerToMyPosition() async {
    final cameraPosition = CameraPosition(
      target: (modoVista.value == ModoVista.pickup)
          ? LatLng(tarifaOrigenCoords!.latitude, tarifaOrigenCoords!.longitude)
          : LatLng(myPosition.latitude, myPosition.longitude),
      zoom: (modoVista.value == ModoVista.pickup) ? pickUpZoom : defaultZoom,
    );
    final cameraUpdate = CameraUpdate.newCameraPosition(cameraPosition);
    final controller = await _mapController.future;
    controller.animateCamera(cameraUpdate);
  }

  Future<void> centerTo(LatLng target, {double? zoom}) async {
    final cameraPosition =
        CameraPosition(target: target, zoom: zoom ?? defaultZoom);
    final cameraUpdate = CameraUpdate.newCameraPosition(cameraPosition);
    final controller = await _mapController.future;
    controller.animateCamera(cameraUpdate);
  }

  void _adjustMapToBounds(LatLngBounds? bounds) async {
    if (bounds == null) return;
    final controller = await _mapController.future;
    await controller.getVisibleRegion();
    var cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 40);
    controller.animateCamera(cameraUpdate);
  }

  void _removeMarkersAndPolyline() {
    markers.removeWhere((marker) => marker.markerId.value == MARKER_PICKUP_ID);
    markers.removeWhere((marker) => marker.markerId.value == MARKER_ORIGEN_ID);
    markers.removeWhere((marker) => marker.markerId.value == MARKER_DESTINO_ID);
    polylines.removeWhere(
        (polyline) => polyline.polylineId.value == POLYLINE_RUTA_ID);
  }

  Future<void> _setMarkersAndPolyline() async {
    if (tarifaOrigenCoords == null || tarifaDestinoCoords == null) {
      Helpers.showError('Hubo un problema seteando los marcadores');
      return;
    }
    update([gbMarkers]);
    await Helpers.sleep(200);
    markers.add(Marker(
      zIndex: 1,
      anchor: Offset(0.15, 0.70),
      markerId: MarkerId(MARKER_ORIGEN_ID),
      position: tarifaOrigenCoords!,
      onTap: () => _onMarkerTap(BusquedaView.origen),
      icon: await Helpers.getCustomIcon(markerOrigenKey) ??
          BitmapDescriptor.defaultMarker,
    ));
    markers.add(Marker(
      zIndex: 2,
      anchor: Offset(0.15, 0.70),
      markerId: MarkerId(MARKER_DESTINO_ID),
      position: tarifaDestinoCoords!,
      onTap: () => _onMarkerTap(BusquedaView.destino),
      icon: await Helpers.getCustomIcon(markerDestinoKey) ??
          BitmapDescriptor.defaultMarker,
    ));

    polylines.add(_miRutaDestino);
  }

  Future<void> showHideMarkersPolyline(bool show) async {
    if (show) {
      _removeMarkersAndPolyline();
      await _setMarkersAndPolyline();
    } else {
      _removeMarkersAndPolyline();
    }
    update([gbOnlyMap]);
  }

  Future<void> showPickupMarker(bool show, {LatLng? coords}) async {
    if (show) {
      if (coords == null) {
        Helpers.logger.e('Error! Se necesitan pasar coords a showPickupMarker');
      }
    }
    if (show) {
      _removeMarkersAndPolyline();
      markers.add(Marker(
        zIndex: 1,
        anchor: Offset(0.50, 0.70),
        markerId: MarkerId(MARKER_PICKUP_ID),
        position: coords ?? LatLng(0, 0),
        icon: await Helpers.getCustomIcon(markerPickupKey) ??
            BitmapDescriptor.defaultMarker,
      ));
    } else {
      _removeMarkersAndPolyline();
    }
    update([gbOnlyMap]);
  }

  // **************************************************
  // ****** LÓGICA PICK POSITION / FIJAR EN MAPA ******
  // **************************************************
  StreamSubscription<String>? _pickAddressNameFutureSub;
  LatLng? lastPositionOnMoving;
  final movingPickMap = false.obs;
  final searchingAddressFromPick = false.obs;
  final pickupAddressName = ''.obs;

  bool confirmedPickup = false;

  void resetPickUpVariables() {
    _pickAddressNameFutureSub?.cancel();
    lastPositionOnMoving = null;
    movingPickMap.value = false;
    searchingAddressFromPick.value = false;
    pickupAddressName.value = 'Localizando...';
  }

  void onMapMoving(CameraPosition cameraPosition) {
    if (modoVista.value == ModoVista.searchaddress) {
      try {
        final _localSearchX = Get.find<LayerBuscarCtlr>();
        if (!_localSearchX.isSearchResultListVisible.value) {
          movingPickMap.value = true;
          lastPositionOnMoving = cameraPosition.target;
        }
      } catch (e) {
        Helpers.logger.e('No hay controlador del buscador');
      }
    }

    if (modoVista.value == ModoVista.pickup) {
      movingPickMap.value = true;
      lastPositionOnMoving = cameraPosition.target;
    }
  }

  void onMapStopCamera() async {
    if (modoVista.value == ModoVista.searchaddress) {
      movingPickMap.value = false;

      try {
        final _localSearchX = Get.find<LayerBuscarCtlr>();
        if (!_localSearchX.isSearchResultListVisible.value) {
          if (this.lastPositionOnMoving != null) {
            _pickAddressNameFutureSub?.cancel();
            searchingAddressFromPick.value = true;

            if (_localSearchX.busquedaView == BusquedaView.origen) {
              _localSearchX.origenCtlr.text = 'Buscando...';
            } else {
              _localSearchX.destinoCtlr.text = 'Buscando...';
            }

            _pickAddressNameFutureSub = _geocoding
                .getAddressName(this.lastPositionOnMoving!)
                .asStream()
                .listen((String streetname) async {
              if (_localSearchX.busquedaView == BusquedaView.origen) {
                _localSearchX.origenCtlr.text = streetname;
              } else {
                _localSearchX.destinoCtlr.text = streetname;
              }

              searchingAddressFromPick.value = false;
            });
          }
        }
      } catch (e) {
        Helpers.logger.e('No hay controlador del buscador');
      }
    }

    if (modoVista.value == ModoVista.pickup) {
      movingPickMap.value = false;
      if (this.lastPositionOnMoving != null) {
        _pickAddressNameFutureSub?.cancel();
        searchingAddressFromPick.value = true;

        pickupAddressName.value = 'Buscando...';

        _pickAddressNameFutureSub = _geocoding
            .getAddressName(this.lastPositionOnMoving!)
            .asStream()
            .listen((String streetname) async {
          pickupAddressName.value = streetname;

          searchingAddressFromPick.value = false;
        });
      }
    }
  }

  final recalculating = false.obs;
  final enableBackRecalculating = false.obs;

  // **************************************************
  // ************ LÓGICA DE OBTENER RUTA **************
  // **************************************************
  final fetchingGoogleRoute = false.obs;

  Future<void> calculateRouteFromGoogle() async {
    String? errorMsg;
    GoogleDrivingResponse? googleResp;
    try {
      this.fetchingGoogleRoute.value = true;

      final _paramOrigen = DrivingRequestParams(
        coords: savedOrigenCoords,
        placeId: savedOrigenPlaceId,
      );
      final _paramDestino = DrivingRequestParams(
        coords: savedDestinoCoords,
        placeId: savedDestinoPlaceId,
      );

      googleResp = await _routing.calculateRoute(_paramOrigen, _paramDestino);
    } on ApiException catch (e) {
      errorMsg = e.message;
      Helpers.logger.e(e.message);
    } catch (e) {
      errorMsg = 'Ocurrió un error inesperado.';
      Helpers.logger.e(e.toString());
    }

    if (_self.isClosed) return;
    if (errorMsg != null) {
      final ers = await Get.toNamed(AppRoutes.MISC_ERROR,
          arguments: MiscErrorArguments(content: errorMsg));
      if (ers == MiscErrorResult.retry) {
        await Helpers.sleep(1500);
        calculateRouteFromGoogle();
      } else {
        this.fetchingGoogleRoute.value = false;
        await cambiarModoVista(_typeService == ServiceType.regular
            ? ModoVista.adondevamos
            : ModoVista.reserva);
        return;
      }
    } else {
      this.fetchingGoogleRoute.value = false;
      if (googleResp!.status == 'OK') {
        _onRouteSuccess(googleResp);
      } else {
        _showNotFoundRoute();
      }
    }
  }

  // **************************************************
  // **** LÓGICA DE LA VISTA TARIFA / DIBUJAR RUTA ****
  // **************************************************
  String tarifaOrigenName = '';
  LatLng? tarifaOrigenCoords;
  String tarifaDestinoName = '';
  LatLng? tarifaDestinoCoords;
  LatLngBounds? tarifaRouteBounds;
  String tarifaPolyline = '';
  int tarifaDistanciaM = 0;
  int tarifaDuracionS = 0;
  bool _tarifaDisplayed = false;
  bool get tarifaDisplayed => this._tarifaDisplayed;

  List<SCTarifa> tarifas = [];
  late SCTarifa tarifaSelected;

  Future<void> _onRouteSuccess(GoogleDrivingResponse data) async {
    _removeMarkersAndPolyline();

    await cambiarModoVista(ModoVista.calculando);

    final firstRoute = data.routes.first;
    final firstTramo = firstRoute.legs.first;

    // Begin::Calcula la tarifa
    ConceptoSimulacionCliente? totalAproxResp;
    tryCatch(
      self: _self,
      code: () async {
        totalAproxResp = await _conceptoProvider.simulacionCliente(
          metros: firstTramo.distance.value,
          segundos: firstTramo.duration.value,
        );
        if (!(totalAproxResp!.success) || totalAproxResp!.data.data.isEmpty) {
          throw BusinessException('No se pudo obtener la lista de tarifas.');
        }
        await Helpers.sleep(500);
        setTarifaVariables(data, totalAproxResp!);
        await cambiarModoVista(ModoVista.tarifa);
      },
      onCancelRetry: () async {
        await cambiarModoVista(_typeService == ServiceType.regular
            ? ModoVista.adondevamos
            : ModoVista.reserva);
      },
    );
  }

  void setTarifaVariables(
      GoogleDrivingResponse data, ConceptoSimulacionCliente totalAproxResp,
      {bool hasUserSelected = false}) {
    tarifas = totalAproxResp.data.data;

    if (hasUserSelected) {
      // Si el usuario ya había seleccionado. Busca el tipo seleccionado
      // en la nueva lista de tarifas
      final _idxSelected = tarifas
          .indexWhere((e) => e.idTipoVehiculo == tarifaSelected.idTipoVehiculo);

      if (_idxSelected >= 0) {
        tarifaSelected = tarifas[_idxSelected];
      } else {
        tarifaSelected = tarifas.first;
      }
    } else {
      // Cuando el usuario aún no seleccionó
      tarifaSelected = tarifas.first;
    }

    final route = data.routes.first;
    final tramo = route.legs.first;

    // Begin::Configura Markers y Polyline
    tarifaPolyline = route.overviewPolyline.points;
    final points = _polylinePointsLib.decodePolyline(tarifaPolyline);
    final routeCoords =
        points.map((point) => LatLng(point.latitude, point.longitude)).toList();
    _miRutaDestino = _miRutaDestino.copyWith(pointsParam: routeCoords);
    tarifaOrigenName = tramo.startAddress;
    tarifaOrigenCoords =
        LatLng(tramo.startLocation.lat, tramo.startLocation.lng);
    tarifaDestinoName = tramo.endAddress;
    tarifaDestinoCoords = LatLng(tramo.endLocation.lat, tramo.endLocation.lng);
    tarifaDistanciaM = tramo.distance.value;
    tarifaDuracionS = tramo.duration.value;
    tarifaRouteBounds = getBoundsFromGoogleLatLng(route.bounds);
    _tarifaDisplayed = true;
  }

  Future<void> _showNotFoundRoute() async {
    final resp = await showMaterialModalBottomSheet(
      context: Get.overlayContext!,
      backgroundColor: Colors.transparent,
      builder: (context) => RouteNotAvailable(
        onModifyTap: () => Get.back(result: true),
      ),
    );
    if (resp is bool && resp == true) {
      _cleanDestinonData();

      try {
        final _localSearchX = Get.find<LayerBuscarCtlr>();
        _localSearchX.destinoCtlr.text = '';
        await Helpers.sleep(200);
        _localSearchX.focusNodeDestino.requestFocus();
        centerToMyPosition();
      } catch (e) {
        Helpers.logger.e('No hay el controlador de buscar');
      }
    }
  }

  void _cleanDestinonData() {
    savedDestinoName = '';
    savedDestinoPlaceId = null;
    savedDestinoCoords = null;
  }

  void _onMarkerTap(BusquedaView type) async {
    if (modoVista.value != ModoVista.tarifa) return;
    await cambiarModoVista(ModoVista.searchaddress);

    try {
      final _localSearchX = Get.find<LayerBuscarCtlr>();
      if (type == BusquedaView.origen) {
        _localSearchX.focusNodeOrigen.requestFocus();
      } else {
        _localSearchX.focusNodeDestino.requestFocus();
      }
    } catch (e) {
      Helpers.logger.e('No hay controlador buscar');
    }
  }

  // **************************************************
  // ********* RESERVA DE TAXI: VARIABLES  ************
  // **************************************************
  final tipoReserva = (TaxiReservaType.ida).obs;
  final fechaIda = Rxn<DateTime>();
  final fechaVuelta = Rxn<DateTime>();
  final cantAdultos = 1.obs;
  final cantNinos = 0.obs;
  final cantBebes = 0.obs;
  final cantMaletasGrandes = 0.obs;
  final cantMaletasMedianas = 0.obs;
  final cantMochilas = 0.obs;
  final reservaComentario = TextEditingController();

  void resetReservaVariables() {
    tipoReserva.value = TaxiReservaType.ida;

    fechaIda.value = null;
    fechaVuelta.value = null;

    cantAdultos.value = 1;
    cantNinos.value = 0;
    cantBebes.value = 0;
    cantMaletasGrandes.value = 0;
    cantMaletasMedianas.value = 0;
    cantMochilas.value = 0;
  }

  // ************************************************************
  // **** CREACIÓN DE SOLICITUD/SERVICIO: REGULAR O RESERVA  ****
  // ************************************************************

  Future<void> createSolicitudPasajero({
    void Function(SolicitudPasajeroResponse)? onSuccess,
    void Function()? onRetry,
    void Function()? onCancel,
  }) async {
    if (tarifaOrigenCoords == null || tarifaDestinoCoords == null) {
      Helpers.showError('Solicitud: Error en los parámetros');
      return null;
    }

    String? errorMsg;
    loading.value = true;
    SolicitudPasajeroResponse? solicitudResp;

    Helpers.logger.wtf(_typeService);

    try {
      final solicitudPasajero = new SolicitudPasajeroCreate(
        idCliente: _authX.backendUser!.idCliente,
        coordenadaOrigen:
            "${tarifaOrigenCoords!.latitude},${tarifaOrigenCoords!.longitude}",
        coordenadaDestino:
            "${tarifaDestinoCoords!.latitude},${tarifaDestinoCoords!.longitude}",
        nombreDestino: tarifaDestinoName,
        nombreOrigen: tarifaOrigenName,
        polyline: tarifaPolyline,
        idTipoServicio: _typeService == ServiceType.regular
            ? Config.ID_TIPO_SERVICIO_REGULAR
            : Config.ID_TIPO_SERVICIO_TURISTICO, // Taxi básico
        distancia: tarifaDistanciaM,
        duracion: tarifaDuracionS,
        total: double.parse(tarifaSelected.precioCalculado),
      );

      Helpers.logger.wtf(solicitudPasajero.toJson().toString());

      if (_typeService != ServiceType.reservation) {
        solicitudResp =
            await _solicitudProvider.createregular(solicitudPasajero);
      } else {
        solicitudResp =
            await _solicitudProvider.createreserva(solicitudPasajero);
      }

      Helpers.logger.wtf(solicitudResp.toJson().toString());

      var servicio = (await _servicioProvider
              .getById(solicitudResp.idServicio)) //  + 4500))
          .data;

      servicio!.idTipoVehiculo = tarifaSelected.idTipoVehiculo;

      if (_typeService == ServiceType.reservation) {
        servicio.fechaSalida = fechaIda.value;
        servicio.fechaLlegada = fechaVuelta.value;

        servicio.cantPasajeros =
            cantAdultos.value + cantNinos.value + cantBebes.value;

        servicio.cantAdultosPasajeros = cantAdultos.value;
        servicio.cantNinosPasajeros = cantNinos.value;
        servicio.cantBebesPasajeros = cantBebes.value;
        servicio.cantMaletasGrandes = cantMaletasGrandes.value;
        servicio.cantMaletasMedianas = cantMaletasMedianas.value;
        servicio.cantMochilas = cantMochilas.value;
        servicio.comentario = reservaComentario.text;
      }

      Helpers.logger.wtf(servicio.toJson().toString());

      await _servicioProvider.update(servicio);

      // tryCatch(
      //   code: () async {
      //     Map<String, dynamic> data = {'costo': servicio.costo};
      //     await _travelInfoProvider.update(
      //         _authX.getUser!, data, _authX.getUser!.uid);
      //   },
      //   onError: (e) async => false,
      // );
    } on ApiException catch (e) {
      errorMsg = e.message;
      Helpers.logger.e(e.message);
    } on BusinessException catch (e) {
      errorMsg = e.message;
      Helpers.logger.e(e.message);
    } catch (e) {
      errorMsg = 'Ocurrió un error inesperado.';
      Helpers.logger.e('Error en getInitialData:' + e.toString());
    }

    if (_self.isClosed) return;
    if (errorMsg != null) {
      final ers = await Get.toNamed(AppRoutes.MISC_ERROR,
          arguments: MiscErrorArguments(content: errorMsg));
      if (ers == MiscErrorResult.retry) {
        await Helpers.sleep(1500);
        onRetry?.call();
      } else {
        loading.value = false;
        onCancel?.call();
      }
    } else {
      loading.value = false;
      onSuccess?.call(solicitudResp!);
    }
  }

  void setupReservaLogic() {
    createSolicitudPasajero(onSuccess: (resp) {
      cambiarModoVista(ModoVista.programado);
    }, onCancel: () {
      cambiarModoVista(typeService == ServiceType.regular
          ? ModoVista.adondevamos
          : ModoVista.reserva);
    }, onRetry: () {
      setupReservaLogic();
    });
  }

  Future<void> whenPriceAndPositionConfirmed() async {
    if (typeService == ServiceType.reservation) {
      setupReservaLogic();
    } else {
      await cambiarModoVista(ModoVista.solicitando);
    }
  }
}
