import 'package:app_pasajero_ns/data/models/ruta.dart';
import 'package:app_pasajero_ns/utils/utils.dart';
import 'package:get/instance_manager.dart';

class RutaProvider {
  final DioClient _dioClient = Get.find<DioClient>();

  final String _endpoint = '/ruta';

  Future<RutaResponse> getById(int id) async {
    final resp = await _dioClient.get('$_endpoint/$id');
    return RutaResponse.fromJson(resp);
  }
}
