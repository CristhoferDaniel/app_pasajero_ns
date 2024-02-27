import 'package:app_pasajero_ns/data/models/travel_info.dart';
import 'package:app_pasajero_ns/data/providers/cliente_provider.dart';
import 'package:app_pasajero_ns/data/providers/travel_info_provider.dart';
import 'package:app_pasajero_ns/data/services/push_notifications_service.dart';
import 'package:app_pasajero_ns/modules/auth/auth_controller.dart';
import 'package:app_pasajero_ns/routes/app_pages.dart';
import 'package:app_pasajero_ns/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InitialController extends GetxController {
  final _authX = Get.find<AuthController>();
  final _clienteProvider = ClienteProvider();
  final _travelInfoProvider = TravelInfoProvider();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> firstLogic() async {
    _updateFcmToken();

    await _preloadPhoto();

    _checkTravelActive();
  }

  Future<void> _checkTravelActive33() async {
    try {
      print('vamos');
    } catch (e) {
      print('psi error');
    }
  }

  Future<void> _checkTravelActive() async {
    try {
      final tvl = await _travelInfoProvider.getByUidClient(_authX.getUser!.uid);
      if (tvl != null) {
        switch (tvl.status) {
          // case TravelStatus.CREATED:
          // TODO: QUE HACER CUANDO ES CREATED

          case TravelStatus.ACCEPTED:
          case TravelStatus.ARRIVED:
          case TravelStatus.STARTED:
            Get.offNamed(AppRoutes.TAXI_TRAVEL);
            break;
          case TravelStatus.FINISHED:
            Get.offAllNamed(AppRoutes.TAXI_FINISHED);
            break;
          default:
            Get.offAllNamed(AppRoutes.HOME);
        }
      } else {
        Get.offAllNamed(AppRoutes.HOME);
      }
    } catch (e) {
      Helpers.showError(e.toString());
      Helpers.showError('Hubo un error validando la configuración inicial');
    }
  }

  // Actualización de FCM Token.
  int intervalRetrySeconds = 5;
  final maxAttempts = 8;
  int attempts = 0;
  Future<void> _updateFcmToken() async {
    final fcmToken = PushNotificationsService.token;
    if (fcmToken == null) {
      Helpers.logger.e('Error solicitando FCM Token del dispositivo.');
      return;
    }
    while (attempts < maxAttempts) {
      if (_authX.backendUser != null) {
        attempts++;
        final user = _authX.backendUser!;
        try {
          final resp =
              await _clienteProvider.updateFcmToken(user.idCliente, fcmToken);
          if (resp.success) {
            final _updatedDto = _authX.backendUser!.copyWith(fcm: fcmToken);
            _authX.setBackendUser(_updatedDto);
            return;
          }
        } catch (e) {
          Helpers.logger
              .e('No se pudo actualizar FCM Token. Details: ${e.toString()}');
        }
        await Future.delayed(Duration(seconds: intervalRetrySeconds));
      }
    }
  }

  Future<void> _preloadPhoto() async {
    try {
      if (_authX.backendUser != null && _authX.backendUser!.foto != null)
        await precacheImage(
            NetworkImage(
                _authX.backendUser!.foto! + '?v=${_authX.userPhotoVersion}'),
            Get.overlayContext!);

      await precacheImage(
          NetworkImage('https://i.imgur.com/I7vSMtN.png'), Get.overlayContext!);
    } catch (e) {
      print('Error en _preloadPhoto');
    }
  }
}
