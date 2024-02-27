import 'package:app_pasajero_ns/modules/taxi/taxi_mapa/taxi_mapa_page.dart';
import 'package:app_pasajero_ns/themes/ak_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class RouteNotAvailable extends StatelessWidget {
  final Function() onModifyTap;

  const RouteNotAvailable({required this.onModifyTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(akCardBorderRadius * 1.5),
          topRight: Radius.circular(akCardBorderRadius * 1.5),
        ),
        boxShadow: TaxiMapaPage.cardShadows,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.all(akContentPadding),
            child: Column(
              children: [
                SizedBox(height: 20.0),
                SvgPicture.asset(
                  'assets/icons/route.svg',
                  width: Get.width * 0.20,
                ),
                SizedBox(height: 25.0),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: akContentPadding * 0.5),
                  child: AkText(
                    'Ruta no disponible',
                    type: AkTextType.h6,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(height: 15.0),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: akContentPadding * 1),
                  child: AkText(
                      'Intenta cambiando el punto de origen y/o el lugar de destino.',
                      type: AkTextType.body1,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: akTextColor.withOpacity(.65))),
                ),
                SizedBox(height: 30.0),
                Row(
                  children: [
                    Expanded(
                      child: AkButton(
                        enableMargin: false,
                        type: AkButtonType.outline,
                        elevation: 0.0,
                        onPressed: onModifyTap,
                        text: 'Modificar viaje',
                        fluid: true,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
              ],
            ),
          )
        ],
      ),
    );
  }
}
