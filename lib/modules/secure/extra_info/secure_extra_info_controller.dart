import 'package:app_pasajero_ns/data/models/cliente.dart';
import 'package:app_pasajero_ns/data/models/tipo_doc.dart';
import 'package:app_pasajero_ns/data/providers/tipo_doc_provider.dart';
import 'package:app_pasajero_ns/modules/misc/error/misc_error_controller.dart';
import 'package:app_pasajero_ns/modules/secure/login_flow/login_flow_controller.dart';
import 'package:app_pasajero_ns/modules/secure/widgets/modal_reset_flow.dart';
import 'package:app_pasajero_ns/modules/terminos/terminos_condiciones_controller.dart';
import 'package:app_pasajero_ns/routes/app_pages.dart';
import 'package:app_pasajero_ns/utils/utils.dart';
import 'package:app_pasajero_ns/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../data/models/buscar_documento.dart';
import '../../../data/providers/cliente_provider.dart';

class SecureExtraInfoController extends GetxController {
  SecureExtraInfoController({
    required this.parentLoading,
    required this.onFormCompleted,
    required this.onBackCall,
    required this.onCancelRetry,
    required this.dialSelected,
    required this.phoneNumber,
    required this.uid,
    required this.email,
  });

  late ScrollController scrollController;
  final gbAppbar = 'gbAppbar';

  final RxBool parentLoading;
  final void Function({
    required UserBackendFlowType flowType,
    required ClienteDto dto,
  }) onFormCompleted;
  final void Function() onBackCall;
  final void Function() onCancelRetry;
  final String dialSelected;
  final String phoneNumber;
  final String uid;
  final String email;

  late SecureExtraInfoController _self;

  final _tipoDocProvider = TipoDocProvider();
  final tipoDocCtlr = TextEditingController();
  final _clienteProvider = ClienteProvider();
  // final _keyX = Get.find<KeyboardController>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final nombre = TextEditingController();
  final apellido = TextEditingController();
  TipoDoc? tipoDocSelected;
  String docIdentidad = '';

  final agreeTerms = false.obs;

  final loading = false.obs;

  List<TipoDoc> _tiposDoc = [];
  List get tiposDoc => this._tiposDoc;

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

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  Future<void> _init() async {
    await _loadTiposDoc();
  }

  Future<void> _loadTiposDoc() async {
    String? errorMsg;
    try {
      loading.value = true;
      this._tiposDoc = [];
      final res = await _tipoDocProvider.getAll(limit: 999, page: 1);
      this._tiposDoc = res.content;
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
        _loadTiposDoc();
      } else {
        loading.value = false;
        onCancelRetry.call();
      }
    } else {
      loading.value = false;
    }
  }

  void onNextClicked() async {
    if (loading.value) return; // No eliminar
    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState?.save();
      Get.focusScope?.unfocus();

      if (agreeTerms.value) {
        _emitValidEvent();
      } else {
        AppSnackbar().warning(
            message: 'Debe aceptar los términos y condiciones para continuar');
      }
    }
  }

  Future<void> _emitValidEvent() async {
    this.onFormCompleted.call(
          flowType: UserBackendFlowType.create,
          dto: ClienteDto(
            idCliente: 0,
            nombres: nombre.text,
            apellidos: apellido.text,
            numeroDocumento: docIdentidad,
            idTipoDocumento: tipoDocSelected!.idTipoDocumento,
            uid: uid,
            celular: dialSelected + phoneNumber,
            fechaValidacionCelular: DateTime.now(),
            correo: email,
          ),
        );
  }

  Future<void> onCheckTermsTap() async {
    await _closeKeyboardIfOpen();

    agreeTerms.value = !agreeTerms.value;
  }

  Future<void> onTermsLabelTap() async {
    await _closeKeyboardIfOpen();

    final result = await Get.toNamed(AppRoutes.TERMINOS_CONDICIONES,
        arguments:
            TerminosCondicionesControllerArguments(showActionButtons: true));
    if (result == true) {
      agreeTerms.value = true;
    } else if (result == false) {
      agreeTerms.value = false;
    }
  }

  Future<void> _closeKeyboardIfOpen() async {
    Get.focusScope?.unfocus();
    /* if (_keyX.keyboardUtils.isKeyboardOpen) {
      Get.focusScope?.unfocus();
      await Helpers.sleep(300);
    } */
  }

  Future<bool> handleBack() async {
    if (loading.value) return false;

    Get.focusScope?.unfocus();
    final confirmResetFlow = await _showConfirmResetFlow();
    if (confirmResetFlow) {
      onBackCall.call();
    }
    return false;
  }

  Future<bool> _showConfirmResetFlow() async {
    if (Get.overlayContext == null) return false;

    final resp = await showMaterialModalBottomSheet<bool?>(
      context: Get.overlayContext!,
      duration: Duration(milliseconds: 300),
      backgroundColor: Colors.transparent,
      builder: (context) => ModalResetFlow(
        onYesTap: () => Get.back(result: true),
        onNoTap: () => Get.back(result: false),
      ),
    );
    return resp ?? false;
  }

  // Setters
  void setTipoDocSelected(TipoDoc tipoDoc) {
    tipoDocCtlr.text = tipoDoc.nombre;
    tipoDocSelected = tipoDoc;
  }

  // Validators
  String? validateNameAndLastName(String? text) {
    if (text != null && text.trim().length >= 2) {
      return null;
    }
    return 'Requerido';
  }

  String? validateTipoDoc(String? text) {
    if (tipoDocSelected != null) {
      return null;
    }
    return 'Requerido';
  }

  String? validateNumeroDoc(String? text) {
    if (text != null && text.trim().length >= 8) {
      return null;
    }

    return 'Documento no válido';
  }

  Future<void> buscarPersona(String dni) async {
    if (dni.trim().length == 8) {
      DocumentoListResponse data = await _clienteProvider.findDocument(dni.trim());
      Helpers.logger.i("VALIDADO");
      if (data.data[0].dni != "") {
        Helpers.logger.i(data.toJson().toString());
        var persona = data.data[0];
        apellido.text = persona.apellidoPaterno + " " + persona.apellidoMaterno;
        nombre.text = persona.nombres;
      }
    }
  }
}

class SecureBackendUserArguments {
  final String phone;
  final String email;

  SecureBackendUserArguments({required this.phone, required this.email});
}
