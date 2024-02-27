import 'package:app_pasajero_ns/data/models/login.dart';
import 'package:app_pasajero_ns/utils/utils.dart';
import 'package:get/instance_manager.dart';

class LoginProvider {
  final DioClient _dioClient = Get.find<DioClient>();

  final String _endpoint = '/auth/login';
  Future<LoginResponse> getToken(String idToken, String typeOperator) async {
    final params = LoginParams(idToken: idToken, typeOperator: typeOperator);

    final resp = await _dioClient.post('$_endpoint', data: params.toJson());
    return LoginResponse.fromJson(resp);
  }
}
