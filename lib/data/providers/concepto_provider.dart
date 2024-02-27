import 'package:app_pasajero_ns/data/models/concepto.dart';
import 'package:app_pasajero_ns/utils/utils.dart';
import 'package:get/instance_manager.dart';

class ConceptoProvider {
  final DioClient _dioClient = Get.find<DioClient>();

  final String _endpoint = '/concepto';

  Future<ConceptoSimulacionResponse> simulacionTaxi(
      {required int metros, required segundos, required idTipoVehiculo}) async {
    final resp = await _dioClient.post('$_endpoint/simulacion', data: {
      'idServicio': 0,
      'idTipoServicio': 8,
      'distance': metros,
      'duration': segundos,
      'idTipoVehiculo': idTipoVehiculo // TODO: Harcodeo
    });
    return ConceptoSimulacionResponse.fromJson(resp);
  }

  Future<ConceptoSimulacionCliente> simulacionCliente(
      {required int metros, required segundos}) async {
    final resp = await _dioClient.post('$_endpoint/simulacionCliente', data: {
      'idServicio': 0,
      'idTipoServicio': 8,
      'distance': metros,
      'duration': segundos,
      'idTipoVehiculo': 0
    });
    return ConceptoSimulacionCliente.fromJson(resp);
  }
}
