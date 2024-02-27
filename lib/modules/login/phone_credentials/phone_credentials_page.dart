import 'package:app_pasajero_ns/modules/login/phone_credentials/verify_phone_controller.dart';
import 'package:app_pasajero_ns/themes/ak_ui.dart';
import 'package:app_pasajero_ns/utils/utils.dart';
import 'package:app_pasajero_ns/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PhoneCredentialsPage extends StatelessWidget {
  final VerifyPhoneController _verifyPhoneX;

  PhoneCredentialsPage(this._verifyPhoneX);

  final _dfTextStyle = TextStyle(
    color: akTextColor,
    fontSize: akFontSize,
    fontFamily: akDefaultFontFamily,
  );

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colorWave = Colors.white.withOpacity(0.3);

    return WillPopScope(
      onWillPop: () async {
        if (_verifyPhoneX.loading.value) return false;

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
              _overlayLoading(),
              _buildBackButton(),
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
                margin: EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AkText(
                      'Código de verificación',
                      type: AkTextType.h8,
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 10),
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: 'Lo hemos enviado al ', style: _dfTextStyle),
                        TextSpan(
                            text:
                                '${_verifyPhoneX.dialSelected + _verifyPhoneX.phoneNumber}',
                            style: _dfTextStyle.copyWith(
                                fontWeight: FontWeight.bold)),
                      ]),
                    ),
                    SizedBox(height: 30),
                    _buildForm(),
                  ],
                ),
              ),
            ),
            SizedBox(height: 70),
          ],
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Form(
      // key: _loginX.formkey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() => OTPFields(
                hasError: _verifyPhoneX.incorrectCode.value,
                pin1: _verifyPhoneX.pin1Ctlr,
                pin2: _verifyPhoneX.pin2Ctlr,
                pin3: _verifyPhoneX.pin3Ctlr,
                pin4: _verifyPhoneX.pin4Ctlr,
                pin5: _verifyPhoneX.pin5Ctlr,
                pin6: _verifyPhoneX.pin6Ctlr,
              )),
          Obx(() => _verifyPhoneX.incorrectCode.value
              ? Container(
                  margin: EdgeInsets.only(top: 15.0, left: 10.0),
                  child: AkText(
                    'El código de verificación es incorrecto',
                    style:
                        TextStyle(color: akRedColor, fontSize: akFontSize - 1),
                  ),
                )
              : SizedBox()),
          SizedBox(height: 50),
          Container(
            width: double.infinity,
            child: Obx(
              () => _verifyPhoneX.sendEnabledSMS.value
                  ? GestureDetector(
                      onTap: _verifyPhoneX.reSendSMS,
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: 'Reenviar al ',
                                style: _dfTextStyle.copyWith(
                                    color: akSecondaryColor)),
                            TextSpan(
                                text:
                                    '${_verifyPhoneX.dialSelected + _verifyPhoneX.phoneNumber}',
                                style: _dfTextStyle.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: akSecondaryColor)),
                          ],
                        ),
                      ),
                    )
                  : RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text: 'Podrás pedir un nuevo código en ',
                              style: _dfTextStyle),
                          TextSpan(
                              text: _verifyPhoneX.secondsTimer.value.toString(),
                              style: _dfTextStyle.copyWith(
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
            ),
          ),
          SizedBox(height: 20),
          Obx(() => AbsorbPointer(
                absorbing: !_verifyPhoneX.enableSubmit.value,
                child: AkButton(
                  elevation: 0,
                  backgroundColor: _verifyPhoneX.enableSubmit.value
                      ? akPrimaryColor
                      : akGreyColor.withOpacity(0.25),
                  enableMargin: false,
                  fluid: true,
                  onPressed: _verifyPhoneX.onNext,
                  textColor: _verifyPhoneX.enableSubmit.value
                      ? akWhiteColor
                      : akTextColor,
                  text: 'Siguiente',
                ),
              )),
        ],
      ),
    );
  }

  Widget _overlayLoading() {
    final size = Get.size;
    return Obx(() => _verifyPhoneX.loading.value
        ? Container(
            height: size.height,
            width: size.width,
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: SpinLoadingIcon(
                size: 30,
              ),
            ),
          )
        : SizedBox());
  }

  Widget _buildBackButton() {
    return SafeArea(
      child: IconButton(
        icon: Icon(Icons.arrow_back_ios_rounded),
        onPressed: () => Get.back(),
      ),
    );
  }
}
