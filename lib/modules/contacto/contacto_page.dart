import 'package:app_pasajero_ns/modules/contacto/contacto_controller.dart';
import 'package:app_pasajero_ns/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: GetBuilder<ContactoController>(
        builder: (controlX) {
          return _buildContenido(controlX);
        },
      ),
    );
  }

  Widget _buildContenido(ContactoController controlX) {
    return SafeArea(
      child: Center(
        child: ElevatedButton(
          child: Text('Llamar Api'),
          onPressed: () {
            // controlX.traerDireccion();
            // Get.offNamed(AppRoutes.PRUEBA);
            Helpers.snackbar(title: 'Holaa');
          },
        ),
      ),
    );
  }
}
