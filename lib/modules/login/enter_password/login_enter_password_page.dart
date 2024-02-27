import 'package:app_pasajero_ns/modules/login/enter_password/login_enter_password_controller.dart';
import 'package:app_pasajero_ns/themes/ak_ui.dart';
import 'package:app_pasajero_ns/utils/utils.dart';
import 'package:app_pasajero_ns/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginEnterPasswordPage extends StatelessWidget {
  final _conX = Get.put(LoginEnterPasswordController());

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
                      Obx(() => AkText(
                            _conX.newMailFirebase.value
                                ? 'Crea una contraseña'
                                : 'Introduce tu contraseña',
                            type: AkTextType.h9,
                            style: TextStyle(fontWeight: FontWeight.w600),
                          )),
                      SizedBox(height: 10),
                      Obx(
                        () => AkText(
                          _conX.newMailFirebase.value
                              ? 'Necesitarás 6 o más caracteres.'
                              : 'Hola de nuevo, introduce la contraseña de tu cuenta Taxigua: \n\n   ${Helpers.getObfuscateEmail(_conX.email)}',
                          // : 'Introduce la contraseña de tu cuenta \nemail\n para actualizar tu nuevo número.',
                          style: TextStyle(
                            color: akTextColor.withOpacity(.75),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Obx(() => AkInput(
                            controller: _conX.passwordCtlr,
                            focusNode: _conX.passwordFocusNode,
                            obscureText: _conX.hidePassword.value,
                            filledColor: Colors.transparent,
                            type: AkInputType.underline,
                            hintText: _conX.newMailFirebase.value
                                ? 'Escribe una contraseña'
                                : 'Escribe la contraseña',
                            validator: _conX.validatePassword,
                            labelColor: akTextColor.withOpacity(0.35),
                            onSaved: (text) => _conX.password = text!.trim(),
                            textInputAction: TextInputAction.next,
                            suffixIcon: _conX.hidePassword.value
                                ? Icon(Icons.visibility_rounded)
                                : Icon(Icons.visibility_off_rounded),
                            enableClean: false,
                            onSuffixIconTap: _conX.togglePasswordVisibility,
                            onFieldSubmitted: (_) =>
                                _conX.confirmPasswordFocusNode.requestFocus(),
                            onChanged: _conX.handleStatusNextButton,
                          )),
                      Obx(() => _conX.newMailFirebase.value
                          ? AkInput(
                              focusNode: _conX.confirmPasswordFocusNode,
                              obscureText: _conX.hideConfirmPassword.value,
                              filledColor: Colors.transparent,
                              type: AkInputType.underline,
                              hintText: 'Repite la contraseña',
                              validator: _conX.validateConfirmPassword,
                              labelColor: akTextColor.withOpacity(0.35),
                              suffixIcon: _conX.hideConfirmPassword.value
                                  ? Icon(Icons.visibility_rounded)
                                  : Icon(Icons.visibility_off_rounded),
                              enableClean: false,
                              onSuffixIconTap:
                                  _conX.toggleConfirmPasswordVisibility,
                              onSaved: (text) =>
                                  _conX.confirmPassword = text!.trim(),
                              textInputAction: TextInputAction.next,
                            )
                          : SizedBox()),
                      _labelLostPassword(),
                      SizedBox(height: 20),
                      _buildNextButton(),
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

  Widget _buildNextButton() {
    return Obx(() => AkButton(
          onPressed: _conX.onNextPressed,
          text: _conX.sendEnabledSMS.value
              ? 'Siguiente'
              : 'Esperar 00:${_conX.secondsTimer.value < 10 ? '0' + _conX.secondsTimer.value.toString() : _conX.secondsTimer.value.toString()}',
          fluid: true,
          enableMargin: false,
          disabled:
              _conX.disabledNextButton.value || !_conX.sendEnabledSMS.value,
        ));
  }

  Widget _labelLostPassword() {
    Widget widget = GestureDetector(
      onTap: _conX.goToResetPasswordPage,
      child: Column(
        children: [
          SizedBox(height: 50),
          Container(
            width: double.infinity,
            child: AkText(
              'He olvidado mi contraseña',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: akSecondaryColor,
                fontSize: akFontSize + 1.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );

    return Obx(() => _conX.newMailFirebase.value ? SizedBox() : widget);
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
