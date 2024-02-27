import 'package:app_pasajero_ns/modules/secure/reset_password/secure_reset_password_controller.dart';
import 'package:app_pasajero_ns/modules/secure/reset_password/secure_reset_password_page.dart';
import 'package:app_pasajero_ns/modules/secure/widgets/modal_reset_flow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

enum FirebaseAuthType { login, create }

class SecurePasswordController extends GetxController {
  SecurePasswordController({
    required this.firebaseAuthType,
    required this.email,
    required this.parentLoading,
    required this.onLoginOrCreateTap,
    required this.onBackCall,
    this.isEditMode = false,
  });

  late ScrollController scrollController;
  final gbAppbar = 'gbAppbar';

  final RxBool parentLoading;
  final void Function(FirebaseAuthType accessType, String email,
      String password, String currentPassword) onLoginOrCreateTap;
  final void Function() onBackCall;
  final bool isEditMode;

  final loading = false.obs;
  final formKey = GlobalKey<FormState>();

  final FirebaseAuthType firebaseAuthType;

  final String email;

  String currentPassword = '';

  String password = '';
  String confirmPassword = '';

  final currentPasswordFocusNode = FocusNode();

  final passwordFocusNode = FocusNode();
  final confirmPasswordFocusNode = FocusNode();

  final passwordCtlr = TextEditingController();

  final hideCurrentPassword = true.obs;

  final hidePassword = true.obs;
  final hideConfirmPassword = true.obs;

  final disabledNextButton = true.obs;

  String? passwordError;

  @override
  void onInit() {
    super.onInit();

    scrollController = ScrollController()
      ..addListener(() {
        update([gbAppbar]);
      });

    ever<bool>(parentLoading, (val) {
      this.loading.value = val;
    });
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void handleStatusNextButton(String text) {
    final hasError = validatePassword(text);
    disabledNextButton.value = (hasError != null);
  }

  void toggleCurrentPasswordVisibility() {
    hideCurrentPassword.value = !hideCurrentPassword.value;
  }

  void togglePasswordVisibility() {
    hidePassword.value = !hidePassword.value;
  }

  void toggleConfirmPasswordVisibility() {
    hideConfirmPassword.value = !hideConfirmPassword.value;
  }

  void onNextPressed() {
    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState?.save();
      Get.focusScope?.unfocus();

      this
          .onLoginOrCreateTap
          .call(firebaseAuthType, email, password, currentPassword);
    }
  }

  Future<void> goToResetPasswordPage() async {
    Get.focusScope?.unfocus();
    passwordCtlr.text = '';
    handleStatusNextButton('');

    await Get.delete<SecureResetPasswordController>();
    final _resetX = Get.put(SecureResetPasswordController(email: email));
    await Get.to(
      () => SecureResetPasswordPage(_resetX),
      transition: Transition.cupertino,
    );
    await Get.delete<SecureResetPasswordController>();

    passwordFocusNode.requestFocus();
  }

  Future<bool> handleBack() async {
    if (loading.value) return false;
    Get.focusScope?.unfocus();

    if (firebaseAuthType == FirebaseAuthType.login) {
      final confirmResetFlow = await _showConfirmResetFlow();
      if (confirmResetFlow) {
        onBackCall.call();
      }
      return false;
    }

    return true;
  }

  Future<bool> _showConfirmResetFlow() async {
    if (Get.overlayContext == null) return false;

    final resp = await showMaterialModalBottomSheet<bool?>(
      context: Get.overlayContext!,
      backgroundColor: Colors.transparent,
      builder: (context) => ModalResetFlow(
        onYesTap: () => Get.back(result: true),
        onNoTap: () => Get.back(result: false),
      ),
    );
    return resp ?? false;
  }

  // Validators
  String? validatePassword(String? text) {
    if (passwordError != null) return passwordError;

    if (text != null) {
      password = text.toString();
    }
    if (text != null && text.trim().length >= 6) {
      return null;
    }

    return 'Campo requerido';
  }

  // Validators
  String? validateConfirmPassword(String? text) {
    if (text != null && text.trim() == password) {
      return null;
    }
    return 'Las contraseñas no coinciden';
  }
}
