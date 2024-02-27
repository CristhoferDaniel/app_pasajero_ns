import 'dart:convert';

import 'package:app_pasajero_ns/data/models/favorito.dart';
import 'package:app_pasajero_ns/modules/taxi/taxi_mapa/taxi_mapa_controller.dart';
import 'package:app_pasajero_ns/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  // Drawer
  final drawerKey = GlobalKey<ScaffoldState>();
  final enableMenuAction = true.obs;

  final List<LastPlaces> lastPlaces = [];
  final List<TopTourPlaces> tourList = [];

  @override
  void onInit() {
    super.onInit();

    _getLastPlaces();
    _getListTour();
  }

  Future<void> _getLastPlaces() async {
    final lp1 = LastPlaces(
        title: 'Estación Bayovar',
        subTitle:
            'Avenida Fernando de Wiese, San Juan de Lurigancho, Lima - Perú');
    for (var i = 0; i < 3; i++) {
      lastPlaces.add(lp1);
    }

    update(['gbLastList']);
  }

  Future<void> _getListTour() async {
    final String favoritesString =
        await rootBundle.loadString('assets/data/favorites.json');

    final resp = (jsonDecode(favoritesString) as List)
        .map((e) => Favorito.fromJson(e))
        .toList();
    resp.forEach((p) {
      tourList.add(TopTourPlaces(
          title: p.name ?? '',
          subTitle: p.description ?? '',
          photoUrl: p.portadaImg ?? ''));
    });

    update(['gbTourList']);
  }

  void goToTaxiService() async {
    await Get.delete<TaxiMapaController>();
    Get.toNamed(
      AppRoutes.TAXI_MAPA,
      arguments: TaxiMapaArguments(type: ServiceType.regular),
    );

    // Get.toNamed(AppRoutes.PRUEBA);
  }

  void goToTourService() async {
    Get.toNamed(AppRoutes.TOUR_TABS_WRAPPER);
  }

  void goToReservaService() async {
    Get.toNamed(
      AppRoutes.TAXI_MAPA,
      arguments: TaxiMapaArguments(type: ServiceType.reservation),
    );
  }

  void openDrawer() {
    drawerKey.currentState?.openDrawer();
  }
}

class LastPlaces {
  final String title;
  final String subTitle;

  LastPlaces({required this.title, required this.subTitle});
}

class TopTourPlaces extends LastPlaces {
  final String photoUrl;

  TopTourPlaces({
    required String title,
    required String subTitle,
    required this.photoUrl,
  }) : super(title: title, subTitle: subTitle);
}
