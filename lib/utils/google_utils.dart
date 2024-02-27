part of 'utils.dart';

class GoogleUtils {
  static Future<void> sleep(int milliseconds) async {
    await Future.delayed(Duration(milliseconds: milliseconds));
  }
}
