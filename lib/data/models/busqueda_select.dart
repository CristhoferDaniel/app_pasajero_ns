import 'package:app_pasajero_ns/data/models/google_suggestion_response.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BusquedaSelect {
  BusquedaSelect({
    required this.provider,
    required this.resultType,
    required this.prediction,
    required this.placeLatLng,
  });

  final BusquedaSelectProvider provider;
  final BusquedaSelectType resultType;
  final Prediction? prediction;
  final LatLng? placeLatLng;
}

enum BusquedaSelectProvider { ORIGEN, DESTINO }
enum BusquedaSelectType { PLACE_SELECTED, MOVE_SELECTED }

// ===================>>>>><<<<<<======================
/*
enum TaxiSearchResponseType { PLACE_SELECTED, MOVE_SELECTED }

class TaxiSearchResponse {
  TaxiSearchResponse({
    required this.resultType,
    this.prediction,
    this.placeLatLng,
  });
  final TaxiSearchResponseType resultType;
  final Prediction? prediction;
  final LatLng? placeLatLng;
}
*/