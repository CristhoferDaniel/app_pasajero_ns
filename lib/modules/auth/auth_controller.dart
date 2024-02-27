import 'dart:io' show Platform;

import 'package:app_pasajero_ns/data/models/cliente.dart';
import 'package:app_pasajero_ns/data/models/firebase_user_info.dart';
import 'package:app_pasajero_ns/data/models/login.dart';
import 'package:app_pasajero_ns/data/providers/auth_provider.dart';
import 'package:app_pasajero_ns/data/providers/cliente_provider.dart';
import 'package:app_pasajero_ns/data/providers/login_provider.dart';
import 'package:app_pasajero_ns/modules/initial/initial_controller.dart';
import 'package:app_pasajero_ns/modules/misc/error/misc_error_controller.dart';
import 'package:app_pasajero_ns/routes/app_pages.dart';
import 'package:app_pasajero_ns/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_pasajero_ns/utils/getx_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  GetxStorageController _getxStorage = GetxStorageController(); // Usa tu clase
  late AuthController _self;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final _authProvider = AuthProvider();
  final _clienteProvider = ClienteProvider();
  final _loginProvider = LoginProvider();
  FirebaseAuth get auth => this._auth;
  Rxn<User> firebaseUser = Rxn<User>();
  ClienteDto? _backendUser;

  User? get getUser => _auth.currentUser;
  ClienteDto? get backendUser => this._backendUser;
  Stream<User?> get user => _auth.authStateChanges();
  bool _listenAuthChanges = true;

  void setListenAuthChanges(bool val) => this._listenAuthChanges = val;
  void setBackendUser(ClienteDto? val) => this._backendUser = val;

  int userPhotoVersion = 0;

  @override
  void onInit() {
    super.onInit();
    this._self = this;
  }

  Future<void> initCheckSession() async {
    _checkFirebaseUserSession();
  }

  Future<void> _checkFirebaseUserSession() async {
    if (getUser == null) {
      _startAuthChangeListeners();
      return;
    }

    String? errorMsg;
    FirebaseUserInfo? respFU;
    bool _existsUidInFirebase = false;
    try {
      Helpers.logger.i(getUser!.uid);
      respFU = await _authProvider.searchFirebaseUserByUid(getUser!.uid);
      if (respFU.email == null) {
        throw BusinessException('No se pudo recuperar el email de Firebase');
      }
      _existsUidInFirebase = true;
    } on ApiException catch (e) {
      if (UtilsFunctions.isFirebaseUserNotFoundError(e)) {
        _existsUidInFirebase = false;
      } else {
        errorMsg = e.message;
        Helpers.logger.e(e.message);
      }
    } on BusinessException catch (e) {
      errorMsg = e.message;
      Helpers.logger.e(e.message);
    } catch (e) {
      errorMsg = 'Ocurrió un error inesperado.';
      Helpers.logger.e(e.toString());
    }

    if (_self.isClosed) return;
    if (errorMsg != null) {
      final ers = await Get.toNamed(AppRoutes.MISC_ERROR,
          arguments: MiscErrorArguments(content: errorMsg));
      if (ers == MiscErrorResult.retry) {
        await Helpers.sleep(1500);
        _checkFirebaseUserSession();
      } else {
        // Cierra la aplicación
        if (Platform.isAndroid) SystemNavigator.pop();
      }
    } else {
      if (_existsUidInFirebase) {
        _checkBackendUserSession(getUser!.uid);
      } else {
        _startAuthChangeListeners();
      }
    }
  }

  Future<void> _checkBackendUserSession(String uid) async {
    String? errorMsg;
    ClienteCreateResponse? respBU;
    bool _existsUidEnBackend = false;
    try {
      respBU = await _clienteProvider.searchByUid(uid);
      if (respBU.success) {
        _existsUidEnBackend = true;
      } else {
        throw BusinessException('Error mapeando la respuesta del backend.');
      }
    } on ApiException catch (e) {
      if (UtilsFunctions.isBackendUserNotFoundError(e)) {
        _existsUidEnBackend = false;
      } else {
        errorMsg = e.message;
        Helpers.logger.e(e.message);
      }
    } on BusinessException catch (e) {
      errorMsg = e.message;
      Helpers.logger.e(e.message);
    } catch (e) {
      errorMsg = 'Ocurrió un error inesperado.';
      Helpers.logger.e(e.toString());
    }

    if (_self.isClosed) return;
    if (errorMsg != null) {
      final ers = await Get.toNamed(AppRoutes.MISC_ERROR,
          arguments: MiscErrorArguments(content: errorMsg));
      if (ers == MiscErrorResult.retry) {
        await Helpers.sleep(1500);
        _checkBackendUserSession(uid);
      } else {
        // Cierra la aplicación
        if (Platform.isAndroid) SystemNavigator.pop();
      }
    } else {
      if (_existsUidEnBackend) {
        setBackendUser(respBU!.data);
        _startAuthChangeListeners();
      } else {
        _startAuthChangeListeners();
      }
    }
  }

  // Se inicia en SplashController
  void _startAuthChangeListeners() async {
    print('_startAuthChangeListeners');
    await Future.delayed(Duration(milliseconds: 600));
    //run every time auth state changes
    // ever(firebaseUser, handleAuthChanged);
    // Por alguna razón se estaba ejecutando dos veces
    debounce(firebaseUser, _handleAuthChanged,
        time: Duration(milliseconds: 500));
    firebaseUser.value = getUser;
    firebaseUser.bindStream(user);
    super.onReady();
  }

  Future<void> _handleAuthChanged(_firebaseUser) async {
    if (_listenAuthChanges) {
      Helpers.logger.d('Validating session...');
      if (_firebaseUser is User) {
        if (_backendUser is ClienteDto) {
          Helpers.logger.i('Loggin Ok!');

          await Get.delete<InitialController>();
          final con = Get.put(InitialController());

          con.firstLogic();
          return;
        } else {
          Helpers.logger.w('Loggin Incomplete!');
          _auth.signOut();
        }
      } else {
        Helpers.logger.d('No session!');
        _redirectWhenUserNotLogged();
      }
    }
  }

  void _redirectWhenUserNotLogged() {
    Get.offAllNamed(AppRoutes.INTRO);
  }

  Future<void> logout() async {
    setBackendUser(null);
    Helpers.logger.i("GET USER");
    Helpers.logger.i(getUser);
    if (getUser != null) {
      setListenAuthChanges(true);
      await _auth.signOut();
    } else {
      setListenAuthChanges(true);
      _redirectWhenUserNotLogged();
    }
  }

  Future<void> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    UserCredential userCredential =
        await auth.signInWithEmailAndPassword(email: email, password: password);

    String? idToken = await userCredential.user!.getIdToken();
    LoginResponse token = await _loginProvider.getToken(idToken!, "pasajero");
    Constants.TOKEN = token.token;
    await _getxStorage.save('token', token.token);

    var justSavedUserData = await _getxStorage.read('token');
    print('este es el token definitivo : $justSavedUserData');
    //_dioClient.initializeToken(token.token);

    //_dioClient.initializeToken(token.token);
    Helpers.logger.i('-----ID TOKEN-------');
    Helpers.logger.i(token.token);
    //return userCredential;
  }
}
