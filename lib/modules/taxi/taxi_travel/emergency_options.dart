import 'package:app_pasajero_ns/modules/taxi/taxi_travel/taxi_travel_controller.dart';
import 'package:app_pasajero_ns/themes/ak_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';

class EmergencyOptions extends StatelessWidget {
  final _conX = Get.put(TaxiTravelController());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(akContentPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 15.0),
          AkText(
            '¿Tienes una emergencia?',
            type: AkTextType.h8,
          ),
          SizedBox(height: 25.0),
          AkButton(
            fluid: true,
            // type: AkButtonType.outline,
            onPressed: _conX.sendSOS,
            text: 'Enviar SOS',
            prefixIcon: Icon(Icons.shield_outlined),
            verticalAlign: CrossAxisAlignment.start,
          ),
          // AkButton(
          //   fluid: true,
          //   // type: AkButtonType.outline,
          //   onPressed: () {},
          //   text: 'Compartir mi viaje',
          //   prefixIcon: Icon(Icons.share),
          //   verticalAlign: CrossAxisAlignment.start,
          // ),
          AkButton(
            enableMargin: false,
            fluid: true,
            // type: AkButtonType.outline,
            onPressed: _conX.call105,
            text: 'Llamar a 105',
            prefixIcon: Icon(Icons.warning_amber),
            verticalAlign: CrossAxisAlignment.start,
          ),
          SizedBox(height: 10.0),
        ],
      ),
    );
  }
}
