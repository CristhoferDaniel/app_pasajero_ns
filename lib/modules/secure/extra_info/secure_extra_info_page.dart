import 'package:app_pasajero_ns/data/models/tipo_doc.dart';
import 'package:app_pasajero_ns/modules/app_prefs/app_prefs_controller.dart';
import 'package:app_pasajero_ns/modules/secure/extra_info/secure_extra_info_controller.dart';
import 'package:app_pasajero_ns/themes/ak_ui.dart';
import 'package:app_pasajero_ns/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class SecureExtraInfoPage extends StatelessWidget {
  final SecureExtraInfoController _conX;
  final _appX = Get.find<AppPrefsController>();

  SecureExtraInfoPage(this._conX);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => await _conX.handleBack(),
      child: Scaffold(
        body: Stack(
          children: [
            SliverContainer<SecureExtraInfoController>(
              gbAppbarId: _conX.gbAppbar,
              scrollController: _conX.scrollController,
              type: _appX.type,
              title: 'Datos personales',
              expandedHeight: 150,
              subtitle:
                  'Para finalizar el registro, necesitamos unos cuantos datos',
              onBack: () async {
                if (await _conX.handleBack()) Get.back();
              },
              children: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    children: [
                      Expanded(
                        child: Content(
                          child: Column(
                            children: [
                              _buildForm(),
                            ],
                          ),
                        ),
                      ),
                      _buildBottomActions(),
                    ],
                  ),
                ),
              ],
            ),
            Obx(() => LoadingOverlay(_conX.loading.value)),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _conX.formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: akContentPadding),
          Row(
            children: [
              Expanded(
                child: _inputTipoDoc(),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: _inputNumeroDoc(),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: _inputNombre(),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: _inputApellido(),
              ),
            ],
          ),
          SizedBox(height: 15),
          Row(
            children: [
              GestureDetector(
                onTap: _conX.onCheckTermsTap,
                child: Container(
                  padding: EdgeInsets.all(akContentPadding * 0.5),
                  child: Obx(
                    () => CustomCheckbox(
                      isSelected: _conX.agreeTerms.value,
                      enabled: true,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.0),
              Flexible(
                child: GestureDetector(
                  onTap: _conX.onTermsLabelTap,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 7.0,
                    ),
                    child: AkText(
                      'Ver términos y condiciones',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: akTitleColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _inputNombre() {
    return AkInput(
      enableClean: false,
      maxLength: 45,
      filledColor: Colors.transparent,
      type: AkInputType.underline,
      textCapitalization: TextCapitalization.words,
      hintText: 'Nombre',
      controller: _conX.nombre,
      validator: _conX.validateNameAndLastName,
      labelColor: akTextColor.withOpacity(0.35),
      onSaved: (text) => _conX.nombre.text = text!.trim(),
    );
  }

  Widget _inputApellido() {
    return AkInput(
      enableClean: false,
      maxLength: 45,
      filledColor: Colors.transparent,
      type: AkInputType.underline,
      textCapitalization: TextCapitalization.words,
      hintText: 'Apellido',
      controller: _conX.apellido,
      validator: _conX.validateNameAndLastName,
      labelColor: akTextColor.withOpacity(0.35),
      onSaved: (text) => _conX.apellido.text = text!.trim(),
    );
  }

  Widget _inputTipoDoc() {
    return AkInput(
      controller: _conX.tipoDocCtlr,
      suffixIcon: Icon(Icons.unfold_more_rounded),
      enableClean: false,
      maxLength: 30,
      filledColor: Colors.transparent,
      type: AkInputType.underline,
      textCapitalization: TextCapitalization.words,
      hintText: 'Tipo documento',
      labelColor: akTextColor.withOpacity(0.35),
      readOnly: true,
      showCursor: false,
      validator: _conX.validateTipoDoc,
      onTap: () async {
        if (_conX.tiposDoc.length == 0) {
          AppSnackbar().info(message: 'No hay elementos que mostrar');
          return;
        }
        final resp = await _showOptions(_conX.tiposDoc);
        if (resp is TipoDoc) {
          _conX.setTipoDocSelected(resp);
        } else {
          print('No hubo selección: $resp');
        }
      },
    );
  }

  Widget _inputNumeroDoc() {
    return AkInput(
      enableClean: false,
      maxLength: 15,
      filledColor: Colors.transparent,
      type: AkInputType.underline,
      inputFormatters: [MaskTextInputFormatter(mask: "###############")],
      keyboardType: TextInputType.number,
      hintText: 'Doc. de identidad',
      validator: _conX.validateNumeroDoc,
      labelColor: akTextColor.withOpacity(0.35),
      onChanged: (value) => _conX.buscarPersona(value),
      onSaved: (text) => _conX.docIdentidad = text!.trim(),
    );
  }

  Future<dynamic> _showOptions(List<dynamic> items) async {
    List<Widget> options = [];
    for (var item in items) {
      String _text = '';
      if (item is TipoDoc) {
        _text = item.nombre;
      }
      options.add(Material(
        color: Colors.transparent,
        child: InkWell(
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          onTap: () => Get.back(result: item),
          highlightColor: Colors.transparent,
          splashColor: akPrimaryColor,
          child: ListTile(
            title: Row(
              children: [
                Expanded(
                  child: AkText('$_text'),
                ),
              ],
            ),
          ),
        ),
      ));
    }
    final ScrollController controller = ScrollController();

    final resp = await Get.dialog(
        AlertDialog(
          contentPadding: EdgeInsets.all(0.0),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          content: Container(
            width: 1000.0,
            constraints: BoxConstraints(minHeight: 10.0, maxHeight: 300.0),
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(akRadiusGeneral)),
            child: Theme(
              data: Theme.of(Get.context!).copyWith(
                highlightColor: akPrimaryColor,
              ),
              child: Scrollbar(
                radius: Radius.circular(30.0),
                thickness: 5.0,
                thumbVisibility: true,
                controller: controller,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  controller: controller,
                  physics: BouncingScrollPhysics(),
                  itemCount: options.length,
                  itemBuilder: (c, idx) {
                    return options[idx];
                  },
                ),
              ),
            ),
          ),
        ),
        barrierColor: Colors.black.withOpacity(0.35));
    return resp;
  }

  Widget _buildBottomActions() {
    return Container(
      padding: EdgeInsets.all(akContentPadding),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          AkButton(
            onPressed: _conX.onNextClicked,
            text: 'Registrarse',
            fluid: true,
            enableMargin: false,
          ),
        ],
      ),
    );
  }
}
