import 'package:app_pasajero_ns/data/models/preguntas_frecuentes_pasajero.dart';
import 'package:app_pasajero_ns/data/providers/preguntas_frecuentes_pasajero_provider.dart';
import 'package:get/get.dart';

class FaqController extends GetxController {
  PreguntasFrecuentesPasajeroProvider _pfpProvider =
      PreguntasFrecuentesPasajeroProvider();

  List<PreguntasFrecuentesPasajero> _lista = [];

  @override
  void onInit() {
    super.onInit();
  }

  Future<List<PreguntasFrecuentesPasajero>> listaPreguntas() async {
    // await Future.delayed(Duration(seconds: 1));
    final items = await _pfpProvider.getAll();
    items.forEach((e) {
      if (e.enable == 1) {
        _lista.add(e);
      }
    });
    return [...items];
  }

  void refreshList() {
    update(['lista']);
  }
}
