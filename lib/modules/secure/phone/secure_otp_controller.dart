import 'dart:async';

import 'package:app_pasajero_ns/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sms_autofill/sms_autofill.dart';

class SecureOtpController extends GetxController with CodeAutoFill {
  SecureOtpController({
    required this.sendEnabledSMS,
    required this.secondsTimer,
    required this.dialSelected,
    required this.phoneNumber,
    required this.parentLoading,
    required this.verificationOTP,
    required this.onResendTap,
    required this.onEnterValidOtp,
  });

  late ScrollController scrollController;
  final gbAppbar = 'gbAppbar';

  final RxBool sendEnabledSMS;
  final RxInt secondsTimer;
  final String dialSelected;
  final String phoneNumber;
  final RxBool parentLoading;
  final RxnInt verificationOTP;
  final void Function() onResendTap;
  final void Function() onEnterValidOtp;

  RxBool enableSubmit = RxBool(false);
  RxBool loading = RxBool(false);
  final errorOtpMsg = RxnString();

  final formKey = GlobalKey<FormState>();
  final fieldTxtCtlr = TextEditingController();

  StreamSubscription<String>? _streamSmsSubscription;
  // ignore: close_sinks
  StreamController<ErrorAnimationType>? errorController;

  @override
  void onInit() {
    super.onInit();

    scrollController = ScrollController()
      ..addListener(() {
        update([gbAppbar]);
      });

    errorController = StreamController<ErrorAnimationType>();

    ever<bool>(parentLoading, (val) {
      this.loading.value = val;
    });

    _startListeningSMS();
  }

  @override
  void onClose() {
    scrollController.dispose();
    errorController!.close();
    _cancelListeningSMS();

    super.onClose();
  }

  void _startListeningSMS() async {
    await _cancelListeningSMS();
    // print('StartListeningSMS');
    listenForCode();
    _streamSmsSubscription = SmsAutoFill().code.listen((event) {
      _startListeningSMS();
      fieldTxtCtlr.text = event;
    });
  }

  Future<void> _cancelListeningSMS() async {
    // print('CancelListeningSMS');
    await _streamSmsSubscription?.cancel();
    return SmsAutoFill().unregisterListener();
  }

  bool isCodeOtpOk = false;
  Future<void> onNext() async {
    if (isCodeOtpOk) return;

    if (fieldTxtCtlr.text == '${verificationOTP.value}') {
      isCodeOtpOk = true; // Importante
      loading.value = true;
      await Helpers.sleep(500);
      loading.value = false;
      onEnterValidOtp.call();
    } else {
      errorController!.add(ErrorAnimationType.shake);
      errorOtpMsg.value = 'Código incorrecto';
    }
  }

  void reSendSMS() {
    _startListeningSMS();
    onResendTap.call();
  }

  void goEmailLoginForm() {
    //_startListeningSMS();
    //onResendTap.call();
    onEnterValidOtp.call();
  }

  void validEnableNextButton(String input) {
    if (input.length == 6) {
      enableSubmit.value = true;
    } else {
      enableSubmit.value = false;
    }
  }

  void onTapField() {
    if (errorOtpMsg.value?.isNotEmpty ?? false) {
      errorOtpMsg.value = null;
    }
  }

  Future<bool> handleBack() async {
    if (loading.value) return false;
    Get.focusScope?.unfocus();
    return true;
  }

  @override
  void codeUpdated() {}
}
