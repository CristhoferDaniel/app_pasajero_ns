import 'package:app_pasajero_ns/modules/auth/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashController extends GetxController with WidgetsBindingObserver {
  late BuildContext context;

  final _authX = Get.find<AuthController>();

  bool loading = true;
  bool showPermissionReason = false;
  bool fromSettingsPage = false;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance?.addObserver(this);

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _init();
    });
  }

  void setContext(BuildContext c) {
    context = c;
  }

  @override
  void onClose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed && fromSettingsPage) {
      fromSettingsPage = false;
      if (await Permission.location.isGranted) {
        onPermissionOk();
      }
    }
  }

  void _init() async {
    print('SplashController._init');
    // await _preloadImages();

    checkAppPermissions();
  }

  void onPermissionOk() async {
    showPermissionReason = false;
    update();
    print('Permissions granted!');

    _authX.initCheckSession();

    // TODO: BORRAR
    /* if (_authX.getUser == null) {
      _authX.initAuthFunctions();
      return;
    }

    Helpers.logger.wtf('Fetching firebase/backend user...');
    bool? existsEmailInFirebase;
    try {
      await _authProvider.searchFirebaseUserByUid(_authX.getUser!.uid);
      existsEmailInFirebase = true;
    } on ApiException catch (e) {
      if (e.dioError != null) {
        int statusCode = e.dioError?.response?.statusCode ?? 0;
        if (statusCode == 500) {
          String detailCode =
              e.dioError?.response?.data['details']['code'] as String;
          if (detailCode == 'auth/user-not-found') {
            existsEmailInFirebase = false;
          }
        }
      }
      if (existsEmailInFirebase == null) Helpers.showError(e.message);
    } catch (e) {
      Helpers.showError('No se pudo validar la sesión de usuario',
          devError: e.toString());
    }

    print('$existsEmailInFirebase');
    if (existsEmailInFirebase == null) return;

    if (!existsEmailInFirebase) {
      _authX.initAuthFunctions();
      return;
    }

    // Busca en el backend si existe una cuenta asociada a ese UID
    bool? existsBackendUser;
    ClienteCreate? backendUserFound;
    try {
      final resp = await _clienteProvider.searchByUid(_authX.getUser!.uid);
      if (resp.success) {
        existsBackendUser = true;
        backendUserFound = resp.data;
      }
    } on ApiException catch (e) {
      if (e.dioError != null) {
        int statusCode = e.dioError?.response?.statusCode ?? 0;
        if (statusCode == 404) {
          bool success = e.dioError?.response?.data['success'] as bool;
          if (success == false) {
            existsBackendUser = false;
          }
        }
      }
      if (existsBackendUser == null) Helpers.showError(e.message);
    } catch (e) {
      Helpers.showError('No se pudo validar los datos de usuario',
          devError: e.toString());
    }

    if (existsBackendUser == null) return;
    if (!existsBackendUser) {
      _authX.initAuthFunctions();
      return;
    }

    if (backendUserFound == null) return;
    _authX.setBackendUser(backendUserFound);
    _authX.initAuthFunctions(); */
  }

  Future checkAppPermissions() async {
    bool permissionLocation = await Permission.location.isGranted;

    PermissionStatus? plocationStatus;
    if (!permissionLocation) {
      plocationStatus = await Permission.location.request();
    }

    bool permissionPhone = await Permission.phone.isGranted;
    if (!permissionPhone) {
      await Permission.phone.request();
    }

    if (permissionLocation) {
      onPermissionOk();
    } else {
      handlePermissionLocationResponse(plocationStatus!);
    }
  }

  Future handlePermissionLocationResponse(PermissionStatus status) async {
    print(status);
    switch (status) {
      case PermissionStatus.granted:
        onPermissionOk();
        break;
      case PermissionStatus.limited:
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.permanentlyDenied:
        showPermissionReason = true;
        update();
        break;
      case PermissionStatus.provisional:
      // TODO: Handle this case.
    }
  }

  void requestPermissionAgain() async {
    PermissionStatus _ps = await Permission.location.request();
    switch (_ps) {
      case PermissionStatus.granted:
        onPermissionOk();
        break;
      case PermissionStatus.denied:
        break;
      case PermissionStatus.limited:
      case PermissionStatus.restricted:
      case PermissionStatus.permanentlyDenied:
        if (await openAppSettings()) {
          fromSettingsPage = true;
        }
        break;
      case PermissionStatus.provisional:
      // TODO: Handle this case.
    }
  }
}
