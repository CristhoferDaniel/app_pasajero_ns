import 'package:app_pasajero_ns/themes/ak_ui.dart';
import 'package:app_pasajero_ns/widgets/widgets.dart';
import 'package:flutter/material.dart';

class CambiarPasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarBasic(),
      body: Container(
        padding: EdgeInsets.only(right: 20, left: 20, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cambiar contraseña',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            Text('Ingrese sus datos'),
            AkInput(hintText: 'Contraseña anterior'),
            AkInput(hintText: 'Contraseña'),
            AkInput(hintText: 'Repetir contraseña'),
            SizedBox(height: 25),
            AkButton(
              text: 'Actualizar datos',
              onPressed: () {
                Navigator.pop(context);
              },
              fluid: true,
            ),
          ],
        ),
      ),
    );
  }
}
