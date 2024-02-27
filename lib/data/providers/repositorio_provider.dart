import 'package:app_pasajero_ns/data/models/repositorio.dart';
import 'package:app_pasajero_ns/utils/utils.dart';
import 'package:get/instance_manager.dart';

class RepositorioProvider {
  final DioClient _dioClient = Get.find<DioClient>();

  final String _endpoint = '/repositorio';

  Future<RepositorioResponse> sendFileBase64(
      {required String fileName, required String base64}) async {
    final resp = await _dioClient
        .post('$_endpoint', data: {'fileName': fileName, 'base64': base64});
    return RepositorioResponse.fromJson(resp);
  }
}
