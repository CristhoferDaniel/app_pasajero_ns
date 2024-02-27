import 'package:app_pasajero_ns/modules/contacto/contacto_controller.dart';
import 'package:get/get.dart';

class ContactoBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(ContactoController());
  }
}
