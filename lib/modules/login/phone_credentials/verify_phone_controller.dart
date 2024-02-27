import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sms_autofill/sms_autofill.dart';

// todo: A VECES NO TRAE PHONENUMBER
class VerifyPhoneController extends GetxController with CodeAutoFill {
  VerifyPhoneController({
    required this.sendEnabledSMS,
    required this.secondsTimer,
    required this.dialSelected,
    required this.phoneNumber,
    required this.parentLoading,
    required this.parentIncorrectCode,
    required this.verificationId,
    required this.onResendTap,
    required this.onNextTap,
    required this.onAnyInputFocus,
  });

  final RxBool sendEnabledSMS;
  final RxInt secondsTimer;
  final String dialSelected;
  final String phoneNumber;
  final RxBool parentLoading;
  final RxBool parentIncorrectCode;
  final RxString verificationId;
  final void Function() onResendTap;
  final void Function(PhoneAuthCredential phoneCredential) onNextTap;
  final void Function() onAnyInputFocus;

  TextEditingController pin1Ctlr = new TextEditingController();
  TextEditingController pin2Ctlr = new TextEditingController();
  TextEditingController pin3Ctlr = new TextEditingController();
  TextEditingController pin4Ctlr = new TextEditingController();
  TextEditingController pin5Ctlr = new TextEditingController();
  TextEditingController pin6Ctlr = new TextEditingController();

  StreamSubscription<String>? _streamSmsSubscription;
  String smsCode = '';

  RxBool enableSubmit = RxBool(false);
  RxBool incorrectCode = RxBool(false);

  RxBool loading = RxBool(false);

  @override
  void onInit() {
    super.onInit();

    ever<bool>(parentLoading, (val) {
      this.loading.value = val;
    });

    ever<bool>(parentIncorrectCode, (val) {
      this.incorrectCode.value = val;
    });

    startListeningSMS();
    pin1Ctlr.addListener(_onAnyFocus);
    pin2Ctlr.addListener(_onAnyFocus);
    pin3Ctlr.addListener(_onAnyFocus);
    pin4Ctlr.addListener(_onAnyFocus);
    pin5Ctlr.addListener(_onAnyFocus);
    pin6Ctlr.addListener(_onAnyFocus);
  }

  @override
  void onClose() {
    super.onClose();
    cancelListeningSMS();
    pin1Ctlr.removeListener(_onAnyFocus);
    pin2Ctlr.removeListener(_onAnyFocus);
    pin3Ctlr.removeListener(_onAnyFocus);
    pin4Ctlr.removeListener(_onAnyFocus);
    pin5Ctlr.removeListener(_onAnyFocus);
    pin6Ctlr.removeListener(_onAnyFocus);
  }

  void _onAnyFocus() {
    this.onAnyInputFocus.call();

    if (sanitizeOTP().length == 6) {
      if (!enableSubmit.value) {
        enableSubmit.value = true;
      }
    } else {
      if (enableSubmit.value) {
        enableSubmit.value = false;
      }
    }
  }

  void startListeningSMS() async {
    await cancelListeningSMS();
    print('startListeningSMS');
    // ignore: unnecessary_statements
    SmsAutoFill().listenForCode;
    _streamSmsSubscription = SmsAutoFill().code.listen((event) {
      smsCode = event;
      autoFillInputs(smsCode);
      startListeningSMS();
    });
  }

  Future<void> cancelListeningSMS() async {
    print('cancelListeningSMS');
    await _streamSmsSubscription?.cancel();
    return SmsAutoFill().unregisterListener();
  }

  String sanitizeOTP() {
    String pin1 = pin1Ctlr.text.trim();
    String pin2 = pin2Ctlr.text.trim();
    String pin3 = pin3Ctlr.text.trim();
    String pin4 = pin4Ctlr.text.trim();
    String pin5 = pin5Ctlr.text.trim();
    String pin6 = pin6Ctlr.text.trim();
    String otpCode = '$pin1$pin2$pin3$pin4$pin5$pin6';
    return otpCode;
  }

  void autoFillInputs(String code) async {
    Get.focusScope?.unfocus();
    pin1Ctlr.text = '';
    pin2Ctlr.text = '';
    pin3Ctlr.text = '';
    pin4Ctlr.text = '';
    pin5Ctlr.text = '';
    pin6Ctlr.text = '';
    await delay();
    pin1Ctlr.text = code[0];
    await delay();
    pin2Ctlr.text = code[1];
    await delay();
    pin3Ctlr.text = code[2];
    await delay();
    pin4Ctlr.text = code[3];
    await delay();
    pin5Ctlr.text = code[4];
    await delay();
    pin6Ctlr.text = code[5];
    onNext();
  }

  void onNext() async {
    String _code = sanitizeOTP();
    if (_code.length == 6) {
      Get.focusScope?.unfocus();
      emitPhoneAuthCredential(_code);
    }
  }

  Future<void> emitPhoneAuthCredential(String otpCode) async {
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: verificationId.value, smsCode: otpCode);
    onNextTap.call(phoneAuthCredential);
  }

  void reSendSMS() {
    startListeningSMS();
    onResendTap.call();
  }

  Future<void> delay() {
    return Future.delayed(Duration(milliseconds: 50));
  }

  @override
  void codeUpdated() {}
}
