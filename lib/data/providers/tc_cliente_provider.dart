import 'package:app_pasajero_ns/data/models/termino_condicion.dart';
import 'package:app_pasajero_ns/utils/utils.dart';
import 'package:get/instance_manager.dart';

class TCClienteProvider {
  final DioClient _dioClient = Get.find<DioClient>();

  final String _endpoint = '/terminoscondicionespasajero';

  Future<TerminoCondicion> getHtmlText() async {
    final resp = await _dioClient.get('$_endpoint');
    final items = List<TerminoCondicion>.from(
        resp.map((x) => TerminoCondicion.fromJson(x)));

    if (items.isEmpty) {
      throw Exception('La lista de condiciones está vacía');
    }

    return items.first;
  }
}
