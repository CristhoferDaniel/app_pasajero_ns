part of 'utils.dart';

class UtilsFunctions {
  /// Verifica que el error sea causado porque no encontró el usuario en Firebase
  ///
  /// Si se trata de otro tipo de error. La función devolverá false
  static bool isFirebaseUserNotFoundError(ApiException e) {
    bool isUserNotFoundError = false;
    if (e.dioError != null) {
      int statusCode = e.dioError?.response?.statusCode ?? 0;
      if (statusCode == 500) {
        if (e.dioError?.response?.data['details'] != null) {
          if (e.dioError?.response?.data['details']['code'] != null) {
            String detailCode =
                e.dioError?.response?.data['details']['code'] as String;
            if (detailCode == 'auth/user-not-found') {
              isUserNotFoundError = true;
            }
          }
        }
      }
    }
    return isUserNotFoundError;
  }

  /// Verifica que el error sea causado porque no encontró el usuario en el Backend
  ///
  /// Si se trata de otro tipo de error. La función devolverá false
  static bool isBackendUserNotFoundError(ApiException e) {
    bool isUserNotFoundError = false;
    if (e.dioError != null) {
      int statusCode = e.dioError?.response?.statusCode ?? 0;
      if (statusCode == 404) {
        if (e.dioError?.response?.data['success'] != null) {
          bool detailCode = e.dioError?.response?.data['success'] as bool;
          if (!detailCode) {
            isUserNotFoundError = true;
          }
        }
      }
    }
    return isUserNotFoundError;
  }
}
