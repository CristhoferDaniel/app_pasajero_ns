import 'dart:async';

import 'package:app_pasajero_ns/data/models/firebase_user_info.dart';
import 'package:app_pasajero_ns/modules/auth/auth_controller.dart';
import 'package:app_pasajero_ns/modules/login/countries/country_selection_controller.dart';
import 'package:app_pasajero_ns/modules/login/enter_password/login_enter_password_controller.dart';
import 'package:app_pasajero_ns/modules/login/phone_credentials/phone_credentials_page.dart';
import 'package:app_pasajero_ns/modules/login/phone_credentials/verify_phone_controller.dart';
import 'package:app_pasajero_ns/routes/app_pages.dart';
import 'package:app_pasajero_ns/utils/utils.dart';
import 'package:app_pasajero_ns/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final _authX = Get.find<AuthController>();
  PhoneAuthCredential? _phoneCredentials;
  PhoneAuthCredential? get phoneCredentials => this._phoneCredentials;

  final formKey = GlobalKey<FormState>();

  final loading = false.obs;

  // SMS
  String countrySelected = 'PE';
  String dialSelected = '+51';
  String phoneNumber = '888888888'; // 987355814
  final sendEnabledSMS = true.obs;
  final secondsTimer = 30.obs;
  final verificationId = ''.obs;
  final incorrectOTPCode = false.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    _authX.setListenAuthChanges(false);
  }

  @override
  void onClose() {
    super.onClose();
    _timer?.cancel();
  }

  void onNextPressed() {
    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState?.save();
      Get.focusScope?.unfocus();

      _launchSendSMS();
    }
  }

  Future<void> initFlowLoginRegister(PhoneAuthCredential phoneCreds) async {
    this._phoneCredentials = phoneCreds;
    bool? hasEmailOrSocial;

    String emailAsociated = '';

    try {
      loading.value = true;
      final phoneUser = await _authX.auth.signInWithCredential(phoneCreds);
      // Importante. Para remover el verifyController
      Get.back();
      await Get.delete<VerifyPhoneController>();
      // Fin verifyController
      if (phoneUser.user is User) {
        bool onlyPhoneProvider =
            checkIfHasProviderLikeUnique(phoneUser.user!, ProviderId.PHONE);

        if (onlyPhoneProvider) {
          await phoneUser.user!.delete();
        } else {
          emailAsociated = phoneUser.user!.email ?? '';
        }
        hasEmailOrSocial = !onlyPhoneProvider;
      }
    } on FirebaseAuthException catch (e) {
      String errormsg = AppIntl.getFirebaseErrorMessage(e.code);
      if (e.code == 'invalid-verification-code') {
        incorrectOTPCode.value = true;
      }
      if (e.code == 'session-expired') {
        errormsg = 'Tiempo expirado. Selecciona la opción de reenviar. ';
      }

      Helpers.showError(errormsg, devError: e.code);
    } catch (e) {
      Helpers.showError('¡Opps! Parece que hubo un error',
          devError: e.toString());
    } finally {
      loading.value = false;
      await _authX.auth.signOut();
    }

    if (hasEmailOrSocial == null) return;

    if (hasEmailOrSocial) {
      if (emailAsociated != '') {
        Get.toNamed(AppRoutes.LOGIN_ENTER_PASSWORD,
            arguments: LoginEnterPasswordArguments(
                newMailFirebase: false, email: emailAsociated));
      }
    } else {
      Get.toNamed(AppRoutes.LOGIN_ENTER_EMAIL);
    }
  }

  Future<void> _launchSendSMS() async {
    // Limpia las credenciales cuando envia el SMS
    this._phoneCredentials = null;
    print('Enviando mensaje a: $dialSelected$phoneNumber');
    loading.value = true;
    return await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: dialSelected + phoneNumber,
      timeout: const Duration(seconds: 15),
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
          dialSelected: dialSelected,
          phoneNumber: phoneNumber,
          onResendTap: _launchSendSMS,
          parentLoading: loading,
          parentIncorrectCode: incorrectOTPCode,
          verificationId: verificationId,
          onNextTap: initFlowLoginRegister,
          onAnyInputFocus: () {
            if (incorrectOTPCode.value) {
              incorrectOTPCode.value = false;
            }
          }),
      // tag: '$timestamp',
    );
    Get.to(
      () => PhoneCredentialsPage(_verifyPhoneX),
      transition: Transition.cupertino,
    );
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

  bool checkIsCurrentPage() {
    final result = Get.currentRoute == AppRoutes.LOGIN;
    return result;
  }

  bool checkIfHasProviderLikeUnique(User user, ProviderId providerToCompare) {
    bool sameProviderIsOnly = false;
    // Comprueba si la sesión que se inició con la red social
    // tiene como único proveedor a providerToCompare
    user.providerData.forEach((e) {
      final provider = providerIdValues.map[e.providerId];
      if (providerToCompare == provider && user.providerData.length == 1) {
        sameProviderIsOnly = true;
      }
    });
    return sameProviderIsOnly;
  }

  bool checkIfHasProvider(User user, ProviderId providerToCompare) {
    bool foundProvider = false;
    // Comprueba si existe providerToCompare en la lista
    // de proveedores
    user.providerData.forEach((e) {
      final provider = providerIdValues.map[e.providerId];
      if (providerToCompare == provider) {
        foundProvider = true;
      }
    });
    return foundProvider;
  }

  void goTerminosCondicionesPage() {
    Get.toNamed(AppRoutes.TERMINOS_CONDICIONES);
  }

  void goToCountrySelectPage() async {
    Get.focusScope?.unfocus();
    final resp = await Get.toNamed(
      AppRoutes.COUNTRY_SELECTION,
      arguments: {'countrySelected': countrySelected},
    );
    if (resp is CountryResponse) {
      countrySelected = resp.countryCode;
      dialSelected = resp.dialCode;
    }
    update(['gbDial']);
  }

  String? validatePhoneNumber(String? text) {
    if (text != null && text.trim().replaceAll(' ', '').length == 9) {
      return null;
    }
    return 'Teléfono no válido';
  }
}
