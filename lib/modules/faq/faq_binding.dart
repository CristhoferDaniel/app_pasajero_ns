import 'package:app_pasajero_ns/modules/faq/faq_controller.dart';
import 'package:get/get.dart';

class FaqBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(FaqController());
  }
}
