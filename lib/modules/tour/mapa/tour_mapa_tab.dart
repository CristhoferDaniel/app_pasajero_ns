import 'package:app_pasajero_ns/modules/tour/mapa/tour_mapa_home.dart';
import 'package:app_pasajero_ns/modules/tour/mapa/tour_mapa_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TourMapaTab extends StatefulWidget {
  final GlobalKey navigatorKey;
  final int index;

  TourMapaTab({required this.navigatorKey, required this.index});

  @override
  _TourMapaTabState createState() => _TourMapaTabState();
}

class _TourMapaTabState extends State<TourMapaTab>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Navigator(
      key: widget.navigatorKey,
      initialRoute: TourMapaRoutes.HOME,
      onGenerateRoute: (settings) {
        if (settings.name == TourMapaRoutes.HOME) {
          return GetPageRoute(page: () => TourMapaHomePage());
        }
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
