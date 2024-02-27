import 'package:app_pasajero_ns/data/models/servicio.dart';
import 'package:app_pasajero_ns/modules/auth/auth_controller.dart';
import 'package:app_pasajero_ns/utils/utils.dart';
import 'package:get/instance_manager.dart';

class ServicioProvider {
  final DioClient _dioClient = Get.find<DioClient>();
  final _authX = Get.find<AuthController>();

  final String _endpoint = '/servicio';

  Future<ServicioResponse> getById(int id) async {
    final resp = await _dioClient.get('$_endpoint/id?id=$id');
    return ServicioResponse.fromJson(resp);
  }

  Future<ServicioResponse> update(ServicioDto data) async {
    final resp = await _dioClient.put(
      '$_endpoint?id=${data.idServicio}',
      data: data.toJson(),
    );
    return ServicioResponse.fromJson(resp);
  }

  Future<ServicioList2Response> getByClient() async {
    // DateTime fiveDaysAgo = new DateTime.now();

    int idCliente = _authX.backendUser!.idCliente;


    Helpers.logger.wtf(idCliente);

    final resp = await _dioClient.get('$_endpoint/cliente', queryParameters: {
      'idCliente': idCliente,
      'page': '1',
      'limit': '1000',
    });
    return ServicioList2Response.fromJson(resp);
  }
}
