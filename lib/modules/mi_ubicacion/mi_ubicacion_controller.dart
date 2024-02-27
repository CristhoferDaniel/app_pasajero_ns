import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MiUbicacionController extends GetxController {
  bool _siguiendo = false;
  bool get siguiendo => _siguiendo;

  // bool _existeUbicacion = false;
  // bool get existeUbicacion => _existeUbicacion;

  RxBool existeMiUbicacion = RxBool(false);

  /* LatLng _miUbicacion;
  LatLng get miUbicacion => _miUbicacion; */
  Rxn<LatLng> miUbicacion = Rxn<LatLng>();

  StreamSubscription<Position>? _positionSubscription;

  @override
  void onInit() async {
    await Future.delayed(Duration(seconds: 3));
    iniciarSeguimiento();
    super.onInit();
  }

  void iniciarSeguimiento() {
    final stream = Geolocator.getPositionStream();

    stream.listen((position) {
      final nuevaUbicacion = LatLng(position.latitude, position.longitude);
      print('Nueva posición: ${nuevaUbicacion.toJson()}');

      miUbicacion.value = nuevaUbicacion;
      if (existeMiUbicacion.value == false) {
        existeMiUbicacion.value = true;
      }
    });

    _positionSubscription =
        stream.asBroadcastStream() as StreamSubscription<Position>?;
  }

  void cancelarSeguimiento() {
    _positionSubscription?.cancel();
  }

  @override
  void onClose() {
    cancelarSeguimiento();
    super.onClose();
  }
}
