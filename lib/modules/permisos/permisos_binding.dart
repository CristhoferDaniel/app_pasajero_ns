import 'package:app_pasajero_ns/modules/permisos/permisos_controller.dart';
import 'package:get/get.dart';

class PermisosBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(PermisosController());
  }
}
