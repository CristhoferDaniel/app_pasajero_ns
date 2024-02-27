import 'package:app_pasajero_ns/config/config.dart';
import 'package:app_pasajero_ns/data/models/google_suggestion_response.dart';
import 'package:app_pasajero_ns/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// For storing our result
class Suggestion {
  final String placeId;
  final String description;

  Suggestion(this.placeId, this.description);

  @override
  String toString() {
    return 'Suggestion(description: $description, placeId: $placeId)';
  }
}

class AutocompletePlaceService {
  AutocompletePlaceService(this.sessionToken);

  final sessionToken;

  // Future<List<Suggestion>> fetchSuggestions(String input, String lang) async {

  Future<GoogleSuggestionResponse> fetchSugerencias(
      String input, CancelToken cancelToken,
      {required LatLng location}) async {
    final _dio = Dio();
    final DioClient _dioClient =
        DioClient('https://maps.googleapis.com/maps/api', _dio);

    final request =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';

    Map<String, dynamic> qParams = {
      'input': '$input',
      'language': 'es',
      'components': 'country:pe',
      'key': Config.API_GOOGLE_KEY,
      'sessiontoken': this.sessionToken
    };

    if (location is LatLng) {
      qParams['location'] = '${location.latitude},${location.longitude}';
      // Parece que el campo location solo funciona con radius,
      // Pero usar radius podría reducir el rendimiento y aumentar el costo
      // Buscar más información.
      // qParams['radius'] = 500;
    }

    final response = await _dioClient.get(request,
        queryParameters: qParams, cancelToken: cancelToken);

    return GoogleSuggestionResponse.fromJson(response);
  }

  /*  Future<GooglePlaceResponse> getPlaceDetails(
      String placeId, CancelToken cancelToken) async {
    final _dio = Dio();
    final DioClient _dioClient =
        DioClient('https://maps.googleapis.com/maps/api', _dio);

    final request = 'https://maps.googleapis.com/maps/api/place/details/json';
    final response = await _dioClient.get(request,
        queryParameters: {
          'place_id': '$placeId',
          'language': 'es',
          'fields': 'geometry,name',
          'key': Config.API_GOOGLE_KEY,
          'sessiontoken': this.sessionToken,
        },
        cancelToken: cancelToken);

    return GooglePlaceResponse.fromJson(response);
  } */
}
