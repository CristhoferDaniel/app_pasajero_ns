import 'package:app_pasajero_ns/modules/app_prefs/app_prefs_controller.dart';
import 'package:app_pasajero_ns/modules/perfil/email_details/perfil_email_details_controller.dart';
import 'package:app_pasajero_ns/themes/ak_ui.dart';
import 'package:app_pasajero_ns/utils/utils.dart';
import 'package:app_pasajero_ns/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PerfilEmailDetailsPage extends StatelessWidget {
  final _appX = Get.find<AppPrefsController>();
  final _conX = Get.put(PerfilEmailDetailsController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => await _conX.handleBack(),
      child: Scaffold(
        body: Stack(
          children: [
            SliverContainer<PerfilEmailDetailsController>(
              gbAppbarId: _conX.gbAppbar,
              scrollController: _conX.scrollController,
              type: _appX.type,
              title: 'Email actual',
              subtitle: 'Datos del email asociado a esta cuenta',
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
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(height: akContentPadding),
                              AkText(
                                _conX.authX.getUser?.email ?? '',
                                style: TextStyle(
                                  fontSize: akFontSize + 2.0,
                                  color: akTitleColor,
                                ),
                              ),
                              SizedBox(height: 20.0),
                              _buildVerificationSection()
                            ],
                          ),
                        ),
                      ),
                      /* Container(
                        padding: EdgeInsets.all(akContentPadding),
                        child: AkButton(
                          fluid: true,
                          enableMargin: false,
                          onPressed: _conX.onButtonChangeTap,
                          text: 'Cambiar mi email',
                        ),
                      ) */
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

  Widget _buildVerificationSection() {
    return GetBuilder<PerfilEmailDetailsController>(
        id: _conX.gbVerificationSection,
        builder: (_) {
          final emailVerified = _conX.authX.getUser!.emailVerified;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(
                    emailVerified
                        ? Icons.check_circle_outline_rounded
                        : Icons.warning_amber_rounded,
                    color: emailVerified ? akSuccessColor : akWarningColor,
                  ),
                  SizedBox(width: 10.0),
                  Expanded(
                    child: AkText(
                      emailVerified
                          ? 'Email verificado'
                          : 'Tu email no ha sido verficado',
                      style: TextStyle(
                          color:
                              emailVerified ? akSuccessColor : akWarningColor),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              !emailVerified && !_conX.verificationMailSent
                  ? AkButton(
                      backgroundColor: Helpers.darken(akWhiteColor, 0.02),
                      onPressed: _conX.onResendEmailVerificationTap,
                      text: 'Enviar mail de verificación',
                      textColor: akTitleColor,
                    )
                  : SizedBox(),
            ],
          );
        });
  }
}
