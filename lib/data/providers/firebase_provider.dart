import 'package:firebase_auth/firebase_auth.dart';

class FirebaseProvider {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    return _auth.createUserWithEmailAndPassword(
        email: email, password: password);
  }
}
