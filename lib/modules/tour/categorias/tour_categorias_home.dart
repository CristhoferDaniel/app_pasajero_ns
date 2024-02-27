import 'package:app_pasajero_ns/modules/tour/buscar/tour_buscar_page.dart';
import 'package:app_pasajero_ns/modules/tour/categorias/tour_categorias_home_controller.dart';
import 'package:app_pasajero_ns/themes/ak_ui.dart';
import 'package:app_pasajero_ns/utils/utils.dart';
import 'package:app_pasajero_ns/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TourCategoriasHomePage extends StatelessWidget {
  final int tabIndex;
  TourCategoriasHomePage({required this.tabIndex});

  final _conX = Get.put(TourCategoriasHomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categorías'),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            size: akDefaultGutterSize + 10.0,
          ),
        ),
      ),
      body: GetBuilder<TourCategoriasHomeController>(
        builder: (_) {
          if (_conX.loading) {
            return Center(child: SpinLoadingIcon(color: akPrimaryColor));
          }

          if (_conX.existsError) {
            return AppError(
              message: _conX.errorMessage,
              onRetry: _conX.fetchData,
            );
          }

          return SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: _buildContent(),
          );
        },
      ),
    );
  }

  Widget _buildContent() {
    List<Widget> items = [];

    _conX.lista.forEach((e) {
      String title =
          Helpers.capitalizeFirstLetter(e.nombre?.toLowerCase() ?? '');
      items.add(_buildItem(Icons.home_work_outlined, title));
    });

    Widget cardPrincipal = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Column(
          children: [
            SizedBox(height: 10.0),
            _buildContainer(
              child: GestureDetector(
                onTap: () {
                  Get.to(() => TourBuscarPage(),
                      transition: Transition.cupertino);
                },
                child: AbsorbPointer(
                  absorbing: true,
                  child: AkInput(
                    hintText: '¿Qué estás buscando?',
                    type: AkInputType.noborder,
                    borderRadius: 30.0,
                  ),
                ),
              ),
            ),
            ...items,
          ],
        ),
      ],
    );

    return cardPrincipal;
  }

  Widget _buildContainer({required Widget child}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: akContentPadding),
      child: child,
    );
  }

  Widget _buildItem(IconData iconData, String text) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          /* Get.toNamed(TourCategoriasRoutes.DETALLE_ITEM,
              id: tabIndex, arguments: tabIndex); */
          print('Mostrar resultados por categoría');
        },
        child: _buildContainer(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Row(
              children: [
                Container(
                  width: 40.0,
                  alignment: Alignment.centerLeft,
                  child: Icon(
                    iconData,
                    color: Colors.grey.withOpacity(.5),
                    size: 25,
                  ),
                ),
                AkText('$text'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
