import 'package:app_pasajero_ns/data/models/sosservicio.dart';
import 'package:app_pasajero_ns/utils/utils.dart';
import 'package:get/instance_manager.dart';

class SosservicioProvider {
  final DioClient _dioClient = Get.find<DioClient>();

  final String _endpoint = '/sosservicio';

  Future<SosservicioCreateResponse> create(SosservicioDto dto) async {
    final params = SosservicioCreateUpdateParams(
        idSosServicio: dto.idSosServicio,
        fechaHora: dto.fechaHora,
        motivo: dto.motivo,
        enable: dto.enable,
        idServicio: dto.idServicio,
        tipoPersona: dto.tipoPersona,
        estado: dto.estado,
        cordLat: dto.cordLat,
        cordLon: dto.cordLon);

    final resp = await _dioClient.post('$_endpoint', data: params.toJson());
    return SosservicioCreateResponse.fromJson(resp);
  }
}
