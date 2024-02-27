import 'package:app_pasajero_ns/modules/tour/categorias/tour_categorias_home.dart';
import 'package:app_pasajero_ns/modules/tour/categorias/tour_categorias_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TourCategoriasTab extends StatefulWidget {
  final GlobalKey navigatorKey;
  final int tabIndex;

  TourCategoriasTab({required this.navigatorKey, required this.tabIndex});

  @override
  _TourCategoriasTabState createState() => _TourCategoriasTabState();
}

class _TourCategoriasTabState extends State<TourCategoriasTab>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Navigator(
      key: widget.navigatorKey,
      initialRoute: TourCategoriasRoutes.HOME,
      onGenerateRoute: (settings) {
        if (settings.name == TourCategoriasRoutes.HOME) {
          return GetPageRoute(
            page: () => TourCategoriasHomePage(tabIndex: widget.tabIndex),
            transition: Transition.cupertino,
          );
        }
        /* else if (settings.name == TourCategoriasRoutes.DETALLE_ITEM) {
          return GetPageRoute(
            page: () => TourDetalleItem(tabIndex: settings.arguments as int),
            transition: Transition.cupertino,
          );
        } */
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
