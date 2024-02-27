import 'dart:math' as math;

import 'package:animate_do/animate_do.dart';
import 'package:app_pasajero_ns/modules/intro/intro_controller.dart';
import 'package:app_pasajero_ns/themes/ak_ui.dart';
import 'package:app_pasajero_ns/utils/utils.dart';
import 'package:app_pasajero_ns/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IntroPage extends StatelessWidget {
  final _conX = Get.put(IntroController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colorWave = Colors.white.withOpacity(0.15);

    return WillPopScope(
      onWillPop: () async {
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
                  height: size.height,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      FadeInDown(
                        duration: Duration(milliseconds: 500),
                        child: Column(
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
                      ),
                    ],
                  )),
              Center(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FadeIn(
                        child: LogoApp(),
                        delay: Duration(milliseconds: 600),
                        duration: Duration(milliseconds: 1500),
                      ),
                      SizedBox(height: 150.0),
                    ],
                  ),
                ),
              ),
              _buildNavigationWidget()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationWidget() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: FadeInUp(
        duration: Duration(milliseconds: 700),
        child: Column(
          children: [
            Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationX(math.pi),
              child: Container(
                color: Colors.transparent,
                child: Container(
                  width: double.infinity,
                  child: AspectRatio(
                    aspectRatio: 8 / 1,
                    child: CustomPaint(
                      painter: CurvePainter2(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(akContentPadding),
              color: Colors.white,
              child: Column(
                children: [
                  _buildSlogan(),
                  _buildBtnComenzar(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlogan() {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AkText(
            'Tu transporte seguro',
            style: TextStyle(
              color: akTitleColor,
              fontWeight: FontWeight.w500,
              fontSize: akFontSize + 8.0,
            ),
          ),
          SizedBox(height: 10.0),
          AkText('Comienza el verdadero servicio de taxi.',
              style: TextStyle(
                  fontSize: akFontSize + 2.0,
                  color: akTextColor.withOpacity(.75),
                  fontWeight: FontWeight.w400)),
          SizedBox(height: 15),
        ],
      ),
    );
  }

  Widget _buildBtnComenzar() {
    return Padding(
      padding: EdgeInsets.only(top: 5.0),
      child: AkButton(
        onPressed: _conX.goToLoginPhonePage,
        enableMargin: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 15.0,
            ),
            AkText(
              'Comenzar',
              style: TextStyle(color: akWhiteColor, fontSize: akFontSize + 2),
            ),
            Icon(
              Icons.arrow_forward_rounded,
              size: akFontSize + 5,
              color: akWhiteColor,
            ),
          ],
        ),
      ),
    );
  }
}
