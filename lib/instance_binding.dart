import 'package:app_pasajero_ns/modules/app_prefs/app_prefs_controller.dart';
import 'package:app_pasajero_ns/modules/auth/auth_controller.dart';
import 'package:app_pasajero_ns/utils/utils.dart';
import 'package:app_pasajero_ns/widgets/widgets.dart';
import 'package:app_pasajero_ns/utils/getx_storage.dart';
import 'package:dio/dio.dart';

import 'package:get/get.dart';

class InstanceBinding extends Bindings {
  @override
  void dependencies() {
    final Dio dio = Dio();

    Get.put(DioClient(
      Constants.URL_API_BACKEND,
      dio,
      interceptors: [
        AppInterceptors(),
        /*if (kDebugMode)
          PrettyDioLogger(
              requestHeader: true,
              requestBody: true,
              responseBody: true,
              responseHeader: false,
              error: true,
              compact: true,
              maxWidth: 90) */
      ],
    ));

    final Dio _dioMailJet = Dio();
    Get.put(DioMailJet(_dioMailJet));

    Get.put(AuthController());

    Get.put(AppPrefsController());

    //Get.put(KeyboardController());
    /*Get.put(DioClient(Constants.URL_API_BACKEND, dio,interceptors: [
      ],));*/
  }
}

class AppInterceptors extends InterceptorsWrapper {
  GetxStorageController _getxStorage = GetxStorageController();
  @override
  Future onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      final _authX = Get.find<AuthController>();
      Constants.TOKEN = await _getxStorage.read('token') ?? '';

      if (_authX.getUser != null) {
        options.headers["Authorization"] = Constants.TOKEN;
      }
    } catch (e) {
      Helpers.logger.e("No se encontró auth controller");
    }

    return super.onRequest(options, handler);
  }

  @override
  onResponse(dynamic response, ResponseInterceptorHandler handler) {
    return super.onResponse(response, handler);
  }

  @override
  onError(DioError err, ErrorInterceptorHandler handler) {
    try {
      final _authX = Get.find<AuthController>();
      if (err.response?.statusCode == 401 &&
          err.requestOptions.path != '/securitysystem/login') {
        AppSnackbar()
            .error(message: 'Sesión caducada!\nInicie sesión nuevamente');
        _authX.logout();
      } else {
        super.onError(err, handler);
      }
    } catch (e) {
      Helpers.logger.e("No se encontró auth controller");
    }
  }
}

class DioMailJet extends DioClient {
  DioMailJet(Dio? dio) : super('https://api.mailjet.com/v4', dio);
}
