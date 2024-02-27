import 'package:app_pasajero_ns/data/models/tipo_documento.dart';
import 'package:app_pasajero_ns/utils/utils.dart';
import 'package:get/instance_manager.dart';

class TipoDocumentoProvider {
  final DioClient _dioClient = Get.find<DioClient>();

  final String _endpoint = '/tipodocumento';

  Future<TipoDocumentoResponse> getAll() async {
    final resp = await _dioClient
        .get('$_endpoint', queryParameters: {'page': 1, 'limit': 100});
    return TipoDocumentoResponse.fromJson(resp);
  }
}
