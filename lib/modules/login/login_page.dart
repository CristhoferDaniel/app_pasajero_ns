import 'package:app_pasajero_ns/modules/login/login_controller.dart';
import 'package:app_pasajero_ns/themes/ak_ui.dart';
import 'package:app_pasajero_ns/utils/utils.dart';
import 'package:app_pasajero_ns/widgets/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class LoginPage extends StatelessWidget {
  final _conX = Get.put(LoginController());

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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AkText(
                      'Ingresa tu número de celular',
                      type: AkTextType.h9,
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 15),
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
                      child: GetBuilder<LoginController>(
                          id: 'gbDial',
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
                    validator: _conX.validatePhoneNumber,
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
          SizedBox(height: 30),
          _buildTerms(),
          SizedBox(height: 15),
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
                fontWeight: FontWeight.bold, color: akSecondaryColor),
            recognizer: TapGestureRecognizer()
              ..onTap = _conX.goTerminosCondicionesPage),
        TextSpan(text: '.', style: _dfStyle),
      ]),
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
