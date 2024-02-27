import 'package:app_pasajero_ns/config/config.dart';
import 'package:app_pasajero_ns/data/models/driving_request_param.dart';
import 'package:app_pasajero_ns/data/models/google_driving_response.dart';
import 'package:app_pasajero_ns/utils/utils.dart';
import 'package:dio/dio.dart';

class RoutingService {
  RoutingService._internal();
  static RoutingService get _instance => RoutingService._internal();

  factory RoutingService() {
    return _instance;
  }

  // Asignar el tipo de retorno
  Future<GoogleDrivingResponse> calculateRoute(
      DrivingRequestParams origin, DrivingRequestParams destination) async {
    final _dio = Dio();
    final DioClient _dioClient =
        DioClient('https://maps.googleapis.com/maps/api', _dio);

    var response = await _dioClient.get('/directions/json', queryParameters: {
      'region': 'pe',
      'origin': '${origin.getParamToRequest()}',
      'destination': '${destination.getParamToRequest()}',
      'key': '${Config.API_GOOGLE_KEY}',
      'mode': 'driving',
      'language': 'es'
    });

    if (response['status'] != 'OK') {
      response['geocoded_waypoints'] = [];
      response['routes'] = [];
    }

    return GoogleDrivingResponse.fromJson(response);
  }

  // Asignar el tipo de retorno
  Future<GoogleDrivingResponse> calculateRoute2(
      DrivingRequestParam origin, DrivingRequestParam destination) async {
    final _dio = Dio();
    final DioClient _dioClient =
        DioClient('https://maps.googleapis.com/maps/api', _dio);

    final response = await _dioClient.get('/directions/json', queryParameters: {
      'region': 'pe',
      'origin': '${origin.getParamToString()}',
      'destination': '${destination.getParamToString()}',
      'key': '${Config.API_GOOGLE_KEY}',
      'mode': 'driving',
      'language': 'es'
    });

    return GoogleDrivingResponse.fromJson(response);
  }
}
