import 'package:app_pasajero_ns/data/models/firebase_user_info.dart';
import 'package:app_pasajero_ns/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/instance_manager.dart';

class AuthProvider {
  final DioClient _dioClient = Get.find<DioClient>();

  final String _endpoint = '/auth';

  Future<FirebaseUserInfo> searchFirebaseUserByUid(String uid) async {
    final resp =
        await _dioClient.get('$_endpoint/uid', queryParameters: {'uid': uid});
    return FirebaseUserInfo.fromJson(resp);
  }

  Future<FirebaseUserInfo> searchFirebaseUserByEmail(String email) async {
    final resp = await _dioClient
        .post('$_endpoint/validate/email', data: {'email': email});
    return FirebaseUserInfo.fromJson(resp);
  }

  Future<UserCredential> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return userCredential;
  }
}
