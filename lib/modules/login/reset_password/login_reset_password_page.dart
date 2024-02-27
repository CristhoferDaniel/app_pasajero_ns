import 'package:app_pasajero_ns/modules/login/reset_password/login_reset_password_controller.dart';
import 'package:app_pasajero_ns/themes/ak_ui.dart';
import 'package:app_pasajero_ns/utils/utils.dart';
import 'package:app_pasajero_ns/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class LoginResetPasswordPage extends StatelessWidget {
  final _conX = Get.put(LoginResetPasswordController());

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
                  child: Obx(() {
                    if (_conX.loading.value) {
                      return _buildEnviandoPassword();
                    } else {
                      if (_conX.hasError.value) {
                        return _buildErrors();
                      } else {
                        return _buildContenido();
                      }
                    }
                  })),
            ),
            SizedBox(height: 70),
          ],
        ),
      ],
    );
  }

  Widget _buildEnviandoPassword() {
    return Column(
      children: [
        SizedBox(height: 70.0),
        AkText('Enviando restablecimiento...'),
        SizedBox(height: 70.0),
      ],
    );
  }

  Widget _buildErrors() {
    return Column(
      children: [
        SizedBox(height: 20),
        AkText(
          'Hubo un error',
          type: AkTextType.h9,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 30),
        AkText('No se pudo restablecer la contraseña.'),
        SizedBox(height: 30.0),
        AkButton(
          type: AkButtonType.outline,
          onPressed: _conX.sendResetPasswordEmail,
          text: 'Reintentar',
          fluid: true,
          enableMargin: false,
        ),
      ],
    );
  }

  Widget _buildContenido() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          child: SvgPicture.asset(
            'assets/icons/email_send.svg',
            width: Get.size.width * 0.20,
            color: akTextColor.withOpacity(.85),
          ),
        ),
        SizedBox(height: 15),
        AkText(
          'Restablecer contraseña',
          type: AkTextType.h9,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 15),
        AkText(
            'Un enlace de recuperación ha sido enviado al correo ${Helpers.getObfuscateEmail(_conX.email)}'),
        SizedBox(height: 20),
        AkText(
            'Revisa tu bandeja y luego regresa a la aplicación para ingresar la nueva contraseña.'),
        SizedBox(height: 20),
        AkButton(
          onPressed: () => Get.back(),
          text: 'Ya restablecí mi contraseña',
          fluid: true,
          enableMargin: false,
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
