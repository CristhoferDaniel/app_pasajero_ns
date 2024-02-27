import 'dart:convert';

import 'package:app_pasajero_ns/data/models/cliente.dart';
import 'package:app_pasajero_ns/data/models/repositorio.dart';
import 'package:app_pasajero_ns/data/providers/cliente_provider.dart';
import 'package:app_pasajero_ns/data/providers/repositorio_provider.dart';
import 'package:app_pasajero_ns/modules/auth/auth_controller.dart';
import 'package:app_pasajero_ns/modules/misc/error/misc_error_controller.dart';
import 'package:app_pasajero_ns/modules/secure/password/secure_password_controller.dart';
import 'package:app_pasajero_ns/modules/secure/password/secure_password_page.dart';
import 'package:app_pasajero_ns/routes/app_pages.dart';
import 'package:app_pasajero_ns/utils/utils.dart';
import 'package:app_pasajero_ns/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class PerfilDatosController extends GetxController {
  late PerfilDatosController _self;
  late ScrollController scrollController;

  final _authX = Get.find<AuthController>();

  final _repositorioProvider = RepositorioProvider();
  final _clienteProvider = ClienteProvider();

  final loading = false.obs;

  final gbAppbar = 'gbAppbar';
  final gbPhoto = 'gbPhoto';

  @override
  void onInit() {
    super.onInit();
    this._self = this;

    scrollController = ScrollController()
      ..addListener(() {
        update([gbAppbar]);
      });
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  late PickedFile? imageFile;

  Future<XFile?> getImage(int type) async {
    // Utiliza XFile en lugar de PickedFile
    XFile? pickedImage = await ImagePicker().pickImage(
      source: type == 1 ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 50,
    );
    return pickedImage;
  }

  void onUserSelectUploadPhoto({required int mode}) async {
    imageFile = (await getImage(mode)) as PickedFile?;
    if (imageFile != null) {
      List<int> imageBytes = await imageFile!.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      _uploadProfilePhoto(base64Image);
    }
  }

  Future<void> _uploadProfilePhoto(String base64Image) async {
    String? errorMsg;
    RepositorioResponse? resp;
    try {
      loading.value = true;
      resp = await _repositorioProvider.sendFileBase64(
        fileName: 'photo_pasajero_${_authX.backendUser?.idCliente}.png',
        base64: base64Image,
      );
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
        _uploadProfilePhoto(base64Image);
      } else {
        loading.value = false;
      }
    } else {
      _updateProfilePasajero(resp!.url);
    }
  }

  Future<void> _updateProfilePasajero(String photoUrl) async {
    String? errorMsg;
    ClienteDto? _updatedUser;
    try {
      loading.value = true;
      final _oldUser = _authX.backendUser;
      _updatedUser = _oldUser!.copyWith(foto: photoUrl);
      await _clienteProvider.update(_updatedUser.idCliente, _updatedUser);
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
        _updateProfilePasajero(photoUrl);
      } else {
        loading.value = false;
      }
    } else {
      loading.value = false;
      // Actualiza el backendUser de Auth
      _authX.setBackendUser(_updatedUser!);
      _authX.userPhotoVersion++;
      update([gbPhoto]);

      AppSnackbar().success(message: 'Foto actualizada');
    }
  }

  Future<void> onEmailChangeTap() async {
    Get.toNamed(AppRoutes.PERFIL_EMAIL_DETAILS);
  }

  Future<void> onButtonPasswordChangeTap() async {
    await Get.delete<SecurePasswordController>();
    final _passX = Get.put(SecurePasswordController(
        isEditMode: true,
        firebaseAuthType: FirebaseAuthType.create,
        email: _authX.getUser!.email ?? '',
        parentLoading: loading,
        onLoginOrCreateTap: _updateFirebasePassword,
        onBackCall: () {
          Get.back();
        }));
    await Get.to(
      () => SecurePasswordPage(_passX),
      transition: Transition.cupertino,
    );
    await Get.delete<SecurePasswordController>();
  }

  Future<void> _updateFirebasePassword(
    FirebaseAuthType firebaseAuthType,
    String email,
    String password,
    String currentPassword,
  ) async {
    loading.value = true;

    String? errorMsg;
    try {
      await _authX.getUser!.reauthenticateWithCredential(
        EmailAuthProvider.credential(
            email: _authX.getUser!.email!, password: currentPassword),
      );
      await _authX.getUser!.updatePassword(password);
    } on FirebaseException catch (e) {
      if (e.code == 'wrong-password') {
        AppSnackbar().error(message: 'La contraseña actual no es correcta');
        loading.value = false;
        return; // Importante. No Quitar
      }
      errorMsg = AppIntl.getFirebaseErrorMessage(e.code);
      Helpers.logger.e(e.code);
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
        _updateFirebasePassword(
            firebaseAuthType, email, password, currentPassword);
      } else {
        loading.value = false;
      }
    } else {
      loading.value = false;
      Get.back();
      AppSnackbar().success(message: 'Contraseña actualizada');
    }
  }

  Future<bool> handleBack() async {
    if (loading.value) return false;
    Get.focusScope?.unfocus();
    return true;
  }
}
