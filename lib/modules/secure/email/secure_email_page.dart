import 'package:app_pasajero_ns/modules/app_prefs/app_prefs_controller.dart';
import 'package:app_pasajero_ns/modules/secure/email/secure_email_controller.dart';
import 'package:app_pasajero_ns/themes/ak_ui.dart';
import 'package:app_pasajero_ns/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SecureEmailPage extends StatelessWidget {
  final SecureEmailController _conX;
  final _appX = Get.find<AppPrefsController>();

  SecureEmailPage(this._conX);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => await _conX.handleBack(),
      child: Scaffold(
        body: Stack(
          children: [
            SliverContainer<SecureEmailController>(
              gbAppbarId: _conX.gbAppbar,
              scrollController: _conX.scrollController,
              type: _appX.type,
              title: 'Email',
              subtitle: 'Para registrarte, ingresa tu email',
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
          AkText('Los usarás para iniciar sesión y restablecer tu contraseña.',
              style: TextStyle(color: akTextColor.withOpacity(.75))),
          SizedBox(height: 20),
          Obx(() => AkInput(
                enabledBorderColor: !_conX.errorFirebase.value
                    ? akIptOutlinedBorderColor
                    : akErrorColor,
                controller: _conX.emailCtlr,
                focusNode: _conX.emailFocusNode,
                filledColor: Colors.transparent,
                type: AkInputType.underline,
                hintText: 'nombre@ejemplo.com',
                maxLength: 45,
                validator: _conX.validateEmail,
                labelColor: akTextColor.withOpacity(0.35),
                onSaved: (text) => _conX.email = text!.trim(),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => _conX.onNextClicked(),
              )),
          Obx(() => _conX.errorFirebase.value
              ? Container(
                  margin: EdgeInsets.only(top: 0.0, left: 10.0),
                  child: AkText(
                    _conX.errorFirebaseMsg,
                    style:
                        TextStyle(color: akRedColor, fontSize: akFontSize - 1),
                  ),
                )
              : SizedBox()),
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: EdgeInsets.all(akContentPadding),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          AkButton(
            onPressed: _conX.onNextClicked,
            text: 'Siguiente',
            fluid: true,
            enableMargin: false,
          ),
        ],
      ),
    );
  }
}

class MailSentWidget extends StatelessWidget {
  final void Function() onAcceptTap;
  final void Function() onResendTap;

  MailSentWidget({
    required this.onAcceptTap,
    required this.onResendTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(akCardBorderRadius * 1.5),
            topRight: Radius.circular(akCardBorderRadius * 1.5),
          )),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.all(akContentPadding),
            child: Column(
              children: [
                SizedBox(height: 20.0),
                SvgPicture.asset(
                  'assets/icons/mail_inbox.svg',
                  width: Get.width * 0.20,
                ),
                SizedBox(height: 25.0),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: akContentPadding * 0.5),
                  child: AkText(
                    'Verificación necesaria',
                    type: AkTextType.h6,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(height: 15.0),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: akContentPadding * 2),
                  child: AkText(
                      'Antes de continuar debes verificar tu cuenta. Revisa en tu bandeja de entrada el correo que te hemos enviado.',
                      type: AkTextType.body1,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: akTextColor.withOpacity(.65))),
                ),
                SizedBox(height: 30.0),
                Row(
                  children: [
                    Expanded(
                      child: AkButton(
                        type: AkButtonType.outline,
                        elevation: 0.0,
                        onPressed: this.onResendTap,
                        text: 'Reenviar',
                        fluid: true,
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Expanded(
                      child: AkButton(
                        onPressed: this.onAcceptTap,
                        text: 'Aceptar',
                        fluid: true,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
              ],
            ),
          )
        ],
      ),
    );
  }
}
