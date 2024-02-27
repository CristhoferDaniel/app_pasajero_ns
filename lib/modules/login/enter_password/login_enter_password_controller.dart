import 'dart:async';

import 'package:app_pasajero_ns/data/providers/auth_provider.dart';
import 'package:app_pasajero_ns/data/providers/cliente_provider.dart';
import 'package:app_pasajero_ns/modules/auth/auth_controller.dart';
import 'package:app_pasajero_ns/modules/login/enter_email/login_enter_email_page.dart';
import 'package:app_pasajero_ns/modules/login/login_controller.dart';
import 'package:app_pasajero_ns/modules/login/phone_credentials/phone_credentials_page.dart';
import 'package:app_pasajero_ns/modules/login/phone_credentials/verify_phone_controller.dart';
import 'package:app_pasajero_ns/modules/login/reset_password/login_reset_password_controller.dart';
import 'package:app_pasajero_ns/routes/app_pages.dart';
import 'package:app_pasajero_ns/utils/utils.dart';
import 'package:app_pasajero_ns/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class LoginEnterPasswordController extends GetxController {
  final _authX = Get.find<AuthController>();
  final _phoneX = Get.find<LoginController>();

  final _authProvider = AuthProvider();
  final _clienteProvider = ClienteProvider();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String confirmPassword = '';

  FocusNode passwordFocusNode = FocusNode();
  FocusNode confirmPasswordFocusNode = FocusNode();

  TextEditingController passwordCtlr = TextEditingController();

  RxBool newMailFirebase = RxBool(false);

  RxBool hidePassword = RxBool(true);
  RxBool hideConfirmPassword = RxBool(true);

  RxBool disabledNextButton = RxBool(true);

  String? passwordError;

  RxBool loading = RxBool(false);

  @override
  void onInit() {
    super.onInit();
    _init();
  }

  void _init() async {
    if (!(Get.arguments is LoginEnterPasswordArguments)) {
      Helpers.showError('Falta pasar los argumentos');
      return;
    }

    final arguments = Get.arguments as LoginEnterPasswordArguments;
    email = arguments.email;
    if (!(email.isEmail)) {
      Helpers.showError('No es un email válido');
      return;
    }
    newMailFirebase.value = arguments.newMailFirebase;

    await Future.delayed(Duration(milliseconds: 400));
    passwordFocusNode.requestFocus();
  }

  void handleStatusNextButton(String text) {
    final hasError = validatePassword(text);
    disabledNextButton.value = (hasError != null);
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
      _loginOrCreate();
    }
  }

  Future<void> _loginOrCreate() async {
    bool? existsEmailInFirebase;

    try {
      loading.value = true;
      await _authProvider.searchFirebaseUserByEmail(email);
      existsEmailInFirebase = true;
    } on ApiException catch (e) {
      String errormsg = e.message;
      if (e.dioError != null) {
        int statusCode = e.dioError?.response?.statusCode ?? 0;
        if (statusCode == 500) {
          String detailCode =
              e.dioError?.response?.data['details']['code'] as String;
          if (detailCode == 'auth/user-not-found') {
            existsEmailInFirebase = false;
          }
        }
      }
      if (existsEmailInFirebase == null) Helpers.showError(errormsg);
    } catch (e) {
      Helpers.showError('¡Opps! Parace que hubo un problema',
          devError: e.toString());
    } finally {
      loading.value = false;
    }

    if (existsEmailInFirebase == null) return;

    bool creatingUserFirebase = !existsEmailInFirebase;
    try {
      loading.value = true;
      if (creatingUserFirebase) {
        print('Creating...');
        await _authX.auth
            .createUserWithEmailAndPassword(email: email, password: password);
      } else {
        print('Signing...');
        final resp=await _authX
            .signInWithEmailPassword(email:email,password:password);
      }
      loading.value = false;
    } on FirebaseAuthException catch (e) {
      loading.value = false;
      String errormsg = AppIntl.getFirebaseErrorMessage(e.code);
      Helpers.showError(errormsg, devError: e.code);
      return;
    } catch (e) {
      loading.value = false;
      Helpers.showError('¡Opps! Parece que hubo un problema.',
          devError: e.toString());
      return;
    }

    if (_authX.getUser == null) return;
    if (_phoneX.phoneCredentials == null) return;

    if (!_authX.getUser!.emailVerified) {
      _sendMailVerification();
      return;
    }

    // Actualizando el número de teléfono
    if (_authX.getUser!.phoneNumber !=
        '${_phoneX.dialSelected}${_phoneX.phoneNumber}') {
      try {
        await _authX.getUser!.updatePhoneNumber(_phoneX.phoneCredentials!);
        loading.value = false;
      } on FirebaseAuthException catch (e) {
        loading.value = false;
        String errormsg = AppIntl.getFirebaseErrorMessage(e.code);
        await _authX.auth.signOut();
        if (e.code == 'session-expired') {
          Helpers.logger.e(e.code);
          _reValidateSMS();
        } else {
          Helpers.showError(errormsg, devError: e.code);
        }
        return;
      } catch (e) {
        loading.value = false;
        Helpers.showError('¡Opps! Parece que hubo un problema.',
            devError: e.toString());
        await _authX.auth.signOut();
        return;
      }
    }

    // Validando que el Firebase Account tenga email y celular
    if (_authX.getUser!.phoneNumber == null || _authX.getUser!.email == null) {
      return;
    }

    // Busca en el backend si existe una cuenta asociada a ese UID
    bool? existsBackendUser;
    // ClienteCreate? backendUserFound;
    try {
      loading.value = true;
      final resp = await _clienteProvider.searchByUid(_authX.getUser!.uid);
      if (resp.success) {
        existsBackendUser = true;
        // backendUserFound = resp.data;
      } else {
        Helpers.showError('Proceso de registro incompleto!');
      }
    } on ApiException catch (e) {
      if (e.dioError != null) {
        int statusCode = e.dioError?.response?.statusCode ?? 0;
        if (statusCode == 404) {
          bool success = e.dioError?.response?.data['success'] as bool;
          if (success == false) {
            existsBackendUser = false;
          }
        }
      }
      if (existsBackendUser == null) Helpers.showError(e.message);
    } catch (e) {
      Helpers.showError('¡Opps! Parece que hubo un problema.',
          devError: e.toString());
    } finally {
      loading.value = false;
    }

    if (existsBackendUser == null) return;

    bool creatingUserBackend = !existsBackendUser;
    if (creatingUserBackend) {
      Get.toNamed(AppRoutes.LOGIN_EXTRA_INFO);
    } else {
      /* _authX.setBackendUser(backendUserFound);
      _authX.setListenAuthChanges(true);
      _authX.firebaseUser.value = _authX.getUser!; */
    }
  }

  PhoneAuthCredential? refreshPhoneCredential;
  final sendEnabledSMS = true.obs;
  final secondsTimer = 30.obs;
  final verificationId = ''.obs;
  final incorrectOTPCode = false.obs;
  Timer? _timer;

  Future<void> _reValidateSMS() async {
    refreshPhoneCredential = null;
    loading.value = true;
    return await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: _phoneX.dialSelected + _phoneX.phoneNumber,
      timeout: const Duration(seconds: 30),
      verificationCompleted: (phoneAuthCredential) async {
        loading.value = false;
        print('VerificationCompleted');
      },
      verificationFailed: (verificationFailed) async {
        loading.value = false;
        print('VerificationFailed');
        String errormsg =
            AppIntl.getFirebaseErrorMessage(verificationFailed.code);
        AppSnackbar().error(message: errormsg);
      },
      codeSent: (verificationId, resendingToken) async {
        print('CodeSent');
        this.verificationId.value = verificationId;
        print('ProvVerificationId $verificationId');

        loading.value = false;
        startTimer();

        if (checkIsCurrentPage()) {
          onCodeSent();
        } else {
          AppSnackbar().success(message: 'Mensaje enviado');
        }
      },
      codeAutoRetrievalTimeout: (verificationId) async {
        print('CodeAutoRetrievalTimeout');
      },
    );
  }

  Future<void> onCodeSent() async {
    Get.delete<VerifyPhoneController>();
    final _verifyPhoneX = Get.put(
      VerifyPhoneController(
          sendEnabledSMS: sendEnabledSMS,
          secondsTimer: secondsTimer,
          dialSelected: _phoneX.dialSelected,
          phoneNumber: _phoneX.phoneNumber,
          onResendTap: _reValidateSMS,
          parentLoading: loading,
          parentIncorrectCode: incorrectOTPCode,
          verificationId: verificationId,
          onNextTap: retryUpdatePhoneNumber,
          onAnyInputFocus: () {
            if (incorrectOTPCode.value) {
              incorrectOTPCode.value = false;
            }
          }),
      // tag: '$timestamp',
    );
    Get.to(() => PhoneCredentialsPage(_verifyPhoneX));
  }

  Future<void> retryUpdatePhoneNumber(PhoneAuthCredential phoneCreds) async {
    try {
      loading.value = true;
      await _authX
          .signInWithEmailPassword(email: email, password: password);
      await _authX.getUser!.updatePhoneNumber(phoneCreds);
      loading.value = false;
      Get.back();
      onNextPressed();
    } on FirebaseAuthException catch (e) {
      await _authX.auth.signOut();
      loading.value = false;
      String errormsg = AppIntl.getFirebaseErrorMessage(e.code);
      if (e.code == 'invalid-verification-code') {
        incorrectOTPCode.value = true;
      }
      if (e.code == 'session-expired') {
        errormsg = 'Tiempo expirado. Selecciona la opción de reenviar. ';
      }
      Helpers.showError(errormsg, devError: e.code);
    } catch (e) {
      await _authX.auth.signOut();
      loading.value = false;
      Helpers.showError('¡Opps! Parece que hubo un error',
          devError: e.toString());
    }
  }

  void startTimer() {
    sendEnabledSMS.value = false;
    _timer?.cancel();
    secondsTimer.value = 30;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (secondsTimer.value == 0) {
        timer.cancel();
        sendEnabledSMS.value = true;
        secondsTimer.value = 30;
      } else {
        secondsTimer.value--;
      }
    });
  }

  Future<void> _sendMailVerification() async {
    if (_authX.getUser == null) return;

    try {
      loading.value = true;
      await _authX.getUser!.sendEmailVerification();
      _showMailSent();
    } on FirebaseAuthException catch (e) {
      String errormsg = AppIntl.getFirebaseErrorMessage(e.code);
      Helpers.showError(errormsg, devError: e.code);
    } catch (e) {
      Helpers.showError('¡Opps! Parece que hubo un problema.',
          devError: e.toString());
    } finally {
      loading.value = false;
    }
  }

  Future<void> _showMailSent() async {
    if (Get.overlayContext == null) return;

    final resend = await showMaterialModalBottomSheet(
      context: Get.overlayContext!,
      backgroundColor: Colors.transparent,
      builder: (context) => MailSentWidget(
        onAcceptTap: () => Get.back(result: false),
        onResendTap: () => Get.back(result: true),
      ),
    );

    if (resend is bool && resend == true) {
      _sendMailVerification();
    }
  }

  void goToResetPasswordPage() async {
    Get.focusScope?.unfocus();
    passwordCtlr.text = '';
    handleStatusNextButton('');
    await Future.delayed(Duration(milliseconds: 300));
    await Get.toNamed(AppRoutes.LOGIN_RESET_PASSWORD,
        arguments: LoginResetPasswordArguments(email: email));
    await Future.delayed(Duration(milliseconds: 300));
    passwordFocusNode.requestFocus();
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
    //  return 'Deben ser 6 caracteres o más';
    return 'La contraseña no corresponde a la cuenta designada por el usuario';
  }

  // Validators
  String? validateConfirmPassword(String? text) {
    if (text != null && text.trim() == password) {
      return null;
    }
    return 'Las contraseñas no coinciden';
  }

  bool checkIsCurrentPage() {
    final result = Get.currentRoute == AppRoutes.LOGIN_ENTER_PASSWORD;
    return result;
  }
}

class LoginEnterPasswordArguments {
  final String email;
  final bool newMailFirebase;
  LoginEnterPasswordArguments(
      {required this.email, required this.newMailFirebase});
}
