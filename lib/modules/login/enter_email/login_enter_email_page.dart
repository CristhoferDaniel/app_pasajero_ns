import 'package:app_pasajero_ns/modules/login/enter_email/login_enter_email_controller.dart';
import 'package:app_pasajero_ns/themes/ak_ui.dart';
import 'package:app_pasajero_ns/utils/utils.dart';
import 'package:app_pasajero_ns/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class LoginEnterEmailPage extends StatelessWidget {
  final _conX = Get.put(LoginEnterEmailController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colorWave = Colors.white.withOpacity(0.3);

    return WillPopScope(
      onWillPop: () async {
        if (_conX.loading.value) return false;

        bool canPop = Navigator.of(context).canPop();
        if (canPop) {
          return true;
        } else {
          final exitAppConfirm = await Helpers.confirmCloseAppDialog();
          return exitAppConfirm;
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: akScaffoldBackgroundColor,
        body: Container(
          child: Stack(
            children: [
              Container(
                  color: akAccentColor,
                  height: size.height * 0.6,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 50.0,
                            color: colorWave,
                          ),
                          Container(
                            width: double.infinity,
                            child: AspectRatio(
                              aspectRatio: 4 / 1,
                              child: CustomPaint(
                                painter: CurvePainter2(
                                  color: colorWave,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
              Center(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      _buildCard(),
                    ],
                  ),
                ),
              ),
              _buildBackButton(),
              Obx(() => OverlayLoading(_conX.loading.value)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard() {
    return Stack(
      children: [
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            color: akScaffoldBackgroundColor,
            height: 275.0,
          ),
        ),
        Column(
          children: [
            SizedBox(height: 70),
            AkCard(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                width: double.infinity,
                child: Form(
                  key: _conX.formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AkText(
                        'Introduce tu email',
                        type: AkTextType.h9,
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 10),
                      AkText(
                          'Los usarás para iniciar sesión y restablecer tu contraseña.',
                          style:
                              TextStyle(color: akTextColor.withOpacity(.75))),
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
                                style: TextStyle(
                                    color: akRedColor,
                                    fontSize: akFontSize - 1),
                              ),
                            )
                          : SizedBox()),
                      SizedBox(height: 20),
                      AkButton(
                        onPressed: _conX.onNextClicked,
                        text: 'Siguiente',
                        fluid: true,
                        enableMargin: false,
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 70),
          ],
        ),
      ],
    );
  }

  Widget _buildBackButton() {
    return SafeArea(
      child: IconButton(
        icon: Icon(Icons.arrow_back_ios_rounded),
        onPressed: () async {
          Get.focusScope?.unfocus();
          await Helpers.sleep(300);
          Get.back();
        },
      ),
    );
  }
}

class EmailAlreadyWidget extends StatelessWidget {
  final String email;
  final String dateCreated;
  final void Function() onYesTap;
  final void Function() onNoTap;

  EmailAlreadyWidget({
    required this.email,
    required this.dateCreated,
    required this.onYesTap,
    required this.onNoTap,
  });

  @override
  Widget build(BuildContext context) {
    String day = '';
    String month = '';
    String year = '';

    String firstLetter = '';

    if (this.dateCreated.length > 0) {
      final splitted = this.dateCreated.split(' ');
      if (splitted.length > 3) {
        day = splitted[1];
        month = splitted[2];
        year = splitted[3];
      }
    }

    if (this.email.length > 0) {
      firstLetter = this.email[0];
    }

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
            padding: EdgeInsets.all(akContentPadding * 1.15),
            child: AkText(
              '¿Eres tú?',
              type: AkTextType.h9,
            ),
          ),
          Divider(
            color: Color(0xFFE7EAE7),
            height: 1.0,
            thickness: 1.0,
          ),
          Padding(
            padding: EdgeInsets.all(akContentPadding),
            child: Column(
              children: [
                SizedBox(height: 10.0),
                AkText(
                  'Detectamos que el correo ingresado está vinculado a una cuenta existente:',
                  type: AkTextType.body1,
                ),
                SizedBox(height: 20.0),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(akContentPadding * 0.75),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: akSecondaryColor,
                      ),
                      child: AkText(
                        firstLetter.toUpperCase(),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(width: akContentPadding * 0.75),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AkText(
                            this.email,
                            type: AkTextType.body1,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: akTextColor.withOpacity(.85)),
                          ),
                          AkText(
                            'Creado: $day $month $year',
                            type: AkTextType.caption,
                            style:
                                TextStyle(color: akTextColor.withOpacity(.45)),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 25.0),
                AkButton(
                  onPressed: this.onYesTap,
                  text: 'Sí, soy yo',
                  fluid: true,
                ),
                SizedBox(height: 5.0),
                AkButton(
                  type: AkButtonType.outline,
                  elevation: 0.0,
                  onPressed: this.onNoTap,
                  text: 'No, no soy yo',
                  fluid: true,
                ),
              ],
            ),
          )
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
