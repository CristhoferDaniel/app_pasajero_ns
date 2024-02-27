import 'dart:math' as math;

import 'package:app_pasajero_ns/data/models/conductor.dart';
import 'package:app_pasajero_ns/themes/ak_ui.dart';
import 'package:app_pasajero_ns/utils/utils.dart';
import 'package:app_pasajero_ns/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DriverTileInfo extends StatelessWidget {
  final Color carColor;
  final ConductorDto? conductor;

  const DriverTileInfo({this.carColor = Colors.white, this.conductor});

  String getFirstName() {
    String result = ''; 
    if (conductor != null) {
      String names = conductor?.nombres ?? ' ';
      // Remueve los múltiples espacios
      final sanitizeStr = names.replaceAll(RegExp(' +'), ' ').trim();
      // Separa las nombres
      final arr = sanitizeStr.split(' ');
      result = arr[0];
      if (result.length <= 4) {
        if (arr.length >= 2) {
          result = result + ' ' + arr[1];
        }
      }
    }

    return result;
  }

  String getPlaca() {
    String result = '';
    if (conductor != null) {
      result = conductor?.vehiculos![0].placa ?? '';
    }
    return result;
  }

  String getFoto() {
    String result = '';
    if (conductor != null) {
      Helpers.logger.wtf(conductor?.foto);
      // result = conductor?.foto ??
      //     'https://tanzolymp.com/images/default-non-user-no-photo-1.jpg';
      result = conductor?.foto ??
          'https://buckettaxiguaa.s3.amazonaws.com/165032_photo_conductor_59.png';
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final avatarSize = Get.width * 0.18;
    final carSize = Get.width * 0.25;

    getFoto();

    Widget car = Stack(
      children: [
        Image.asset(
          'assets/img/car_base.png',
          width: carSize,
        ),
        Opacity(
          opacity: .85,
          child: ColorFiltered(
            child: Image.asset(
              'assets/img/car_filter.png',
              width: carSize,
            ),
            colorFilter: ColorFilter.mode(
              carColor,
              BlendMode.modulate,
            ),
          ),
        )
      ],
    );

    Widget tile = Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: ImageFade(
              width: avatarSize,
              height: avatarSize,
              imageUrl:
                  getFoto()),
          // getFoto()),
        ),
        SizedBox(width: 10.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AkText(
                getFirstName(),
                type: AkTextType.subtitle1,
              ),
              SizedBox(height: 5.0),
              // Row(
              //   children: [
              //     AkText(
              //       'Calificación'.toUpperCase(),
              //       style: TextStyle(
              //           color: akTextColor.withOpacity(.56),
              //           fontSize: akFontSize * 0.55),
              //     ),
              //   ],
              // ),
              // Row(
              //   children: [
              //     Icon(Icons.star_rounded,
              //         color: akAccentColor, size: akFontSize * 1),
              //     SizedBox(width: 5.0),
              //     AkText(
              //       '4.8',
              //       type: AkTextType.caption,
              //       style: TextStyle(color: akTextColor.withOpacity(.56)),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
        Column(
          children: [
            Transform.rotate(
              angle: math.pi / 35,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(math.pi),
                child: car,
              ),
            ),
            SizedBox(height: 6.0),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: akFontSize * 0.4, vertical: akFontSize * 0.2),
              decoration: BoxDecoration(
                  color: akPrimaryColor.withOpacity(.10),
                  borderRadius: BorderRadius.circular(6.0)),
              child: AkText(
                getPlaca(),
                type: AkTextType.body1,
                style: TextStyle(
                  color: akPrimaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );

    return tile;
  }
}
