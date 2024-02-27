import 'package:app_pasajero_ns/modules/taxi/taxi_mapa/taxi_mapa_controller.dart';
import 'package:get/get.dart';

class LayerProgramadoCtlr extends GetxController {
  final taxiMapaX = Get.find<TaxiMapaController>();

  void onOkButtonTap() {
    Get.back();
  }
}
