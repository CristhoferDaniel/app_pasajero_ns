import 'package:animate_do/animate_do.dart';
import 'package:app_pasajero_ns/modules/taxi/taxi_cupon/travel_cupon_controller.dart';
import 'package:app_pasajero_ns/themes/ak_ui.dart';
import 'package:app_pasajero_ns/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class TravelCuponPage extends StatelessWidget {
  final _conX = Get.put(TaxiCuponController());
  static const initialDelay = 400;
  static const delayLapse = 100;
  static const animDuration = 300;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: _buildAppBar(),
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
            AkText(
              'Ingrese un código de cupón',
              style: TextStyle( fontWeight: FontWeight.w600,),
            ),
            Expanded(
              child: Form(
                key: _conX.formKey,
                child: AkInput(
                  enableClean: false,
                  filledColor: Colors.transparent,
                  type: AkInputType.underline,
                  hintText: 'Codigo',
                  keyboardType: TextInputType.text,
                  //validator: _conX.validatePhoneFormat,
                  maxLength: 50,
                  labelColor: akTextColor.withOpacity(0.35),
                  onChanged: (text) =>
                      _conX.code = text /*!.trim().replaceAll(' ', '')*/,
                  //onFieldSubmitted: (text) => _conX.onNextPressed(),
                  textInputAction: TextInputAction.done,
                ),
              ),
            ),
            _buildBtnValidar()
          ],
        ),
      ),
    );
  }

  Widget _buildBtnValidar() {
    return Obx(
      () => !_conX.finishingTravel.value
          ? Content(
            child: FadeInUp(
              delay: Duration(milliseconds: initialDelay + (delayLapse * 3)),
              duration: Duration(milliseconds: animDuration),
              child: AkButton(
                enableMargin: false,
                fluid: true,
                onPressed: _conX.onClickValidateCupon,
                text: 'Validar Cupón',
              )
              )
            )
          : Container(
              width: double.infinity,
              height: 80.0,
              child: Center(
                child: Lottie.asset(
                  'assets/lottie/loading_animation.json',
                  width: 60.0,
                  fit: BoxFit.fill,
                  delegates: LottieDelegates(
                    values: [
                      ValueDelegate.strokeColor(['LOADING', '**'],
                          value: akPrimaryColor)
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        'Promociones',
        style: TextStyle(color: akTextColor),
      ),
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: Icon(
          Icons.clear_rounded,
          color: akTextColor,
        ),
        onPressed: () {
          Get.back();
        },
      ),
    );
  }
}
