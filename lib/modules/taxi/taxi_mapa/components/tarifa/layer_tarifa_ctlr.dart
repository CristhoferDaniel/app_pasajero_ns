import 'dart:async';

import 'package:app_pasajero_ns/data/models/concepto.dart';
import 'package:app_pasajero_ns/modules/taxi/taxi_mapa/components/currency/layer_currency.dart';
import 'package:app_pasajero_ns/modules/taxi/taxi_mapa/taxi_mapa_controller.dart';
import 'package:app_pasajero_ns/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class LayerTarifaCtlr extends GetxController {
  final taxiMapaX = Get.find<TaxiMapaController>();

  @override
  void onInit() {
    super.onInit();

    if (taxiMapaX.typeService == ServiceType.regular) {
      scrollController = ScrollController();

      final maxDisplay = 3;
      slotsDisplayed = taxiMapaX.tarifas.length <= maxDisplay
          ? taxiMapaX.tarifas.length
          : maxDisplay;
      viewPortHeight = itemHeight * slotsDisplayed;

      if (taxiMapaX.tarifas.length > slotsDisplayed) {
        showMoreItems = true;
        headerSpaceAprox = 47.0;
      }

      panelHeightClosed = (itemHeight * slotsDisplayed) + headerSpaceAprox;

      WidgetsBinding.instance?.addPostFrameCallback((_) {
        onTarifaItemTap(taxiMapaX.tarifaSelected);
      });
    }
  }

  Future<void> onReservaOSolicitarTaxiTap() async {
    if (taxiMapaX.loading.value) return;

    taxiMapaX.loading.value = true;
    await Helpers.sleep(600);
    taxiMapaX.loading.value = false;

    taxiMapaX.resetPickUpVariables();

    // TODO: ELIMINAR ESTA LÍNEA
    // await taxiMapaX.cambiarModoVista(ModoVista.solicitando);
    // return;

    // Helpers.logger.wtf(taxiMapaX.confirmedPickup);
    // Helpers.logger.wtf(taxiMapaX.typeService);

    if (!taxiMapaX.confirmedPickup) {
      if (taxiMapaX.typeService == ServiceType.reservation) {
        taxiMapaX.setupReservaLogic();
      } else {
        await taxiMapaX.cambiarModoVista(ModoVista.solicitando);
      }
    } else {
      await taxiMapaX.cambiarModoVista(ModoVista.pickup);
    }
  }

  void goToCurrencyPage() {
    Get.to(
      () => LayerCurrency(),
      transition: Transition.cupertino,
    );
  }

  // ********* TARIFA *********/
  late ScrollController scrollController;
  final panelController = PanelController();

  final gbPanelTarifa = 'gbPanelTarifa';

  double panelHeightOpen = 0;
  double panelHeightClosed = 200.0;

  bool panelHidden = true;

  double itemHeight = 80.0;
  double headerSpaceAprox = 25.0;
  double footerSpace = 138.0;
  int slotsDisplayed = 0;
  double viewPortHeight = 0.0;
  bool showMoreItems = false;

  /* List<SCTarifa> lista = [];
  int selected = 10; */

  void onPanelSlide(double pos) {
    // Condicional para evitar rebuilds innecesarios
    if (!panelHidden) return;
    panelHidden = false;
    update([gbPanelTarifa]);
  }

  void onPanelClosed() {
    panelHidden = true;
    update([gbPanelTarifa]);

    final int i = taxiMapaX.tarifas.indexWhere(
        (e) => e.idTipoVehiculo == taxiMapaX.tarifaSelected.idTipoVehiculo);
    double positionSelected = itemHeight * i;

    if (positionSelected >= viewPortHeight) {
      final postToLastVP = itemHeight * (i - slotsDisplayed + 1);
      scrollController.animateTo(postToLastVP,
          curve: Curves.easeInOut, duration: Duration(milliseconds: 150));
    } else {
      scrollController.jumpTo(0);
    }
  }

  void onTarifaItemTap(SCTarifa selectItem) {
    taxiMapaX.tarifaSelected = selectItem;
    panelController.close();
  }
}
