import 'package:app_pasajero_ns/data/providers/auth_provider.dart';
import 'package:app_pasajero_ns/modules/login/enter_email/login_enter_email_page.dart';
import 'package:app_pasajero_ns/modules/login/enter_password/login_enter_password_controller.dart';
import 'package:app_pasajero_ns/modules/login/login_controller.dart';
import 'package:app_pasajero_ns/routes/app_pages.dart';
import 'package:app_pasajero_ns/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class LoginEnterEmailController extends GetxController {
  final _phoneX = Get.find<LoginController>();

  final _authProvider = AuthProvider();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController emailCtlr = TextEditingController();

  String email = '';

  FocusNode emailFocusNode = FocusNode();

  final loading = false.obs;

  final errorFirebase = false.obs;
  String errorFirebaseMsg = '';

  @override
  void onInit() {
    super.onInit();
    _init();
  }

  void _init() async {
    emailCtlr.addListener(_onEmailFocus);

    await Future.delayed(Duration(milliseconds: 300));
    // emailFocusNode.requestFocus();
  }

  @override
  void onClose() {
    super.onClose();
    emailCtlr.removeListener(_onEmailFocus);
  }

  void _onEmailFocus() {
    if (errorFirebase.value) {
      errorFirebase.value = false;
    }
  }

  void onNextClicked() async {
    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState?.save();
      Get.focusScope?.unfocus();
      await Future.delayed(Duration(milliseconds: 300));
      _searchInFirebaseByEmail(email);
    }
  }

  Future<void> _searchInFirebaseByEmail(String emailtosearch) async {
    try {
      loading.value = true;
      final fireUserInfo = await _authProvider.searchFirebaseUserByEmail(email);
      loading.value = false;

      if (fireUserInfo.emailVerified) {
        if (fireUserInfo.phoneNumber !=
            '${_phoneX.dialSelected}${_phoneX.phoneNumber}') {
          _showMessageBottom(email, fireUserInfo.metadata.creationTime);
        } else {
          requestPassword();
        }
      } else {
        _showMessageBottom(email, fireUserInfo.metadata.creationTime);
      }
    } on ApiException catch (e) {
      loading.value = false;
      String errormsg = e.message;
      if (e.dioError != null) {
        int statusCode = e.dioError?.response?.statusCode ?? 0;
        if (statusCode == 500) {
          String detailCode =
              e.dioError?.response?.data['details']['code'] as String;
          if (detailCode == 'auth/user-not-found') {
            requestPassword(newMailFirebase: true);
            return;
          }
        }
      }
      Helpers.showError(errormsg);
    } catch (e) {
      loading.value = false;
      Helpers.showError('¡Opps! Parace que hubo un error',
          devError: e.toString());
    }
  }

  void _showMessageBottom(String email, String dateCreated) async {
    if (Get.overlayContext == null) return;

    errorFirebase.value = false;
    errorFirebaseMsg = '';
    final resp = await showMaterialModalBottomSheet(
      context: Get.overlayContext!,
      backgroundColor: Colors.transparent,
      builder: (context) => EmailAlreadyWidget(
        email: email,
        dateCreated: dateCreated,
        onYesTap: () => Get.back(result: true),
        onNoTap: () => Get.back(result: false),
      ),
    );

    if (resp is bool) {
      if (resp) {
        requestPassword();
      } else {
        errorFirebase.value = true;
        errorFirebaseMsg = emailLinkedOtherAccount;
      }
    } else {
      errorFirebase.value = true;
      errorFirebaseMsg = emailLinkedOtherAccount;
    }
  }

  void requestPassword({bool newMailFirebase = false}) {
    Get.toNamed(AppRoutes.LOGIN_ENTER_PASSWORD,
        arguments: LoginEnterPasswordArguments(
            newMailFirebase: newMailFirebase, email: email));
  }

  // Validators
  String? validateEmail(String? text) {
    if (text != null && text.trim().isEmail) {
      return null;
    }
    return 'Email no válido';
  }

  String get emailLinkedOtherAccount =>
      'Este email está vinculado a otra cuenta. Ingresa uno diferente para crear una cuenta nueva.';
}
