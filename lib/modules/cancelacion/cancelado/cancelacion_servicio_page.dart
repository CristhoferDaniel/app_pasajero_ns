import 'package:animate_do/animate_do.dart';
import 'package:app_pasajero_ns/modules/cancelacion/cancelado/cancelacion_servicio_controller.dart';
import 'package:app_pasajero_ns/routes/app_pages.dart';
import 'package:app_pasajero_ns/themes/ak_ui.dart';
import 'package:app_pasajero_ns/utils/utils.dart';
import 'package:app_pasajero_ns/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CancelacionRevisionPage extends StatelessWidget {
  final _conX = Get.put(CancelacionRevisionController());

  static const initialDelay = 400;
  static const delayLapse = 100;
  static const animDuration = 300;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: _buildContent(constraints),
              physics: BouncingScrollPhysics(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(BoxConstraints constraints) {
    return ConstrainedBox(
      constraints: BoxConstraints(
          minWidth: constraints.maxWidth, minHeight: constraints.maxHeight),
      child: IntrinsicHeight(
        child: Column(
          children: [
            _buildHeader(),
            Content(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FadeInDown(
                    delay:
                        Duration(milliseconds: initialDelay + (delayLapse * 1)),
                    duration: Duration(milliseconds: animDuration),
                    from: 50,
                    child: AkText(
                      '!CANCELADO!',
                      type: AkTextType.h4,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  FadeInDown(
                    delay:
                        Duration(milliseconds: initialDelay + (delayLapse * 2)),
                    duration: Duration(milliseconds: animDuration),
                    from: 50,
                    child: AkText(
                      'Se a cancelado el servicio.',
                      type: AkTextType.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  SizedBox(height: 30.0),
                ],
              ),
            ),
            Expanded(child: SizedBox()),
            Content(
              child: FadeInUp(
                delay: Duration(milliseconds: initialDelay + (delayLapse * 3)),
                duration: Duration(milliseconds: animDuration),
                from: 50,
                child: AkButton(
                  enableMargin: false,
                  fluid: true,
                  onPressed: () {
                    Get.offAllNamed(AppRoutes.HOME);
                  },
                  text: 'Regresar',
                ),
              ),
            ),
            SizedBox(height: akContentPadding)
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          right: 0,
          left: 0,
          bottom: 0,
          child: Container(
            width: double.infinity,
            child: AspectRatio(
              aspectRatio: 1 / 2,
              child: CustomPaint(
                painter: BigHeaderCurvePainter(
                  // color: akPrimaryColor.withOpacity(.07),
                  color: Helpers.darken(akScaffoldBackgroundColor, 0.03),
                ),
              ),
            ),
          ),
        ),
        SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: akContentPadding * 0.5),
              SizedBox(height: Get.width * 0.15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FadeInDown(
                    delay: Duration(milliseconds: initialDelay),
                    duration: Duration(milliseconds: animDuration),
                    from: 50,
                    /* child: CIconCarDriving(
                      size: Get.width * 0.75,
                    ),  */
                    child: Container(
                      width: Get.width * 0.75,
                      child: Image.asset('assets/img/car_driving.png'),
                    ),
                  ),
                  SizedBox(width: Get.width * 0.08),
                ],
              ),
              SizedBox(height: Get.width * 0.1),
            ],
          ),
        )
      ],
    );
  }
}
