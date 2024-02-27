import 'package:animate_do/animate_do.dart';
import 'package:app_pasajero_ns/modules/app_prefs/app_prefs_controller.dart';
import 'package:app_pasajero_ns/modules/secure/phone/secure_otp_controller.dart';
import 'package:app_pasajero_ns/themes/ak_ui.dart';
import 'package:app_pasajero_ns/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class SecureOtpPage extends StatelessWidget {
  final SecureOtpController _conX;
  final _appX = Get.find<AppPrefsController>();

  SecureOtpPage(this._conX);

  final _dfTextStyle = TextStyle(
    color: akTextColor,
    fontSize: akFontSize,
    fontFamily: akDefaultFontFamily,
  );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => await _conX.handleBack(),
      child: Scaffold(
        body: Stack(
          children: [
            SliverContainer<SecureOtpController>(
              gbAppbarId: _conX.gbAppbar,
              scrollController: _conX.scrollController,
              type: _appX.type,
              title: 'Verificación',
              subtitle: 'Ingresa el código SMS',
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
                              _buildForm(context),
                              SizedBox(height: 10.0),
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

  Widget _buildForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: akContentPadding),
        RichText(
          text: TextSpan(children: [
            TextSpan(text: 'Lo hemos enviado al ', style: _dfTextStyle),
            TextSpan(
                text: '${_conX.dialSelected + _conX.phoneNumber}',
                style: _dfTextStyle.copyWith(fontWeight: FontWeight.w500)),
          ]),
        ),
        SizedBox(height: 20),
        _buildOtpFields(context),
        Obx(() => (_conX.errorOtpMsg.value?.isNotEmpty ?? false)
            ? Container(
                margin: EdgeInsets.only(top: 5.0, left: 0.0, bottom: 5.0),
                child: AkText(
                  _conX.errorOtpMsg.value ?? '',
                  style:
                      TextStyle(color: akErrorColor, fontSize: akFontSize - 1),
                ),
              )
            : SizedBox()),
        SizedBox(height: 12),
        Container(
          width: double.infinity,
          child: Row(
            children: [
              Flexible(
                child: Obx(
                  () => _conX.sendEnabledSMS.value
                      // ? FadeIn(
                      //     key: ValueKey('_vk811534'),
                      //     child: Container(
                      //       decoration: BoxDecoration(
                      //         color: Color(0xFFEEEEEE),
                      //         borderRadius: BorderRadius.circular(20.0),
                      //       ),
                      //       child: Material(
                      //         type: MaterialType.transparency,
                      //         child: InkWell(
                      //           borderRadius: BorderRadius.circular(20.0),
                      //           onTap: _conX.reSendSMS,
                      //           child: Container(
                      //             padding: EdgeInsets.symmetric(
                      //                 horizontal: 14.0, vertical: 8.0),
                      //             child: RichText(
                      //               textAlign: TextAlign.start,
                      //               text: TextSpan(
                      //                 children: [
                      //                   TextSpan(
                      //                       text: 'Reenviar SMS',
                      //                       style: _dfTextStyle.copyWith(
                      //                         color: akPrimaryColor,
                      //                         fontWeight: FontWeight.w500,
                      //                       )),
                      //                 ],
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   )
                      ? FadeIn(
                          key: ValueKey('_vk811534'),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFEEEEEE),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Material(
                              type: MaterialType.transparency,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(20.0),
                                onTap: _conX.goEmailLoginForm,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 14.0, vertical: 8.0),
                                  child: RichText(
                                    textAlign: TextAlign.start,
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                            text:
                                                'Ingresar con email y contraseña',
                                            style: _dfTextStyle.copyWith(
                                              color: akPrimaryColor,
                                              fontWeight: FontWeight.w500,
                                            )),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      : FadeIn(
                          key: ValueKey('_vk651614'),
                          child: RichText(
                            textAlign: TextAlign.start,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                    text:
                                        'Podrás ingresar con email y contraseña en ',
                                    style: _dfTextStyle),
                                TextSpan(
                                    text: _conX.secondsTimer.value.toString(),
                                    style: _dfTextStyle.copyWith(
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOtpFields(BuildContext context) {
    return Form(
      key: _conX.formKey,
      child: PinCodeTextField(
        appContext: context,
        controller: _conX.fieldTxtCtlr,
        mainAxisAlignment: MainAxisAlignment.start,
        length: 6,
        animationType: AnimationType.fade,
        textStyle: TextStyle(
          fontWeight: FontWeight.w400,
          color: akTitleColor,
        ),
        autoFocus: true,
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.underline,
          borderRadius: BorderRadius.circular(1),
          fieldOuterPadding: EdgeInsets.only(right: 5.0),
          borderWidth: 2.0,
          fieldHeight: 42,
          fieldWidth: 37,
          inactiveFillColor: Color(0xFFEEEEEE),
          inactiveColor: Colors.transparent,
          selectedFillColor: Color(0xFFF6F6F6),
          selectedColor: Color(0xFF000000),
          activeFillColor: Color(0xFFEEEEEE),
          activeColor: Colors.transparent,
          errorBorderColor: akErrorColor,
        ),
        cursorColor: Colors.black,
        cursorHeight: 20.0,
        cursorWidth: 1.3,
        animationDuration: Duration(milliseconds: 300),
        enableActiveFill: true,
        errorAnimationController: _conX.errorController,
        keyboardType: TextInputType.number,
        onCompleted: (v) {
          _conX.onNext();
        },
        onChanged: _conX.validEnableNextButton,
        onTap: _conX.onTapField,
        beforeTextPaste: (text) => false,
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: EdgeInsets.all(akContentPadding),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Obx(() => AbsorbPointer(
                absorbing: !_conX.enableSubmit.value,
                child: AkButton(
                  elevation: 0,
                  backgroundColor: _conX.enableSubmit.value
                      ? akPrimaryColor
                      : akGreyColor.withOpacity(0.25),
                  enableMargin: false,
                  fluid: true,
                  onPressed: _conX.onNext,
                  textColor:
                      _conX.enableSubmit.value ? akWhiteColor : akTextColor,
                  text: 'Siguiente',
                ),
              )),
        ],
      ),
    );
  }
}
