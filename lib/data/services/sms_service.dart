import 'dart:math';

import 'package:app_pasajero_ns/config/config.dart';
import 'package:app_pasajero_ns/instance_binding.dart';
import 'package:dio/dio.dart';
import 'package:get/instance_manager.dart';

class SmsService {
  final DioMailJet _dioClient = Get.find<DioMailJet>();

  Future<int> sendVerificationOTP(String phoneNumber) async {
    final Random random = new Random();
    int min = 100000;
    int max = 999999;
    int radomOtpCode = min + random.nextInt(max - min);

    await _dioClient.post(
      '/sms-send',
      data: {
        'From': Config.APP_COMPANY_NAME,
        'To': phoneNumber,
        'Text':
            '$radomOtpCode es tu código ${Config.APP_COMPANY_NAME}. Nunca lo compartas con nadie. ${Config.APP_SIGNATURE}'
      },
      options: Options(
        headers: {'Authorization': 'Bearer ${Config.SMS_MAILJET_APIKEY}'},
      ),
    );
    return radomOtpCode;
  }

  Future<int> sendVerificationGamanet(String phoneNumber) async {
    final Random random = new Random();
    int min = 100000;
    int max = 999999;
    int radomOtpCode = min + random.nextInt(max - min);

    await _dioClient.post(
      '${Config.URL_API_GAMANET}',
      data: {
        'apicard': '${Config.API_CARD_GAMANET}',
        'apikey': '${Config.API_KEY_GAMANET}',
        'smsnumber': phoneNumber,
        'smstext':
            '$radomOtpCode es tu código ${Config.APP_COMPANY_NAME}. Nunca lo compartas con nadie. ${Config.APP_SIGNATURE}',
        'smstype': 1,
        'shorturl': 0
      },
      options: Options(
        headers: {'Authorization': 'Bearer ${Config.API_TOKEN_GAMANET}'},
      ),
    );
    return radomOtpCode;
  }
}
