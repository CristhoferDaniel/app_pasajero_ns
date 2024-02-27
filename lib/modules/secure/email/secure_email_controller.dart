import 'package:app_pasajero_ns/data/models/firebase_user_info.dart';
import 'package:app_pasajero_ns/data/providers/auth_provider.dart';
import 'package:app_pasajero_ns/modules/misc/error/misc_error_controller.dart';
import 'package:app_pasajero_ns/modules/secure/password/secure_password_controller.dart';
import 'package:app_pasajero_ns/modules/secure/widgets/modal_email_used.dart';
import 'package:app_pasajero_ns/modules/secure/widgets/modal_reset_flow.dart';
import 'package:app_pasajero_ns/routes/app_pages.dart';
import 'package:app_pasajero_ns/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class SecureEmailController extends GetxController {
  SecureEmailController({
    required this.parentLoading,
    required this.onEmailNextTap,
    required this.onBackCall,
    required this.onCancelRetry,
    this.isEditMode = false,
  });

  late ScrollController scrollController;
  final gbAppbar = 'gbAppbar';

  final RxBool parentLoading;
  final void Function(FirebaseAuthType accessType, String email) onEmailNextTap;
  final void Function() onBackCall;
  final void Function() onCancelRetry;
  final bool isEditMode;

  late SecureEmailController _self;

  final _authProvider = AuthProvider();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailCtlr = TextEditingController();
  String email = '';
  FocusNode emailFocusNode = FocusNode();

  final loading = false.obs;

  final errorFirebase = false.obs;
  String errorFirebaseMsg = '';

  @override
  void onInit() {
    super.onInit();
    this._self = this;

    scrollController = ScrollController()
      ..addListener(() {
        update([gbAppbar]);
      });

    ever<bool>(parentLoading, (val) {
      this.loading.value = val;
    });

    _init();
  }

  void _init() async {
    emailCtlr.addListener(_onEmailFocus);

    await Future.delayed(Duration(milliseconds: 300));
    emailFocusNode.requestFocus();
  }

  @override
  void onClose() {
    scrollController.dispose();
    emailCtlr.removeListener(_onEmailFocus);
    super.onClose();
  }

  void _onEmailFocus() {
    if (errorFirebase.value) {
      errorFirebase.value = false;
    }
  }

  void onNextClicked() async {
    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState?.save();
      Get.focusScope?.unfocus();

      errorFirebase.value = false;
      errorFirebaseMsg = '';

      await Future.delayed(Duration(milliseconds: 300));
      _searchInFirebaseByEmail(email);
    }
  }

  Future<void> _searchInFirebaseByEmail(String emailtosearch) async {
    String? errorMsg;
    bool _existsEmailInFirebase = false;
    FirebaseUserInfo? fireUserInfo;
    loading.value = true;
    try {
      fireUserInfo = await _authProvider.searchFirebaseUserByEmail(email);
      loading.value = false;
      _existsEmailInFirebase = true;
    } on ApiException catch (e) {
      if (UtilsFunctions.isFirebaseUserNotFoundError(e)) {
        _existsEmailInFirebase = false;
      } else {
        errorMsg = e.message;
        Helpers.logger.e(e.message);
      }
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
        _searchInFirebaseByEmail(emailtosearch);
      } else {
        loading.value = false;
        onCancelRetry.call();
      }
    } else {
      loading.value = false;

      if (_existsEmailInFirebase) {
        _showConfirmUseAlreadyEmail(fireUserInfo?.email ?? '',
            fireUserInfo?.metadata.creationTime ?? '');
      } else {
        _onEmailCompleted(newMailFirebase: true);
      }
    }
  }

  void _showConfirmUseAlreadyEmail(String email, String dateCreated) async {
    if (Get.overlayContext == null) return;

    errorFirebase.value = false;
    errorFirebaseMsg = '';
    final resp = await showMaterialModalBottomSheet(
      context: Get.overlayContext!,
      backgroundColor: Colors.transparent,
      builder: (context) => ModalEmailUsed(
        email: email,
        dateCreated: dateCreated,
        onYesTap: () => Get.back(result: true),
        onNoTap: () => Get.back(result: false),
      ),
    );

    if (resp is bool) {
      if (resp) {
        _onEmailCompleted();
      } else {
        errorFirebase.value = true;
        errorFirebaseMsg = _emailLinkedOtherAccount;
      }
    } else {
      errorFirebase.value = true;
      errorFirebaseMsg = _emailLinkedOtherAccount;
    }
  }

  Future<void> _onEmailCompleted({bool newMailFirebase = false}) async {
    this.onEmailNextTap.call(
          newMailFirebase ? FirebaseAuthType.create : FirebaseAuthType.login,
          email.trim(),
        );
  }

  Future<bool> handleBack() async {
    if (loading.value) return false;

    Get.focusScope?.unfocus();

    if (isEditMode) {
      onBackCall.call();
    } else {
      final confirmResetFlow = await _showConfirmResetFlow();
      if (confirmResetFlow) {
        onBackCall.call();
      }
    }
    return false;
  }

  Future<bool> _showConfirmResetFlow() async {
    if (Get.overlayContext == null) return false;

    final resp = await showMaterialModalBottomSheet<bool?>(
      context: Get.overlayContext!,
      backgroundColor: Colors.transparent,
      builder: (context) => ModalResetFlow(
        onYesTap: () => Get.back(result: true),
        onNoTap: () => Get.back(result: false),
      ),
    );
    return resp ?? false;
  }

  // Validators
  String? validateEmail(String? text) {
    if (text != null && text.trim().isEmail) {
      return null;
    }
    return 'Email no válido';
  }

  String get _emailLinkedOtherAccount =>
      'Este email está vinculado a otra cuenta. Ingresa uno diferente para ' +
      (isEditMode ? 'actualizar tu cuenta' : 'crear una cuenta nueva.');
}
