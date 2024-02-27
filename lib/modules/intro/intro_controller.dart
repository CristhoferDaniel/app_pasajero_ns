import 'package:app_pasajero_ns/modules/secure/login_flow/login_flow_controller.dart';
import 'package:get/get.dart';

class IntroController extends GetxController {
  final counter = 0.obs;

  final loading = false.obs;

  void incrementar() {
    counter.value++;
  }

  Future<void> goToLoginPhonePage() async {
    if (loading.value) return;

    loading.value = true;
    // El login flow se crea en esta función, para evitar
    // el problema de isClosed en los Controladores eliminados
    await Get.delete<LoginFlowController>();
    final loginFlow = Get.put(LoginFlowController());
    loginFlow.startFlow();
    loading.value = false;
  }
}
