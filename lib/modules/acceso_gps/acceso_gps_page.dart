import 'package:app_pasajero_ns/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class AccesoGpsPage extends StatefulWidget {
  @override
  _AccesoGpsPageState createState() => _AccesoGpsPageState();
}

class _AccesoGpsPageState extends State<AccesoGpsPage>
    with WidgetsBindingObserver {
  bool popup = false;

  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed && !popup) {
      if (await Permission.location.isGranted) {
        // Navigator.pushReplacementNamed(context, 'loading');
        print('Redireccionar a Home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Es necesario el GPS para usar esta app'),
            MaterialButton(
                child: Text(
                  'Solicitar Acceso',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.black,
                shape: StadiumBorder(),
                elevation: 0,
                splashColor: Colors.transparent,
                onPressed: () async {
                  popup = true;
                  try {
                    final status = await Permission.location.request();
                    await this.accesoGPS(status);
                  } catch (e) {
                    Helpers.logger.e(
                        'Hubo un error al solicitar el permiso ${e.toString()}');
                  }
                  popup = false;
                })
          ],
        ),
      ),
    );
  }

  Future accesoGPS(PermissionStatus status) async {
    switch (status) {
      case PermissionStatus.granted:
        // await Navigator.pushReplacementNamed(context, 'loading');
        // todo: IR A LA PÁGINA O HACER UN BACK
        break;
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.permanentlyDenied:
      case PermissionStatus.limited:
        openAppSettings();
      case PermissionStatus.provisional:
        // TODO: Handle this case.
    }
  }
}
