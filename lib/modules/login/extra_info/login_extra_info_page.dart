import 'package:app_pasajero_ns/modules/login/extra_info/login_extra_info_controller.dart';
import 'package:app_pasajero_ns/themes/ak_ui.dart';
import 'package:app_pasajero_ns/utils/utils.dart';
import 'package:app_pasajero_ns/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginExtraInfoPage extends StatelessWidget {
  final _conX = Get.put(LoginExtraInfoController());

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
                        'Completar información',
                        type: AkTextType.h9,
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 10),
                      AkText(
                          'Necesitamos unos datos antes de que puedas usar nuestro servicio.',
                          style:
                              TextStyle(color: akTextColor.withOpacity(.75))),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            flex: 12,
                            child: _inputNombre(),
                          ),
                          Expanded(
                            flex: 18,
                            child: _inputApellido(),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      AkText(
                        '  Términos y condiciones',
                        type: AkTextType.caption,
                      ),
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

  Widget _inputNombre() {
    return AkInput(
      enableClean: false,
      maxLength: 30,
      filledColor: Colors.transparent,
      type: AkInputType.underline,
      textCapitalization: TextCapitalization.words,
      hintText: 'Nombre',
      validator: _conX.validateNameAndLastName,
      labelColor: akTextColor.withOpacity(0.35),
      onSaved: (text) => _conX.nombre = text!.trim(),
      // textInputAction: TextInputAction.next,
    );
  }

  Widget _inputApellido() {
    return AkInput(
      enableClean: false,
      maxLength: 30,
      filledColor: Colors.transparent,
      type: AkInputType.underline,
      textCapitalization: TextCapitalization.words,
      hintText: 'Apellido',
      validator: _conX.validateNameAndLastName,
      labelColor: akTextColor.withOpacity(0.35),
      onSaved: (text) => _conX.apellido = text!.trim(),
      // textInputAction: TextInputAction.done,
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
