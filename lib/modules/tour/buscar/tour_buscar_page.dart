import 'package:app_pasajero_ns/themes/ak_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TourBuscarPage extends StatelessWidget {
  // final _conX = Get.put(TourBuscarController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 75.0,
        title: Row(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                child: AkInput(
                  enableMargin: false,
                  type: AkInputType.underline,
                  filledColor: Colors.transparent,
                  enabledBorderColor: akPrimaryColor,
                  focusedBorderColor: akPrimaryColor,
                  hintText: '¿Cuál será tu destino?',
                  labelColor: akTextColor.withOpacity(.35),
                ),
              ),
            )
          ],
        ),
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: IconButton(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onPressed: () => Get.back(),
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              size: akDefaultGutterSize + 10.0,
            ),
          ),
        ),
        leadingWidth: 30.0,
      ),
      body: Center(
        child: Text('TourBuscar_Page'),
      ),
    );
  }
}
