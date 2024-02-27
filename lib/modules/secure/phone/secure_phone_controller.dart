import 'dart:async';

import 'package:app_pasajero_ns/config/config.dart';
import 'package:app_pasajero_ns/data/services/sms_service.dart';
import 'package:app_pasajero_ns/modules/misc/error/misc_error_controller.dart';
import 'package:app_pasajero_ns/modules/secure/countries/country_selection_controller.dart';
import 'package:app_pasajero_ns/modules/secure/phone/secure_otp_controller.dart';
import 'package:app_pasajero_ns/modules/secure/phone/secure_otp_page.dart';
import 'package:app_pasajero_ns/modules/terminos/terminos_condiciones_controller.dart';
import 'package:app_pasajero_ns/routes/app_pages.dart';
import 'package:app_pasajero_ns/utils/utils.dart';
import 'package:app_pasajero_ns/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SecurePhoneController extends GetxController {
  SecurePhoneController({
    required this.enableBack,
    required this.parentLoading,
    required this.onValidatedOTP,
  });

  late ScrollController scrollController;
  final gbAppbar = 'gbAppbar';

  final bool enableBack;
  final RxBool parentLoading;
  final void Function(String dialSelected, String phoneNumber) onValidatedOTP;

  late SecurePhoneController _self;

  final _smsService = SmsService();
  final formKey = GlobalKey<FormState>();
  final loading = false.obs;

  // SMS
  String countrySelected = 'PE';
  String dialSelected = '+51';
  String phoneNumber = '';
  final sendEnabledSMS = true.obs;
  final secondsTimer = (Config.SMS_RETRY_TIME).obs;
  final verificationOTP = RxnInt();
  Timer? _timer;

  // GetBuilders ID's
  final gbDial = 'gbDial';

  @override
  void onInit() {
    super.onInit();
    this._self = this;

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
    _timer?.cancel();
    super.onClose();
  }

  Future<void> onNextPressed() async {
    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState?.save();
      Get.focusScope?.unfocus();

      _launchSendSMS();
    }
  }

  Future<void> _launchSendSMS() async {
    String? errorMsg;
    try {
      loading.value = true;
      // Si el número ingresado es igual al número de testeo.
      // Para los testers internos y App Store
      if (Config.TEST_PHONE_NUMBERS.contains(dialSelected + phoneNumber)) {
        verificationOTP.value = 123456;
      } else {
        verificationOTP.value =
            await _smsService.sendVerificationGamanet(/*dialSelected + */phoneNumber);
      }
    } on ApiException catch (e) {
      errorMsg = e.message;
      Helpers.logger.e(e.message);
    } on BusinessException catch (e) {
      errorMsg = e.message;
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
        _launchSendSMS();
      } else {
        loading.value = false;
      }
    } else {
      loading.value = false;
      if (verificationOTP.value != null) {
        _startTimer();
        if (_checkIsCurrentPage()) {
          _onCodeSent();
        } else {
          AppSnackbar().success(message: 'Mensaje enviado');
        }
      }
    }
  }

  Future<void> _onCodeSent() async {
    await Get.delete<SecureOtpController>();
    final _otpValidateX = Get.put(
      SecureOtpController(
          sendEnabledSMS: sendEnabledSMS,
          secondsTimer: secondsTimer,
          dialSelected: dialSelected,
          phoneNumber: phoneNumber,
          onResendTap: _launchSendSMS,
          parentLoading: loading,
          verificationOTP: verificationOTP,
          onEnterValidOtp: _onEnterValidOtp),
    );
    await Get.to(
      () => SecureOtpPage(_otpValidateX),
      transition: Transition.cupertino,
    );
    await Get.delete<SecureOtpController>();
  }

  Future<void> _onEnterValidOtp() async {
    this.onValidatedOTP.call(dialSelected, phoneNumber);
    return;
  }

  Future<bool> handleBack() async {
    if (loading.value) return false;

    if (enableBack) {
      Get.focusScope?.unfocus();
    }

    return enableBack;
  }

  void _startTimer() {
    sendEnabledSMS.value = false;
    _timer?.cancel();
    secondsTimer.value = (Config.SMS_RETRY_TIME);
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (secondsTimer.value == 0) {
        timer.cancel();
        sendEnabledSMS.value = true;
        secondsTimer.value = (Config.SMS_RETRY_TIME);
      } else {
        secondsTimer.value--;
      }
    });
  }

  bool _checkIsCurrentPage() {
    final result = Get.currentRoute == '/SecurePhonePage';
    return result;
  }

  void goTerminosCondicionesPage() {
    Get.focusScope?.unfocus();
    Get.toNamed(AppRoutes.TERMINOS_CONDICIONES,
        arguments:
            TerminosCondicionesControllerArguments(showActionButtons: false));
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
    update([gbDial]);
  }

  // Validators
  String? validatePhoneFormat(String? text) {
    if (text != null && text.trim().replaceAll(' ', '').length == 9) {
      return null;
    }
    return 'Teléfono no válido';
  }
}
