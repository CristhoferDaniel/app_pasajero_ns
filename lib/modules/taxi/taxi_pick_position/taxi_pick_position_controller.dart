/* import 'dart:async';
import 'dart:convert';

import 'package:app_pasajero_ns/data/services/geocoding_service.dart';
import 'package:app_pasajero_ns/modules/taxi/taxi_mapa/taxi_mapa_controller.dart';
import 'package:app_pasajero_ns/modules/taxi/taxi_search/taxi_search_controller.dart';
import 'package:app_pasajero_ns/themes/ak_ui.dart';
import 'package:app_pasajero_ns/themes/fresh_map_theme.dart';
import 'package:app_pasajero_ns/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as lct;

class TaxiPickPositionArguments {
  final BusquedaView type;
  TaxiPickPositionArguments({required this.type});
}

class TaxiPickPositionReturn {
  final String addressName;
  final LatLng coords;
  TaxiPickPositionReturn({required this.addressName, required this.coords});
}

class TaxiPickPositionController extends GetxController
    with WidgetsBindingObserver {
  // Instances
  final lct.Location location = lct.Location.instance;
  final _geocoding = GeocodingService();

  BusquedaView busquedaView = BusquedaView.destino;

  // Mapa
  bool existsPosition = false;
  bool _mapaListo = false;
  final isLocalizando = true.obs;
  CameraPosition? initialPosition;
  final defaultZoom = 17.0;
  final _mapController = Completer<GoogleMapController>();
  EdgeInsets mapInsetPadding = EdgeInsets.all(0);
  Map<MarkerId, Marker> markers = Map<MarkerId, Marker>();

  // Mi ubicación
  late Position _myPosition;
  StreamSubscription<Position>? _myPositionStream;

  // Position Manual
  LatLng? _lastPositionOnMoving;
  StreamSubscription<String>? _addressnameFutureSub;
  final streetName = 'Buscando...'.obs;

  // Acomodar
  final manualLoading = false.obs;
  final moviendoMapa = false.obs;

  bool firstTime = true;

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
    _addressnameFutureSub?.cancel();
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
    // if (!(Get.arguments is TaxiPickPositionArguments)) {
    //   Helpers.showError('No se han recibido los argumentos');
    //   return;
    // }
    // final arguments = Get.arguments as TaxiPickPositionArguments;
    // _busquedaView = arguments.type; 

    await Helpers.sleep(300);

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
      await initialConfigMap();

      await _myPositionStream?.cancel();
      _myPositionStream = Geolocator.getPositionStream(
              desiredAccuracy: LocationAccuracy.high, distanceFilter: 10)
          .listen((Position position) {
        _myPosition = position;
      });
      streetName.value = 'Mueve el mapa';
      await Helpers.sleep(1000);

      centrarMapaOrigen(animate: true);
    } catch (e) {
      print(e.toString());
      Helpers.logger.e('Error en: _configPosition');
    }
  }

  // Mapa: Functions
  Future<void> initialConfigMap() async {
    if (!existsPosition && isLocalizando.value) {
      existsPosition = true;
      initialPosition = CameraPosition(
        target: LatLng(_myPosition.latitude, _myPosition.longitude),
        zoom: defaultZoom,
      );
      mapInsetPadding = EdgeInsets.only(
          top: akContentPadding,
          bottom: akContentPadding + 170.0,
          left: akContentPadding,
          right: akContentPadding);
      update(['gbMapPicker']);
      await Future.delayed(Duration(milliseconds: 2500));

      update(['gbMapPicker']);
      isLocalizando.value = false;
    }
  }

  void onMapCreated(GoogleMapController controller) {
    controller.setMapStyle(jsonEncode(freshMapTheme));
    if (!_mapController.isCompleted) {
      _mapController.complete(controller);
    }
  }

  void centrarMapaOrigen({bool animate = true}) async {
    if (firstTime) {
      firstTime = false;
    } else {
      manualLoading.value = true;
    }

    LatLng myPositionLatLng =
        LatLng(_myPosition.latitude, _myPosition.longitude);
    moverCamara(myPositionLatLng, zoom: defaultZoom, animate: animate);
  }

  void moverCamara(LatLng position, {double? zoom, bool animate = true}) async {
    CameraPosition? cameraPosition;
    if (!_mapaListo) return;

    if (zoom != null) {
      cameraPosition = CameraPosition(target: position, zoom: zoom);
    } else {
      cameraPosition = CameraPosition(target: position);
    }

    final cameraUpdate = CameraUpdate.newCameraPosition(cameraPosition);

    final controller = await _mapController.future;
    if (animate) {
      controller.animateCamera(cameraUpdate);
    } else {
      controller.moveCamera(cameraUpdate);
    }
  }

  void onMapMoving(CameraPosition cameraPosition) {
    moviendoMapa.value = true;
    _lastPositionOnMoving = cameraPosition.target;
  }

  void onMapStopCamera() async {
    this.moviendoMapa.value = false;

    if (this._lastPositionOnMoving != null) {
      _addressnameFutureSub?.cancel();
      manualLoading.value = true;
      streetName.value = 'Buscando...';
      _addressnameFutureSub = _geocoding
          .getAddressName(this._lastPositionOnMoving!)
          .asStream()
          .listen((String streetname) {
        streetName.value = streetname;
        manualLoading.value = false;
      });
    }
  }

  void confirmarPuntoMarcador() async {
    if (_lastPositionOnMoving != null) {
      Get.back(
          result: TaxiPickPositionReturn(
              addressName: streetName.value, coords: _lastPositionOnMoving!));
    }
  }

  void onBackTap() {
    final _taxiX = Get.find<TaxiSearchController>();
    _taxiX.showPickLayer.value = false;
  }
}
*/