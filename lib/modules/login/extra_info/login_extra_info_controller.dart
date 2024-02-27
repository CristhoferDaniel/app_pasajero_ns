import 'package:app_pasajero_ns/data/providers/cliente_provider.dart';
import 'package:app_pasajero_ns/modules/auth/auth_controller.dart';
import 'package:app_pasajero_ns/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginExtraInfoController extends GetxController {
  final _authX = Get.find<AuthController>();

  final _clienteProvider = ClienteProvider();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String nombre = '';
  String apellido = '';

  final loading = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  void onNextClicked() async {
    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState?.save();
      Get.focusScope?.unfocus();
      await Future.delayed(Duration(milliseconds: 300));
      _createUserBackend();
    }
  }

  Future<void> _createUserBackend() async {
    if (_authX.getUser == null) return;
    if (_authX.getUser!.phoneNumber == null) return;
    if (_authX.getUser!.email == null) return;

    // Busca en el backend si existe una cuenta asociada a ese UID
    bool? existsBackendUser;
    try {
      loading.value = true;
      final resp = await _clienteProvider.searchByUid(_authX.getUser!.uid);
      if (resp.success) {
        existsBackendUser = true;
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
      Helpers.showError('¡Opps! Parece que hubo un problema.',
          devError: e.toString());
    } finally {
      loading.value = false;
    }

    if (existsBackendUser == null) return;

    // ClienteCreate? backendUserFound;
    if (!existsBackendUser) {
      try {
        loading.value = true;
        /* final newUserBck = backendUserFound = ClienteCreate(
            idCliente: 0,
            nombres: nombre,
            apellidos: apellido,
            numeroDocumento: '',
            idTipoDocumento: 4,
            uid: _authX.getUser!.uid, // _uid,
            celular: _authX.getUser!.phoneNumber!,
            correo: _authX.getUser!.email!); */
        // final result = await _clienteProvider.create(newUserBck);
        /* if (result.success) {
          /// backendUserFound = result.data;
        } */
      } on ApiException catch (e) {
        String errormsg = AppIntl.getFirebaseErrorMessage(e.message);
        Helpers.showError(errormsg);
      } catch (e) {
        Helpers.showError('¡Opps! Parece que hubo un problema.',
            devError: e.toString());
      } finally {
        loading.value = false;
      }
    }

    // En este punto existe un usuario en Backend
    if (_authX.getUser == null) return;
    // if (backendUserFound == null) return;

    /* _authX.setBackendUser(backendUserFound);
    _authX.setListenAuthChanges(true);
    _authX.firebaseUser.value = _authX.getUser!; */
  }

  // Validators
  String? validateNameAndLastName(String? text) {
    if (text != null && text.trim().length >= 3) {
      return null;
    }
    return 'Requerido';
  }
}
