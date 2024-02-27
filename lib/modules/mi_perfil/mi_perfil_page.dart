import 'package:app_pasajero_ns/modules/mi_perfil/cambiar_password_page.dart';
import 'package:app_pasajero_ns/themes/ak_ui.dart';
import 'package:app_pasajero_ns/widgets/widgets.dart';
import 'package:flutter/material.dart';

class MiPerfilPage extends StatelessWidget {
  // final _conX = Get.put(MiPerfilController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarBasic(),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          padding: EdgeInsets.only(right: 20, left: 20, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mi perfil',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              Text('Modificar datos necesarios'),
              SizedBox(
                height: 20,
              ),
              AkInput(hintText: 'DNI'),
              AkInput(hintText: 'Nombres'),
              AkInput(hintText: 'Apellidos'),
              AkInput(hintText: 'Celular'),
              // AkInput(hintText: 'Correo'),
              SizedBox(height: 10),
              AkButton(
                text: 'Cambiar contraseña',
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => CambiarPasswordPage()));
                },
                fluid: true,
              ),
              SizedBox(height: 10),
              AkButton(
                text: 'Actualizar datos',
                onPressed: () {
                  Navigator.pop(context);
                },
                fluid: true,
              )
            ],
          ),
        ),
      ),
    );
  }
}
