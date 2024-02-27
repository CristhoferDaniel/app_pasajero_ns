import 'package:app_pasajero_ns/utils/utils.dart';
import 'package:app_pasajero_ns/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class LoginResetPasswordController extends GetxController {
  // AuthProvider _authProvider = AuthProvider();

  RxBool loading = RxBool(false);
  RxBool hasError = RxBool(false);

  String email = '';

  @override
  void onInit() {
    super.onInit();

    _init();
  }

  void _init() async {
    if (!(Get.arguments is LoginResetPasswordArguments)) {
      Helpers.showError('Hubo un error en los parámetros');
      return;
    }

    final arguments = Get.arguments as LoginResetPasswordArguments;
    email = arguments.email;
    if (!(email.isEmail)) {
      Helpers.showError('No es un email válido');
      return;
    }

    sendResetPasswordEmail();
  }

  void sendResetPasswordEmail() async {
    hasError.value = false;
    loading.value = true;

    try {
      await Future.delayed(Duration(milliseconds: 500));
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      hasError.value = true;
      String errormsg = AppIntl.getFirebaseErrorMessage(e.code);
      AppSnackbar().error(message: errormsg);
    } catch (e) {
      hasError.value = true;
      AppSnackbar().error(message: '¡Opps! Parece que hubo un problema');
    } finally {
      loading.value = false;
    }
  }
}

class LoginResetPasswordArguments {
  final String email;

  LoginResetPasswordArguments({required this.email});
}
