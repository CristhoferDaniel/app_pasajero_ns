import 'package:app_pasajero_ns/modules/app_prefs/app_prefs_controller.dart';
import 'package:app_pasajero_ns/modules/secure/phone/secure_phone_controller.dart';
import 'package:app_pasajero_ns/themes/ak_ui.dart';
import 'package:app_pasajero_ns/widgets/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class SecurePhonePage extends StatelessWidget {
  final SecurePhoneController _conX;
  final _appX = Get.find<AppPrefsController>();

  SecurePhonePage(this._conX);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => await _conX.handleBack(),
      child: Scaffold(
        body: Stack(
          children: [
            SliverContainer<SecurePhoneController>(
              gbAppbarId: _conX.gbAppbar,
              scrollController: _conX.scrollController,
              type: _appX.type,
              title: 'Comencemos',
              subtitle: 'Ingresa tu número de celular',
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10.0),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: 7.0),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _conX.goToCountrySelectPage,
                  child: Container(
                    padding: EdgeInsets.all(5.0),
                    child: GetBuilder<SecurePhoneController>(
                        id: _conX.gbDial,
                        builder: (_) {
                          final flag = SvgPicture.asset(
                              'assets/flags/${_conX.countrySelected.toLowerCase()}.svg');
                          return Row(
                            children: [
                              Container(
                                width: 30,
                                height: 30,
                                child: flag,
                              ),
                              Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: 20.0,
                                color: akTextColor.withOpacity(0.5),
                              ),
                              SizedBox(width: 5.0),
                              AkText(_conX.dialSelected),
                            ],
                          );
                        }),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Form(
                key: _conX.formKey,
                child: AkInput(
                  enableClean: false,
                  filledColor: Colors.transparent,
                  type: AkInputType.underline,
                  hintText: '999 999 999',
                  inputFormatters: [
                    MaskTextInputFormatter(mask: "### ### ###")
                  ],
                  keyboardType: TextInputType.number,
                  validator: _conX.validatePhoneFormat,
                  maxLength: 11,
                  labelColor: akTextColor.withOpacity(0.35),
                  onSaved: (text) =>
                      _conX.phoneNumber = text!.trim().replaceAll(' ', ''),
                  onFieldSubmitted: (text) => _conX.onNextPressed(),
                  textInputAction: TextInputAction.done,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: EdgeInsets.all(akContentPadding),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          _buildTerms(),
          SizedBox(height: 20),
          Obx(
            () {
              bool enabled = _conX.sendEnabledSMS.value;
              return AbsorbPointer(
                absorbing: !enabled,
                child: AkButton(
                  backgroundColor:
                      enabled ? akPrimaryColor : akGreyColor.withOpacity(0.25),
                  textColor: enabled ? akWhiteColor : akTextColor,
                  elevation: enabled ? null : 0,
                  enableMargin: false,
                  fluid: true,
                  onPressed: _conX.onNextPressed,
                  text: enabled
                      ? 'Siguiente'
                      : 'Esperar 00:${_conX.secondsTimer.value < 10 ? '0' + _conX.secondsTimer.value.toString() : _conX.secondsTimer.value.toString()}',
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTerms() {
    TextStyle _dfStyle = TextStyle(
        color: akTextColor,
        fontFamily: akDefaultFontFamily,
        fontSize: akFontSize - 1);

    return RichText(
      text: TextSpan(children: [
        TextSpan(
            text: 'Continúa para recibir un código SMS y aceptar la ',
            style: _dfStyle),
        TextSpan(
            text: 'Política de privacidad',
            style: _dfStyle.copyWith(
                fontWeight: FontWeight.w500, color: akSecondaryColor),
            recognizer: TapGestureRecognizer()
              ..onTap = _conX.goTerminosCondicionesPage),
        TextSpan(text: '.', style: _dfStyle),
      ]),
    );
  }
}
