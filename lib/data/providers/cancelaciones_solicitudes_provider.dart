
import 'package:app_pasajero_ns/data/models/cancelaciones_solicitudes.dart';
import 'package:app_pasajero_ns/utils/utils.dart';
import 'package:get/instance_manager.dart';

class CancelacionesSolicitudesProvider {
  final DioClient _dioClient = Get.find<DioClient>();

  final String _endpoint = '/cancelacionessolicitudescli';

  Future<ResponseCancelacionesSolicitudes> create(
      ParamsCancelacionesSolicitudes dto) async {
    DateTime today = new DateTime.now();
    final params = ParamsCancelacionesSolicitudes(
        fecha: dto.fecha,
        idCancelacionesSolicitudesCli: dto.idCancelacionesSolicitudesCli,
        idCliente: dto.idCliente,
        idSolicitud: dto.idSolicitud);

    final resp = await _dioClient.post('$_endpoint', data: params.toJson());
    return ResponseCancelacionesSolicitudes.fromJson(resp);
  }
}
