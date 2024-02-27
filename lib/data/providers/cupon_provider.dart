import 'package:app_pasajero_ns/data/models/cupon.dart';
import 'package:app_pasajero_ns/utils/utils.dart';
import 'package:get/instance_manager.dart';

class CuponProvider {
  final DioClient _dioClient = Get.find<DioClient>();

  final String _endpoint = '/cupon/code';

  Future<CuponResponse> validateCupon(String code) async {
    final resp = await _dioClient.get('$_endpoint',queryParameters: {
        'code': code,
        'page': 1,
        'limit': 100,
      },);
        return CuponResponse.fromJson(resp);

  }
}
