import 'package:google_maps_flutter/google_maps_flutter.dart';

class RutaViaje {
  RutaViaje({
    required this.coordsOrigen,
    required this.nombreOrigen,
    required this.coordsDestino,
    required this.nombreDestino,
  });

  LatLng coordsOrigen;
  String nombreOrigen;
  LatLng coordsDestino;
  String nombreDestino;
}
