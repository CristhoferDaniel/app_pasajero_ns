import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:app_pasajero_ns/data/models/servicio.dart';
import 'package:app_pasajero_ns/themes/ak_ui.dart';
import 'package:app_pasajero_ns/themes/fresh_map_theme.dart';
import 'package:app_pasajero_ns/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MisViajesDetalleController extends GetxController
    with WidgetsBindingObserver {
  // Instances
  late MisViajesDetalleController _self;
  final _polylinePointsLib = PolylinePoints();

  // Data
  ServicioModelItem? data;

  // Mapa
  bool existsPosition = true;
  CameraPosition initialPosition = CameraPosition(
    target: LatLng(-12.0640607, -77.0521935),
    zoom: 11.75,
  );
  final _mapController = Completer<GoogleMapController>();
  EdgeInsets mapInsetPadding = EdgeInsets.all(0.0);
  final Set<Marker> markers = HashSet<Marker>();
  final Set<Polyline> polylines = HashSet<Polyline>();

  final loadingData = true.obs;
  final delayingMap = true.obs;
  final showOverlayLoadingMap = true.obs;

  // Markers
  static const MARKER_ORIGEN = 'origen';
  static const MARKER_DESTINO = 'destino';
  final markerOrigenKey = GlobalKey();
  final markerDestinoKey = GlobalKey();
  // Default StylePolyline
  static const POLYLINE_RUTA_ID = 'mi_ruta';
  Polyline _miRutaDestino = new Polyline(
      polylineId: PolylineId(POLYLINE_RUTA_ID),
      width: 3,
      color: akPrimaryColor);

  // GetBuilder ID's
  final gbOnlyMap = 'gbOnlyMap';
  final gbMarkers = 'gbMarkers';

  @override
  void onInit() {
    super.onInit();
    _self = this;
    WidgetsBinding.instance?.addObserver(this);

    _init();
  }

  @override
  void onClose() {
    WidgetsBinding.instance?.removeObserver(this);
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
    if (!(Get.arguments is MisViajesDetalleArguments)) {
      Helpers.showError('Error recibiendo los argumentos');
      return;
    }

    final arguments = Get.arguments as MisViajesDetalleArguments;
    data = arguments.servicio;

    LatLng? coordsOrigen;
    LatLng? coordsDestino;
    String? polylineData;
    if (data != null && data!.ruta != null) {
      final arrayOrigen = data!.ruta!.coordenadaOrigen.split(',');
      final arrayDestino = data!.ruta!.coordenadaDestino.split(',');
      coordsOrigen =
          LatLng(double.parse(arrayOrigen[0]), double.parse(arrayOrigen[1]));
      coordsDestino =
          LatLng(double.parse(arrayDestino[0]), double.parse(arrayDestino[1]));
      polylineData = data!.ruta!.polyline;

      initialPosition = CameraPosition(
        target: coordsOrigen,
        zoom: 17.0,
      );
    }

    await Helpers.sleep(600);
    if (_self.isClosed) return;
    delayingMap.value = false;

    // await Helpers.sleep(300);
    if (coordsOrigen != null && coordsDestino != null && polylineData != null) {
      markers.add(Marker(
        zIndex: 1,
        anchor: Offset(0.50, 0.70),
        markerId: MarkerId(MARKER_ORIGEN),
        position: coordsOrigen,
        icon: await Helpers.getCustomIcon(markerOrigenKey) ??
            BitmapDescriptor.defaultMarker,
      ));

      markers.add(Marker(
        zIndex: 1,
        anchor: Offset(0.50, 0.70),
        markerId: MarkerId(MARKER_DESTINO),
        position: coordsDestino,
        icon: await Helpers.getCustomIcon(markerDestinoKey) ??
            BitmapDescriptor.defaultMarker,
      ));

      final points = _polylinePointsLib.decodePolyline(polylineData);
      final routeCoords = points
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();
      _miRutaDestino = _miRutaDestino.copyWith(pointsParam: routeCoords);
      polylines.add(_miRutaDestino);

      _updatePaddingMap(top: 0.0, bottom: 40.0);

      final bounds = simulateBoundsFromCoords(coordsOrigen, coordsDestino);
      _adjustMapToBounds(bounds, boundsPadding: 60.0);
    }
  }

  void onMapCreated(GoogleMapController controller) {
    controller.setMapStyle(jsonEncode(freshMapTheme));
    if (!_mapController.isCompleted) {
      _mapController.complete(controller);
    }

    _hideOverlayLoadingMap();
  }

  Future<void> _hideOverlayLoadingMap() async {
    await Helpers.sleep(600);
    if (_self.isClosed) return;
    showOverlayLoadingMap.value = false;
  }

  void _adjustMapToBounds(LatLngBounds? bounds,
      {double boundsPadding = 40.0}) async {
    if (bounds == null) return;
    final controller = await _mapController.future;
    await controller.getVisibleRegion();
    var cameraUpdate = CameraUpdate.newLatLngBounds(bounds, boundsPadding);
    controller.animateCamera(cameraUpdate);
  }

  void _updatePaddingMap({double top = 65.0, double bottom = 0.0}) {
    mapInsetPadding = EdgeInsets.only(
        top: top,
        bottom: bottom,
        left: akContentPadding,
        right: akContentPadding);
    update([gbOnlyMap]);
  }
}

class MisViajesDetalleArguments {
  final ServicioModelItem servicio;

  MisViajesDetalleArguments({required this.servicio});
}
