import 'package:app_pasajero_ns/modules/taxi/taxi_finished/travel_finished_controller.dart';
import 'package:app_pasajero_ns/themes/ak_ui.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class TravelFinishedPage extends StatelessWidget {
  final _conX = Get.put(TaxiFinishedController());

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
            SizedBox(height: 25.0),
            GetBuilder<TaxiFinishedController>(
              id: _conX.gbInfo,
              builder: (_) => Column(
                children: [
                  _buildTotalCard(),
                  _buildBtnIngresarCupon(),
                  _buildDetails(),
                ],
              ),
            ),
            Expanded(child: SizedBox()), // No quitar
            _buildBtnFinalizar(),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalCard() {
    double imgHeight = 200.0;

    final card = Container(
      width: Get.width,
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(left: 20.0),
            width: Get.width,
            decoration: BoxDecoration(
              color: Color(0xFFF3F4F5),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                bottomLeft: Radius.circular(20.0),
              ),
            ),
            child: Row(
              children: [
                SizedBox(width: 20.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        alignment: Alignment.center,
                        child: AkText('Total del viaje', type: AkTextType.h9)),
                    SizedBox(height: 5.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AkText(
                          'S/ ',
                          type: AkTextType.h7,
                          style: TextStyle(
                            color: akTextColor.withOpacity(
                              .75,
                            ),
                          ),
                        ),
                        SizedBox(width: 5.0),
                        Obx(() => AkText(
                              // _conX.total,
                              _conX.total.value,
                              type: AkTextType.h5,
                              style: TextStyle(
                                color: akTextColor.withOpacity(
                                  .75,
                                ),
                              ),
                            )),
                        SizedBox(width: 40.0),
                      ],
                    ),
                    Obx(() => _conX.idCupon.value > 0
                        ? Container(
                            alignment: Alignment.center,
                            child: AkText('Descuento', type: AkTextType.h9))
                        : SizedBox(width: 0.0)),
                    SizedBox(height: 5.0),
                    Obx(() => _conX.idCupon.value > 0
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AkText(
                                'S/ ',
                                type: AkTextType.h9,
                                style: TextStyle(
                                  color: akTextColor.withOpacity(
                                    .75,
                                  ),
                                ),
                              ),
                              SizedBox(width: 5.0),
                              Obx(() => AkText(
                                    // _conX.total,
                                    _conX.descuento.value,
                                    type: AkTextType.h9,
                                    style: TextStyle(
                                      color: akTextColor.withOpacity(
                                        .75,
                                      ),
                                    ),
                                  )),
                              SizedBox(width: 40.0),
                            ],
                          )
                        : SizedBox(width: 0.0)),
                    SizedBox(height: 20.0),
                    Container(
                        alignment: Alignment.center,
                        child: AkText(
                          'Duración',
                          type: AkTextType.subtitle1,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    SizedBox(height: 5.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AkText(
                          _conX.totalTiempo,
                          style: TextStyle(
                            color: akTextColor.withOpacity(.75),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(width: 5.0),
                Expanded(
                  child: Stack(
                    children: [
                      Container(height: imgHeight),
                      Positioned(
                        top: 0, // imgHeight * 0.075,
                        left: 0,
                        child: Container(
                          child: SvgPicture.asset(
                            'assets/icons/cf_3.svg',
                            height: imgHeight,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
    return card;
  }

  Widget _buildDetails() {
    final sbStyle = TextStyle(
      color: akTextColor.withOpacity(.55),
      fontSize: akFontSize + 2.0,
      fontWeight: FontWeight.w600,
    );
    final dtStyle = TextStyle(
      color: akTextColor.withOpacity(.55),
    );
    final vlStyle = TextStyle(
      color: akTextColor.withOpacity(.9),
      fontWeight: FontWeight.bold,
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: akContentPadding * 1.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 30.0),
          AkText('Tipo de pago', style: sbStyle),
          SizedBox(height: 10.0),
          _buildPaymentTypeBar(),
          SizedBox(height: 30.0),
          AkText('Detalles del viaje', style: sbStyle),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AkText('Distancia', style: dtStyle),
              AkText(_conX.totalDistancia, style: vlStyle),
            ],
          ),
          SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AkText('Duración', style: dtStyle),
              AkText(_conX.totalTiempo, style: vlStyle),
            ],
          ),
          SizedBox(height: 50.0),
        ],
      ),
    );
  }

  Widget _buildBtnIngresarCupon() {
    return Obx(
      () => !_conX.finishingTravel.value
          ? Container(
              padding: EdgeInsets.symmetric(horizontal: akContentPadding),
              margin: EdgeInsets.only(bottom: akContentPadding * .5),
              child: AkButton(
                fluid: true,
                onPressed: _conX.goToCupon,
                text: 'Usar cupón',
                variant: AkButtonVariant.primary,
              ),
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

  Widget _buildBtnFinalizar() {
    return Obx(
      () => !_conX.finishingTravel.value
          ? Container(
              padding: EdgeInsets.symmetric(horizontal: akContentPadding),
              margin: EdgeInsets.only(bottom: akContentPadding * .5),
              child: AkButton(
                fluid: true,
                onPressed: _conX.onFinishBtnTap,
                text: 'Terminar',
                variant: AkButtonVariant.primary,
              ),
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

  Widget _buildPaymentTypeBar() {
    Color _colorPaymentType = akSecondaryColor;
    return DottedBorder(
      color: _colorPaymentType,
      borderType: BorderType.RRect,
      radius: Radius.circular(5),
      dashPattern: [8, 4],
      strokeWidth: 1,
      padding: EdgeInsets.all(akContentPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(200),
            child: Container(
              color: akWhiteColor,
              padding: EdgeInsets.all(5),
              child: Icon(
                Icons.attach_money_sharp,
                color: _colorPaymentType,
                size: akFontSize + 3.0,
              ),
            ),
          ),
          SizedBox(width: 10.0),
          AkText(
            'Pago con efectivo',
            style: TextStyle(color: akTextColor.withOpacity(.65)),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        'Viaje finalizado',
        style: TextStyle(color: akTextColor),
      ),
      automaticallyImplyLeading: false,
      /* leading: IconButton(
        icon: Icon(
          Icons.clear_rounded,
          color: akTextColor,
        ),
        onPressed: () {
          Get.back();
        },
      ), */
    );
  }
}
