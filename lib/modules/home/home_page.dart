import 'package:app_pasajero_ns/modules/home/home_controller.dart';
import 'package:app_pasajero_ns/themes/ak_ui.dart';
import 'package:app_pasajero_ns/utils/utils.dart';
import 'package:app_pasajero_ns/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  final _conX = Get.find<HomeController>();
  final double paddSize = akContentPadding;

  @override
  Widget build(BuildContext context) {
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
        key: _conX.drawerKey,
        drawer: AppDrawer(drawerKey: _conX.drawerKey),
        body: Stack(
          children: [
            Positioned.fill(
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      color: akAccentColor,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: akScaffoldBackgroundColor,
                    ),
                  ),
                ],
              ),
            ),
           
            _buildContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Container(
        color: akScaffoldBackgroundColor,
        child: Column(
          children: [
            _buildTaxiSection(),
            _buildReservaSection(),
            // _buildTourSection(),
            // _buildTravelAgainSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildTaxiSection() {
    final colorWave = akAccentColor;
    final double appBarHeight = 80.0;
    final double taxiSize = Get.width * 0.29;

    return Container(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            color: colorWave,
            child: SafeArea(
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: paddSize),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: appBarHeight),
                        Row(
                          children: [
                            Container(
                              width: (Get.width) -
                                  (paddSize * 2) -
                                  (taxiSize * 0.8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 10.0),
                                  AkText(
                                    '¿Buscas un taxi?',
                                    style: TextStyle(
                                        color: akTitleColor,
                                        fontSize: akFontSize + 9.0),
                                  ),
                                  SizedBox(height: 10.0),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: AkText(
                                          'Nuestro servicio exclusivo te ayudará a llegar a tu destino.',
                                          type: AkTextType.body1,
                                          style: TextStyle(
                                            color: akTextColor.withOpacity(.75),
                                            height: 1.45,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 25.0),
                        AkButton(
                          enableMargin: false,
                          onPressed: _conX.goToTaxiService,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 25.0),
                          size: AkButtonSize.small,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: AkText(
                                  'Solicitar servicio',
                                  style: TextStyle(
                                    color: akWhiteColor,
                                    fontSize: akFontSize,
                                  ),
                                ),
                              ),
                              SizedBox(width: 7.0),
                              Icon(
                                Icons.arrow_forward_outlined,
                                size: akFontSize - 3.0,
                                color: akWhiteColor,
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 60.0),
                      ],
                    ),
                  ),
                  Positioned(
                    top: appBarHeight + 10,
                    right: -(taxiSize * 0.3),
                    child: SvgPicture.asset(
                      'assets/icons/taxi_frontal.svg',
                      width: taxiSize,
                      color: akPrimaryColor.withOpacity(.18),
                    ),
                  ),
                  Positioned(
                    top: appBarHeight * 0.15,
                    left: paddSize - 14.0,
                    child: _buildMenuIcon(),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            child: AspectRatio(
              aspectRatio: 7 / 1,
              child: CustomPaint(
                painter: CurvePainter3(
                  color: colorWave,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReservaSection() {
    final colorWave = akAccentColor;
    final double appBarHeight = 80.0;
    final double taxiSize = Get.width * 0.29;

    return Container(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            // color: colorWave,
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: paddSize),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: appBarHeight),
                      Row(
                        children: [
                          Container(
                            width:
                                (Get.width) - (paddSize * 2) - (taxiSize * 0.8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AkText(
                                  '¿Reservar un viaje?',
                                  style: TextStyle(
                                      color: akTitleColor,
                                      fontSize: akFontSize + 9.0),
                                ),
                                SizedBox(height: 10.0),
                                Row(
                                  children: [
                                    Expanded(
                                      child: AkText(
                                        'Puedes planificar un servicio para viajar de forma segura.',
                                        type: AkTextType.body1,
                                        style: TextStyle(
                                          color: akTextColor.withOpacity(.75),
                                          height: 1.45,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 25.0),
                      AkButton(
                        type: AkButtonType.outline,
                        enableMargin: false,
                        onPressed: _conX.goToReservaService,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 25.0),
                        size: AkButtonSize.small,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: AkText(
                                'Programar servicio',
                                style: TextStyle(
                                  color: akPrimaryColor,
                                  fontSize: akFontSize,
                                ),
                              ),
                            ),
                            SizedBox(width: 7.0),
                            Icon(
                              Icons.arrow_forward_outlined,
                              size: akFontSize - 3.0,
                              color: akPrimaryColor,
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 10.0),
                    ],
                  ),
                ),
                Positioned(
                  top: appBarHeight + 10,
                  right: -(taxiSize * 0.3),
                  child: SvgPicture.asset(
                    'assets/icons/taxi_frontal.svg',
                    width: taxiSize,
                    color: akPrimaryColor.withOpacity(.18),
                  ),
                ),
              ],
            ),
          ),
          /* Container(
            width: double.infinity,
            child: AspectRatio(
              aspectRatio: 7 / 1,
              child: CustomPaint(
                painter: CurvePainter3(
                  color: colorWave,
                ),
              ),
            ),
          ), */
        ],
      ),
    );
  }

  Widget _buildTourSection() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: akContentPadding),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.0),
          Container(
            padding: EdgeInsets.symmetric(horizontal: paddSize),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AkText(
                  'Descubre experiencias',
                  style: TextStyle(
                    fontSize: akFontSize + 3.0,
                    fontWeight: FontWeight.w500,
                    height: 1.45,
                    color: akTitleColor,
                  ),
                ),
                SizedBox(height: 7.0),
                AkText(
                  'Encuentra nuevos lugares y programa un viaje con nuestro servicio turístico.',
                  style: TextStyle(
                    color: akTextColor.withOpacity(.6),
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15.0),
          _buildTopTourList(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: paddSize),
            child: AkButton(
              enableMargin: false,
              onPressed: _conX.goToTourService,
              type: AkButtonType.outline,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
              size: AkButtonSize.small,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: AkText(
                      'Conocer más',
                      style: TextStyle(
                        color: akPrimaryColor,
                        fontSize: akFontSize - 2.0,
                      ),
                    ),
                  ),
                  SizedBox(width: 7.0),
                  Icon(
                    Icons.arrow_forward_outlined,
                    size: akFontSize - 3.0,
                    color: akPrimaryColor,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopTourList() {
    return GetBuilder<HomeController>(
        id: 'gbTourList',
        builder: (_) {
          double bxWidth = (Get.width - (paddSize * 2)) /
              2.30; // Cambiar aquí para el tamaño
          double bxHeight = bxWidth * 0.75;

          if (_conX.tourList.isEmpty) {
            return SizedBox(height: 15.0);
          }

          return Container(
            width: double.infinity,
            height: bxHeight + 75.0,
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: _conX.tourList.length,
              itemBuilder: (_, i) {
                final TopTourPlaces item = _conX.tourList[i];
                return Container(
                  margin: EdgeInsets.only(
                    right: akContentPadding,
                    left: i == 0 ? paddSize : 0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: ImageFade(
                          width: bxWidth,
                          height: bxHeight,
                          imageUrl: item.photoUrl,
                        ),
                      ),
                      SizedBox(height: 6.0),
                      Container(
                        width: bxWidth,
                        child: AkText(
                          item.title + '\n---------',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: akFontSize - 3.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      StarsRating(
                        color: akAccentColor,
                        size: akFontSize - 1.0,
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        });
  }

  Widget _buildTravelAgainSection() {
    return Container(
      padding: EdgeInsets.all(paddSize),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 5.0),
          AkText(
            'Viaja otra vez',
            style: TextStyle(
              fontSize: akFontSize + 3.0,
              fontWeight: FontWeight.w500,
              height: 1.45,
              color: akTitleColor,
            ),
          ),
          SizedBox(height: 7.0),
          AkText(
            'Aquí tienes una lista de los últimos lugares a los que has ido.',
            style: TextStyle(
              color: akTextColor.withOpacity(.6),
              height: 1.45,
            ),
          ),
          SizedBox(height: 15.0),
          GetBuilder<HomeController>(
              id: 'gbLastList',
              builder: (_) {
                List<Widget> items = [];
                _conX.lastPlaces.forEach((place) {
                  items.add(Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            color: akTextColor.withOpacity(.25),
                          ),
                          SizedBox(width: 10.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AkText(
                                  place.title,
                                  style: TextStyle(
                                    fontSize: akFontSize - 2.0,
                                    fontWeight: FontWeight.w600,
                                    color: akTextColor.withOpacity(.8),
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                AkText(
                                  place.subTitle,
                                  style: TextStyle(
                                    fontSize: akFontSize - 3.5,
                                    color: akTextColor.withOpacity(.65),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Divider(),
                    ],
                  ));
                });
                return Column(
                  children: items,
                );
              })
        ],
      ),
    );
  }

  Widget _buildMenuIcon() {
    return IconButton(
      icon: CustomIconMenu(),
      onPressed: _conX.openDrawer,
    );
  }
}
