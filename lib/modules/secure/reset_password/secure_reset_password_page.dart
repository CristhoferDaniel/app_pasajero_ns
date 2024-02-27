import 'package:animate_do/animate_do.dart';
import 'package:app_pasajero_ns/modules/app_prefs/app_prefs_controller.dart';
import 'package:app_pasajero_ns/modules/secure/reset_password/secure_reset_password_controller.dart';
import 'package:app_pasajero_ns/themes/ak_ui.dart';
import 'package:app_pasajero_ns/utils/utils.dart';
import 'package:app_pasajero_ns/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SecureResetPasswordPage extends StatelessWidget {
  final SecureResetPasswordController _conX;
  final _appX = Get.find<AppPrefsController>();

  SecureResetPasswordPage(this._conX);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => await _conX.handleBack(),
      child: Scaffold(
        body: Stack(
          children: [
            SliverContainer<SecureResetPasswordController>(
              gbAppbarId: _conX.gbAppbar,
              scrollController: _conX.scrollController,
              type: _appX.type,
              title: 'Restablecer',
              subtitle: 'Recuperación de contraseña',
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
                              _buildBody(),
                            ],
                          ),
                        ),
                      ),
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

  Widget _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            width: double.infinity,
            child: Obx(() {
              if (_conX.loading.value) {
                return FadeIn(
                  key: ValueKey('_vk38984014'),
                  child: _buildEnviandoPassword(),
                );
              } else {
                return FadeIn(
                  key: ValueKey('_vk38984015'),
                  child: _buildContenido(),
                );
              }
            })),
      ],
    );
  }

  Widget _buildEnviandoPassword() {
    return Column(
      children: [
        SizedBox(height: 40.0),
        _letterIcon(),
        SizedBox(height: 10.0),
        AkText(
          'Enviando correo\nde restablecimiento...',
          type: AkTextType.h9,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: akTitleColor,
            fontWeight: FontWeight.normal,
          ),
        ),
        SizedBox(height: 70.0),
      ],
    );
  }

  Widget _letterIcon() {
    return Container(
      width: double.infinity,
      child: SvgPicture.asset(
        'assets/icons/email_send.svg',
        width: Get.size.width * 0.20,
        color: akTextColor.withOpacity(.85),
      ),
    );
  }

  Widget _buildContenido() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _letterIcon(),
        SizedBox(height: 15),
        AkText(
            'Un enlace de recuperación ha sido enviado al correo ${Helpers.getObfuscateEmail(_conX.email)}'),
        SizedBox(height: 20),
        AkText(
            'Revisa tu bandeja y luego regresa a la aplicación para ingresar la nueva contraseña.'),
        SizedBox(height: 20),
        AkButton(
          onPressed: _conX.backAction,
          text: 'Ya restablecí mi contraseña',
          fluid: true,
          enableMargin: false,
        ),
      ],
    );
  }
}
