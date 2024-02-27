import 'package:app_pasajero_ns/modules/app_prefs/app_prefs_controller.dart';
import 'package:app_pasajero_ns/modules/perfil/inicio/perfil_inicio_controller.dart';
import 'package:app_pasajero_ns/themes/ak_ui.dart';
import 'package:app_pasajero_ns/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PerfilInicioPage extends StatelessWidget {
  final _conX = Get.put(PerfilInicioController());
  final _appX = Get.find<AppPrefsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SliverContainer<PerfilInicioController>(
        gbAppbarId: _conX.gbAppbar,
        scrollController: _conX.scrollController,
        type: _appX.type,
        title: 'Mis datos',
        subtitle: 'Datos personales del usuario',
        children: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: Column(
                      children: [
                        AkText('initio'),
                        AkText('ya'),
                      ],
                    ),
                  ),
                ),
                AkText('fin asdf asdf asdf sfd'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
