import 'package:app_pasajero_ns/data/models/tipo_doc.dart';
import 'package:app_pasajero_ns/utils/utils.dart';
import 'package:get/instance_manager.dart';

class TipoDocProvider {
  final DioClient _dioClient = Get.find<DioClient>();

  final String _endpoint = '/tipodocumento';

  Future<ListTipoDocResponse> getAll(
      {required int page, required int limit}) async {
    final response = await _dioClient
        .get('$_endpoint', queryParameters: {'page': page, 'limit': limit});
    return ListTipoDocResponse.fromJson(response);
  }
}
