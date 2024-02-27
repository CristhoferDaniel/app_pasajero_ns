import 'package:app_pasajero_ns/data/models/cliente.dart';
import 'package:app_pasajero_ns/data/models/conductor.dart';
import 'package:app_pasajero_ns/data/models/firebase_user_info.dart';
import 'package:app_pasajero_ns/data/providers/auth_provider.dart';
import 'package:app_pasajero_ns/data/providers/cliente_provider.dart';
import 'package:app_pasajero_ns/data/providers/conductor_provider.dart';
import 'package:app_pasajero_ns/modules/auth/auth_controller.dart';
import 'package:app_pasajero_ns/modules/misc/error/misc_error_controller.dart';
import 'package:app_pasajero_ns/modules/secure/email/secure_email_controller.dart';
import 'package:app_pasajero_ns/modules/secure/email/secure_email_page.dart';
import 'package:app_pasajero_ns/modules/secure/extra_info/secure_extra_info_controller.dart';
import 'package:app_pasajero_ns/modules/secure/extra_info/secure_extra_info_page.dart';
import 'package:app_pasajero_ns/modules/secure/password/secure_password_controller.dart';
import 'package:app_pasajero_ns/modules/secure/password/secure_password_page.dart';
import 'package:app_pasajero_ns/modules/secure/phone/secure_phone_controller.dart';
import 'package:app_pasajero_ns/modules/secure/phone/secure_phone_page.dart';
import 'package:app_pasajero_ns/routes/app_pages.dart';
import 'package:app_pasajero_ns/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class LoginFlowController extends GetxController {
  late LoginFlowController _self;
  final _authX = Get.find<AuthController>();

  final _authProvider = AuthProvider();
  final _conductorProvider = ConductorProvider();
  final _clienteProvider = ClienteProvider();

  String dialSelected = '';
  String phoneNumber = '';

  final loading = false.obs;

  @override
  void onInit() {
    super.onInit();
    this._self = this;

    _authX.setListenAuthChanges(false);
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> startFlow() async {
    // Solicita celular
    await Get.delete<SecurePhoneController>();
    final _phoneX = Get.put(
      SecurePhoneController(
        enableBack: true,
        parentLoading: loading,
        onValidatedOTP: callbackOnValidOTP,
      ),
    );
    await Get.to(
      () => SecurePhonePage(_phoneX),
      transition: Transition.cupertino,
    );
    await Get.delete<SecurePhoneController>();
  }

  Future<void> callbackOnValidOTP(String dial, String phone) async {
    dialSelected = dial;
    phoneNumber = phone;
    _searchPhoneInBackend(dial, phone);
  }

  Future<bool?> _searchPhoneInBackend(String dial, String phone) async {
    String? errorMsg;

    String uidFound = '';
    bool conductorFound = false;
    bool clienteFound = false;

    loading.value = true;
    try {
      Helpers.logger.i(dial + phone);

      final respUid = await _clienteProvider
          .searchByPhoneNumber('RDnpOLT3xKPAtUJfEm2UpSaWW762');

      Helpers.logger.i(respUid);

      // Cambiar el orden de la búsqueda según el tipo de App
      final respClientes =
          await _clienteProvider.searchByPhoneNumber(dial + phone);

      List<ClienteDto> clienteList = [...respClientes.content];
      // Ordena y revierte para ordenar del más actual al más antiguo
      clienteList.sort((a, b) =>
          a.fechaValidacionCelular.compareTo(b.fechaValidacionCelular));
      List<ClienteDto> clienteSortList = clienteList.reversed.toList();
      if (clienteSortList.isNotEmpty) {
        uidFound = clienteSortList.first.uid;
        clienteFound = true;
      } else {
        final respConductores =
            await _conductorProvider.searchByPhoneNumber(dial + phone);
        List<ConductorDto> conductorList = [...respConductores.content];
        // Ordena y revierte para ordenar del más actual al más antiguo
        conductorList.sort((a, b) =>
            a.fechaValidacionCelular.compareTo(b.fechaValidacionCelular));
        List<ConductorDto> conductorSortList = conductorList.reversed.toList();
        if (conductorSortList.isNotEmpty) {
          uidFound = conductorSortList.first.uid;
          conductorFound = true;
        }
      }
    } on ApiException catch (e) {
      errorMsg = e.message;
      Helpers.logger.e(e.message);
    } catch (e) {
      errorMsg = 'Ocurrió un error inesperado.';
      Helpers.logger.e(e.toString());
    }

    if (_self.isClosed) return false;
    if (errorMsg != null) {
      final ers = await Get.toNamed(AppRoutes.MISC_ERROR,
          arguments: MiscErrorArguments(content: errorMsg));
      if (ers == MiscErrorResult.retry) {
        await Helpers.sleep(1500);
        _searchPhoneInBackend(dial, phone);
      } else {
        loading.value = false;
        _resetFlow();
      }
    } else {
      loading.value = false;

      print('ConductorFound $conductorFound');
      print('ClienteFound $clienteFound');
      if (conductorFound || clienteFound) {
        _searchUIDinFirebase(uidFound);
      } else {
        _requestEmail();
      }
    }
  }

  Future<void> _searchUIDinFirebase(String uid) async {
    String? errorMsg;
    FirebaseUserInfo? resp;
    bool _existsUidInFirebase = false;
    try {
      loading.value = true;
      resp = await _authProvider.searchFirebaseUserByUid(uid);
      if (resp.email == null) {
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
        _searchUIDinFirebase(uid);
      } else {
        loading.value = false;
        _resetFlow();
      }
    } else {
      loading.value = false;

      if (_existsUidInFirebase) {
        _requestPassword(
          firebaseAuthType: FirebaseAuthType.login,
          email: resp!.email ?? '',
        );
      } else {
        _requestEmail();
      }
    }
  }

  Future<void> _requestEmail() async {
    await Get.delete<SecureEmailController>();
    final _emailX = Get.put(SecureEmailController(
      onEmailNextTap: (fbAuthType, email) {
        _requestPassword(
          firebaseAuthType: fbAuthType,
          email: email,
        );
      },
      parentLoading: loading,
      onBackCall: _resetFlow,
      onCancelRetry: _resetFlow,
    ));
    await Get.to(
      () => SecureEmailPage(_emailX),
      transition: Transition.cupertino,
    );
    await Get.delete<SecureEmailController>();
  }

  Future<void> _requestPassword({
    required FirebaseAuthType firebaseAuthType,
    String email = '',
  }) async {
    await Get.delete<SecurePasswordController>();
    final _passX = Get.put(SecurePasswordController(
        firebaseAuthType: firebaseAuthType,
        email: email,
        parentLoading: loading,
        onLoginOrCreateTap: _callbackLoginOrCreateInFirebase,
        onBackCall: _resetFlow));
    await Get.to(
      () => SecurePasswordPage(_passX),
      transition: Transition.cupertino,
    );
    await Get.delete<SecurePasswordController>();
  }

  Future<void> _callbackLoginOrCreateInFirebase(
    FirebaseAuthType firebaseAuthType,
    String email,
    String password,
    String currentPassword,
  ) async {
    String? errorMsg;
    try {
      loading.value = true;
      if (firebaseAuthType == FirebaseAuthType.create) {
        await _authX.auth
            .createUserWithEmailAndPassword(email: email, password: password);
      } else {
        await _authX
            .signInWithEmailPassword(email: email, password: password);
      }
    } on FirebaseAuthException catch (e) {
      loading.value = false;
      errorMsg = AppIntl.getFirebaseErrorMessage(e.code);
      Helpers.logger.e('Firebase Error: ${e.message ?? ''}');
      Helpers.showError(errorMsg, devError: e.code);
      return;
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
        _callbackLoginOrCreateInFirebase(
            firebaseAuthType, email, password, currentPassword);
      } else {
        loading.value = false;
        _resetFlow();
      }
    } else {
      loading.value = false;

      // En este punto ya se tiene el UID
      _searchUIDinBackend(_authX.getUser!.uid, email);
    }
  }

  Future<void> _searchUIDinBackend(String uid, String email) async {
    if (_authX.getUser == null) {
      Helpers.logger.e('Hubo un error en el proceso de registro. [516546]');
      return;
    }
    if (_authX.getUser!.email == null) {
      Helpers.logger.e('Hubo un error en el proceso de registro. [516547]');
      return;
    }

    String? errorMsg;
    ClienteCreateResponse? resp;
    bool _existsUidEnBackend = false;
    try {
      loading.value = true;
      // Cambiar esto según el tipo de APP
      resp = await _clienteProvider.searchByUid(uid);
      if (resp.success) {
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
        _searchUIDinBackend(_authX.getUser!.uid, email);
      } else {
        // En este punto mantenmos el loading, porque ya existe un UID
        _resetFlow();
      }
    } else {
      loading.value = false;

      if (_existsUidEnBackend) {
        _createOrUpdateUserBackend(
            flowType: UserBackendFlowType.update, dto: resp!.data);
      } else {
        _requestExtraInfo();
      }
    }
  }

  Future<void> _requestExtraInfo() async {
    await Get.delete<SecurePasswordController>();
    final _extraInfoX = Get.put(SecureExtraInfoController(
      parentLoading: loading,
      onFormCompleted: _createOrUpdateUserBackend,
      onBackCall: _resetFlow,
      onCancelRetry: _resetFlow,
      uid: _authX.getUser!.uid,
      dialSelected: dialSelected,
      phoneNumber: phoneNumber,
      email: _authX.getUser!.email!,
    ));
    await Get.to(
      () => SecureExtraInfoPage(_extraInfoX),
      transition: Transition.cupertino,
    );
    await Get.delete<SecurePasswordController>();
  }

  Future<void> _createOrUpdateUserBackend({
    required UserBackendFlowType flowType,
    required ClienteDto dto,
  }) async {
    if (_authX.getUser == null) {
      Helpers.showError('Hubo un error en el proceso de registro. [516546]');
      return;
    }
    if (_authX.getUser!.email == null) {
      Helpers.showError('Hubo un error en el proceso de registro. [516547]');
      return;
    }

    if (flowType == UserBackendFlowType.update && dto.idCliente == 0) {
      Helpers.showError(
          'Hubo un error actualizando los datos del pasajero. [516548]');
      return;
    }

    String? errorMsg;
    ClienteCreateResponse? result;
    try {
      loading.value = true;

      if (flowType == UserBackendFlowType.create) {
        result = await _clienteProvider.create(dto);
      } else {
        // Actualizamos la fechaValidacionCelular para usuarios
        // que volvieron a validar el celular.
        final _updatedDto =
            dto.copyWith(fechaValidacionCelular: DateTime.now());
        result =
            await _clienteProvider.update(_updatedDto.idCliente, _updatedDto);
      }
      if (!result.success) {
        throw BusinessException('No se pudo completar el registro.');
      }
    } on ApiException catch (e) {
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
        _createOrUpdateUserBackend(flowType: flowType, dto: dto);
      } else {
        // En este punto mantenmos el loading, porque ya existe un UID
        _resetFlow();
      }
    } else {
      loading.value = false;
      _assignSession(result!.data);
    }
  }

  Future<void> _assignSession(ClienteDto dto) async {
    loading.value = true;
    _authX.setBackendUser(dto);
    _authX.setListenAuthChanges(true);
    _authX.firebaseUser.value = _authX.getUser!;
    // Por motivos de UX, mantenemos el loading en true
    // para evitar que el usuario seleccione nuevamente el botón de siguiente
    // dado que hay un debouncer escuchando los cambios de firebaseUser
  }

  Future<void> _resetFlow() async {
    final _authLocalX = Get.find<AuthController>();
    await _authLocalX.logout();
  }
}

enum UserBackendFlowType { create, update }
