part of 'utils.dart';

class AppIntl {
  static String getFirebaseErrorMessage(String code) {
    Map<String, String> errors = {
      'email-already-in-use':
          'Este correo electrónico ya pertence a otro usuario.',
      'credential-already-in-use': 'Esta credencial pertenece a otra cuenta.',
      'invalid-email': 'El email no es válido.',
      'operation-not-allowed': 'La creación de cuentas no está permitida.',
      'weak-password': 'La contraseña no es lo suficientemente segura.',
      'network-request-failed': 'Comprueba tu conexión a internet.',
      'user-not-found': 'Usuario no encontrado.',
      'wrong-password': 'Contraseña incorrecta.',
      'too-many-requests': 'Muchos intentos fallidos. Pruebe en unos minutos.',
      'invalid-phone-number': 'Número de celular inválido.',
      'invalid-verification-code': 'El código de verificación es incorrecto.',
    };
    return errors[code] ?? 'Hubo un error con la autenticación';
  }
}
