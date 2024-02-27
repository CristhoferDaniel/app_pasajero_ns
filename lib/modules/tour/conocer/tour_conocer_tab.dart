import 'package:app_pasajero_ns/modules/tour/conocer/tour_conocer_home.dart';
import 'package:app_pasajero_ns/modules/tour/conocer/tour_conocer_routes.dart';
import 'package:app_pasajero_ns/modules/tour/detalle_lugar/tour_detalle_item.dart';
import 'package:app_pasajero_ns/modules/tour/detalle_lugar/tour_detalle_item_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TourConocerTab extends StatefulWidget {
  final GlobalKey navigatorKey;
  final int tabIndex;

  TourConocerTab({required this.navigatorKey, required this.tabIndex});

  @override
  _TourConocerTabState createState() => _TourConocerTabState();
}

class _TourConocerTabState extends State<TourConocerTab>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Navigator(
      key: widget.navigatorKey,
      initialRoute: TourConocerRoutes.HOME,
      onGenerateRoute: (settings) {
        if (settings.name == TourConocerRoutes.HOME) {
          return GetPageRoute(
              page: () => TourConocerHome(tabIndex: widget.tabIndex));
        } else if (settings.name == TourConocerRoutes.DETALLE_ITEM) {
          return GetPageRoute(
            page: () => TourDetalleItem(
              arguments: settings.arguments as TourDetalleItemArguments,
            ),
            transition: Transition.cupertino,
          );
        }
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
