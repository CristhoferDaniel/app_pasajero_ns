import 'dart:async';
import 'dart:convert';

import 'package:app_pasajero_ns/themes/fresh_map_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TourMapaController extends GetxController with WidgetsBindingObserver {
  final _mapController = Completer<GoogleMapController>();

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance?.addObserver(this);
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

  void onMapCreated(GoogleMapController controller) {
    controller.setMapStyle(jsonEncode(freshMapTheme));
    if (!_mapController.isCompleted) {
      _mapController.complete(controller);
    }
  }
}
