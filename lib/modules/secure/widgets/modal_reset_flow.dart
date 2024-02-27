import 'package:app_pasajero_ns/themes/ak_ui.dart';
import 'package:flutter/material.dart';

class ModalResetFlow extends StatelessWidget {
  final void Function() onYesTap;
  final void Function() onNoTap;

  ModalResetFlow({
    Key? key,
    required this.onYesTap,
    required this.onNoTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(akCardBorderRadius * 1.5),
            topRight: Radius.circular(akCardBorderRadius * 1.5),
          )),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.all(akContentPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AkText(
                  '¿Quieres volver a empezar?',
                  type: AkTextType.h8,
                  style: TextStyle(
                    color: akTitleColor,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                SizedBox(height: 8.0),
                AkText(
                  '¿Estás seguro que quieres comenzar desde el principio?',
                ),
                SizedBox(height: 25.0),
                AkButton(
                  type: AkButtonType.outline,
                  elevation: 0.0,
                  onPressed: this.onYesTap,
                  text: 'Sí',
                  fluid: true,
                ),
                SizedBox(height: 5.0),
                AkButton(
                  onPressed: this.onNoTap,
                  enableMargin: false,
                  text: 'No',
                  fluid: true,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
