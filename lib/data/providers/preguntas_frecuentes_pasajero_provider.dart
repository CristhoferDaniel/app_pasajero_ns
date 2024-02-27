import 'package:app_pasajero_ns/data/models/preguntas_frecuentes_pasajero.dart';
import 'package:app_pasajero_ns/utils/utils.dart';
import 'package:get/instance_manager.dart';

class PreguntasFrecuentesPasajeroProvider {
  final DioClient _dioClient = Get.find<DioClient>();

  final String _endpoint = '/preguntasfrecuentepasajero';

  Future<List<PreguntasFrecuentesPasajero>> getAll() async {
    final resp = await _dioClient.get('$_endpoint');
    return List<PreguntasFrecuentesPasajero>.from(
        resp.map((x) => PreguntasFrecuentesPasajero.fromJson(x)));
  }
}
