import 'package:app_pasajero_ns/modules/auth/auth_controller.dart';
import 'package:app_pasajero_ns/modules/misc/error/misc_error_controller.dart';
import 'package:app_pasajero_ns/modules/secure/email/secure_email_controller.dart';
import 'package:app_pasajero_ns/modules/secure/email/secure_email_page.dart';
import 'package:app_pasajero_ns/routes/app_pages.dart';
import 'package:app_pasajero_ns/utils/utils.dart';
import 'package:app_pasajero_ns/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PerfilEmailDetailsController extends GetxController
    with WidgetsBindingObserver {
  late PerfilEmailDetailsController _self;
  late ScrollController scrollController;

  final authX = Get.find<AuthController>();

  final gbAppbar = 'gbAppbar';
  final gbVerificationSection = 'gbVerificationSection';
  final loading = false.obs;

  bool verificationMailSent = false;

  @override
  void onInit() {
    super.onInit();
    this._self = this;

    WidgetsBinding.instance?.addObserver(this);

    scrollController = ScrollController()
      ..addListener(() {
        update([gbAppbar]);
      });
  }

  @override
  void onClose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      if (verificationMailSent) _reloadUser();
    }
  }

  Future<void> onButtonChangeTap() async {
    await Get.delete<SecureEmailController>();
    final _emailX = Get.put(SecureEmailController(
      onEmailNextTap: (fbAuthType, email) {
        print('onEmailNextTap');
      },
      parentLoading: loading,
      onBackCall: () {
        Get.back();
      },
      onCancelRetry: () {
        print('onCancelRetry');
      },
      isEditMode: true,
    ));
    await Get.to(
      () => SecureEmailPage(_emailX),
      transition: Transition.cupertino,
    );
    await Get.delete<SecureEmailController>();
  }

  Future<void> onResendEmailVerificationTap() async {
    String? errorMsg;
    try {
      loading.value = true;
      await Helpers.sleep(1000);
      await authX.getUser!.sendEmailVerification();
    } on FirebaseException catch (e) {
      errorMsg = AppIntl.getFirebaseErrorMessage(e.code);
      Helpers.logger.e(e.code);
    } catch (e) {
      errorMsg = 'Ocurrió un error inesperado.';
      Helpers.logger.e(e.toString());
    }

    if (_self.isClosed) return;
    if (errorMsg != null) {
      final ers = await Get.toNamed(AppRoutes.MISC_ERROR,
          arguments: MiscErrorArguments(content: errorMsg));
      if (ers == MiscErrorResult.retry) {
        await Helpers.sleep(1500);
        onResendEmailVerificationTap();
      } else {
        loading.value = false;
      }
    } else {
      loading.value = false;

      verificationMailSent = true;
      update([gbVerificationSection]);
      AppSnackbar()
          .success(message: 'Enlace enviado! Revisa tu bandeja de correo');
    }
  }

  Future<void> _reloadUser() async {
    // Aquí solo hacemos un reload por background
    try {
      await authX.getUser!.reload();
      update([gbVerificationSection]);
    } catch (e) {
      Helpers.logger.e(e.toString());
    }
  }

  Future<bool> handleBack() async {
    if (loading.value) return false;
    Get.focusScope?.unfocus();
    return true;
  }
}
