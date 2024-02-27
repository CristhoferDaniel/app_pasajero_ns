import 'package:app_pasajero_ns/themes/ak_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PruebaPage extends StatefulWidget {
  @override
  State<PruebaPage> createState() => _PruebaPageState();
}

class _PruebaPageState extends State<PruebaPage> {
  bool isHidden = true;

  void toogleDropdownWidget() {
    Get.snackbar(
      'Hola',
      'Mundo',
      backgroundColor: Colors.green,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('hola'),
      ),
      body: Container(
        padding: EdgeInsets.all(15.0),
        child: Column(
          children: [
            AkButton(
              onPressed: toogleDropdownWidget,
              text: isHidden == false ? 'Ocultar' : 'Expandir',
            ),
            Container(
              height: isHidden == false ? 500.0 : 50.0,
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.red),
              child: isHidden == false
                  ? Icon(Icons.arrow_upward_rounded)
                  : Icon(Icons.arrow_downward_rounded),
              padding: EdgeInsets.all(8.0),
              alignment: Alignment.topLeft,
            ),
          ],
        ),
      ),
    );
  }
}
