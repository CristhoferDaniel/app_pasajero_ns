import 'package:app_pasajero_ns/modules/tour/mapa/tour_mapa_controller.dart';
import 'package:app_pasajero_ns/themes/ak_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TourMapaHomePage extends StatelessWidget {
  final _conX = Get.put(TourMapaController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa'),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            size: akDefaultGutterSize + 10.0,
          ),
        ),
      ),
      body: _buildMapa(),
    );
  }

  Widget _buildMapa() {
    final cameraPosition =
        new CameraPosition(target: LatLng(-11.9598, -76.9875), zoom: 18);

    // return Text('mapap');

    return GoogleMap(
      initialCameraPosition: cameraPosition,
      mapType: MapType.normal,
      myLocationEnabled: false,
      myLocationButtonEnabled: false,
      compassEnabled: false,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      tiltGesturesEnabled: false,
      onMapCreated: _conX.onMapCreated,
    );
  }
}
