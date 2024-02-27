import 'package:app_pasajero_ns/modules/misc/error/misc_error_controller.dart';
import 'package:app_pasajero_ns/themes/ak_ui.dart';
import 'package:app_pasajero_ns/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MiscErrorPage extends StatelessWidget {
  final _conX = Get.put(MiscErrorController());

  final _iconSize = Get.width * 0.45;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  right: 0,
                  left: 0,
                  top: -Get.height + (_iconSize * 0.99),
                  child: Stack(
                    children: [
                      Container(
                        height: Get.height,
                        color: akAccentColor.withOpacity(.35),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          width: double.infinity,
                          child: AspectRatio(
                            aspectRatio: 12 / 1,
                            child: CustomPaint(
                              painter: MiscCurvePainter(
                                color: akScaffoldBackgroundColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SafeArea(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(akContentPadding * 1.5),
                    child: Column(
                      children: [
                        Opacity(
                          opacity: .75,
                          child: Image.asset(
                            'assets/img/error_robot.png',
                            width: Get.width * 0.45,
                          ),
                        ),
                        SizedBox(height: 30.0),
                        AkText(
                          _conX.title,
                          type: AkTextType.h6,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 15.0),
                        AkText(
                          _conX.content,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: akTextColor.withOpacity(.65)),
                        ),
                        SizedBox(height: 20.0),
                        _buildButtonRetry(),
                        SizedBox(height: 15.0),
                        _buildButtonCancel(),
                        SizedBox(height: 25.0),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonRetry() {
    return Container(
      child: AkButton(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 38.0,
          vertical: 12.0,
        ),
        onPressed: _conX.onRetryButtonTap,
        text: 'Reintentar',
        enableMargin: false,
      ),
    );
  }

  Widget _buildButtonCancel() {
    return Container(
      child: AkButton(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 38.0,
          vertical: 12.0,
        ),
        onPressed: _conX.onCancelButtonTap,
        text: '  Cancelar  ',
        enableMargin: false,
        type: AkButtonType.outline,
      ),
    );
  }
}
