import 'package:app_pasajero_ns/themes/ak_ui.dart';
import 'package:flutter/material.dart';

class ModalEmailUsed extends StatelessWidget {
  final String email;
  final String dateCreated;
  final void Function() onYesTap;
  final void Function() onNoTap;

  ModalEmailUsed({
    required this.email,
    required this.dateCreated,
    required this.onYesTap,
    required this.onNoTap,
  });

  @override
  Widget build(BuildContext context) {
    String day = '';
    String month = '';
    String year = '';

    String firstLetter = '';

    if (this.dateCreated.length > 0) {
      final splitted = this.dateCreated.split(' ');
      if (splitted.length > 3) {
        day = splitted[1];
        month = splitted[2];
        year = splitted[3];
      }
    }

    if (this.email.length > 0) {
      firstLetter = this.email[0];
    }

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
            padding: EdgeInsets.all(akContentPadding * 1.15),
            child: AkText(
              '¿Eres tú?',
              type: AkTextType.h9,
            ),
          ),
          Divider(
            color: Color(0xFFE7EAE7),
            height: 1.0,
            thickness: 1.0,
          ),
          Padding(
            padding: EdgeInsets.all(akContentPadding),
            child: Column(
              children: [
                SizedBox(height: 10.0),
                AkText(
                  'Detectamos que el correo ingresado está vinculado a una cuenta existente:',
                  type: AkTextType.body1,
                ),
                SizedBox(height: 20.0),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(akContentPadding * 0.75),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: akSecondaryColor,
                      ),
                      child: AkText(
                        firstLetter.toUpperCase(),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(width: akContentPadding * 0.75),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AkText(
                            this.email,
                            type: AkTextType.body1,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: akTextColor.withOpacity(.85)),
                          ),
                          AkText(
                            'Creado: $day $month $year',
                            type: AkTextType.caption,
                            style:
                                TextStyle(color: akTextColor.withOpacity(.45)),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 25.0),
                AkButton(
                  onPressed: this.onYesTap,
                  text: 'Sí, soy yo',
                  fluid: true,
                ),
                SizedBox(height: 5.0),
                AkButton(
                  type: AkButtonType.outline,
                  elevation: 0.0,
                  onPressed: this.onNoTap,
                  text: 'No, no soy yo',
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
