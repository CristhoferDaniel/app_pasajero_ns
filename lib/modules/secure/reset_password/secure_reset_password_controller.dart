import 'package:app_pasajero_ns/modules/auth/auth_controller.dart';
import 'package:app_pasajero_ns/modules/misc/error/misc_error_controller.dart';
import 'package:app_pasajero_ns/routes/app_pages.dart';
import 'package:app_pasajero_ns/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SecureResetPasswordController extends GetxController {
  SecureResetPasswordController({required this.email});

  late ScrollController scrollController;
  final gbAppbar = 'gbAppbar';

  final String email;

  late SecureResetPasswordController _self;

  final _authX = Get.find<AuthController>();

  final loading = false.obs;

  @override
  void onInit() {
    super.onInit();
    this._self = this;

    scrollController = ScrollController()
      ..addListener(() {
        update([gbAppbar]);
      });

    _init();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  Future<void> _init() async {
    sendResetPasswordEmail();
  }

  Future<void> sendResetPasswordEmail() async {
    String? errorMsg;
    try {
      loading.value = true;
      await Future.delayed(Duration(milliseconds: 1500));
      await _authX.auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      errorMsg = AppIntl.getFirebaseErrorMessage(e.code);
      Helpers.logger.e(e.message);
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
        sendResetPasswordEmail();
      } else {
        // Por UX, no cambio el estado de loading
        backAction();
      }
    } else {
      loading.value = false;
    }
  }

  void backAction() async {
    loading.value = false;
    Get.back();
  }

  Future<bool> handleBack() async {
    if (loading.value) return false;
    Get.focusScope?.unfocus();
    return true;
  }
}
