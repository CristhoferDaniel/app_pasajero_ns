import 'package:app_pasajero_ns/data/models/solicitud_pasajero.dart';
import 'package:app_pasajero_ns/utils/utils.dart';
import 'package:get/instance_manager.dart';

class SolicitudProvider {
  final DioClient _dioClient = Get.find<DioClient>();

  Future<SolicitudPasajeroResponse> createregular(
      SolicitudPasajeroCreate data) async {
    final resp = await _dioClient.post('/solicitudpasajerotaxi/solicita',
        data: data.toJson());
    return SolicitudPasajeroResponse.fromJson(resp);
  }

  Future<SolicitudPasajeroResponse> createreserva(
      SolicitudPasajeroCreate data) async {
    final resp = await _dioClient
        .post('/solicitudpasajeroturismo/solicitaTurismo', data: data.toJson());
    return SolicitudPasajeroResponse.fromJson(resp);
  }
}
