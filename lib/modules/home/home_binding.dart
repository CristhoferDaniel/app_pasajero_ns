import 'package:app_pasajero_ns/modules/home/home_controller.dart';
import 'package:get/get.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    // Get.put(MiUbicacionController());
    Get.put(HomeController());
  }
}
