import 'package:app_pasajero_ns/data/models/concepto.dart';
import 'package:app_pasajero_ns/data/models/driving_request_param.dart';
import 'package:app_pasajero_ns/data/models/google_driving_response.dart';
import 'package:app_pasajero_ns/data/providers/concepto_provider.dart';
import 'package:app_pasajero_ns/data/services/routing_service.dart';
import 'package:app_pasajero_ns/modules/taxi/taxi_mapa/taxi_mapa_controller.dart';
import 'package:app_pasajero_ns/modules/taxi/taxi_mapa/taxi_mapa_page.dart';
import 'package:app_pasajero_ns/utils/utils.dart';
import 'package:app_pasajero_ns/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class LayerPickupCtlr extends GetxController {
  final taxiMapaX = Get.find<TaxiMapaController>();

  final _routing = RoutingService();
  final _conceptoProvider = ConceptoProvider();

  @override
  void onInit() {
    super.onInit();
  }

  //final showPickUpActionButton = true.obs;
  Future<void> onConfirmPickUp() async {
    if (taxiMapaX.searchingAddressFromPick.value) return;

    if (taxiMapaX.lastPositionOnMoving != null) {
      taxiMapaX.confirmedPickup = true;
      // En este pusto ya existe tarifaOrigenCoords
      final distanceNewPickUp = Geolocator.distanceBetween(
          taxiMapaX.lastPositionOnMoving!.latitude,
          taxiMapaX.lastPositionOnMoving!.longitude,
          taxiMapaX.tarifaOrigenCoords!.latitude,
          taxiMapaX.tarifaOrigenCoords!.longitude);
      print('DistanceNewPickUp: $distanceNewPickUp');
      // Si la confirmación del punto de partida se movío X metros.
      // Realizar un nuevo cálculo de la ruta y de la tarifa
      if (distanceNewPickUp >= 30) {
        print('Obtener una nueva ruta');

        taxiMapaX.showPickupMarker(true,
            coords: LatLng(taxiMapaX.lastPositionOnMoving!.latitude,
                taxiMapaX.lastPositionOnMoving!.longitude));

        GoogleDrivingResponse? routeResp;
        ConceptoSimulacionCliente? priceResp;
        double? oldCost;

        final calcSuccess = await tryCatch(
          code: () async {
            taxiMapaX.recalculating.value = true;
            await taxiMapaX.cambiarModoVista(ModoVista.calculando);
            final _paramOrigen = DrivingRequestParams(
              coords: taxiMapaX.lastPositionOnMoving,
              placeId: null,
            );
            final _paramDestino = DrivingRequestParams(
              coords: taxiMapaX.savedDestinoCoords,
              placeId: taxiMapaX.savedDestinoPlaceId,
            );

            routeResp =
                await _routing.calculateRoute(_paramOrigen, _paramDestino);
            await Helpers.sleep(2000);

            final route = routeResp!.routes.first;
            final tramo = route.legs.first;
            priceResp = await _conceptoProvider.simulacionCliente(
                metros: tramo.distance.value, segundos: tramo.duration.value);

            if (!(priceResp!.success) || priceResp!.data.data.isEmpty) {
              throw BusinessException('No se pudo obtener la nueva tarifa');
            }

            oldCost = double.parse(taxiMapaX.tarifaSelected.precioCalculado);
            taxiMapaX.setTarifaVariables(
              routeResp!,
              priceResp!,
              hasUserSelected: true,
            );
          },
          onCancelRetry: () async {
            taxiMapaX.recalculating.value = false;
            await taxiMapaX.cambiarModoVista(ModoVista.pickup);
          },
        );

        if (taxiMapaX.typeService == ServiceType.reservation) {
          print('Es una reserva - Continúa el flujo');
          taxiMapaX.whenPriceAndPositionConfirmed();
          return;
        }

        if (calcSuccess) {
          taxiMapaX.recalculating.value = false;

          final newCost =
              double.parse(taxiMapaX.tarifaSelected.precioCalculado);
          print('oldCost $oldCost');
          print('newCost $newCost');
          if ((newCost - oldCost!) >= 0.30) {
            final isNewPriceAccepted =
                await _showModalNewPrice(newCost.toStringAsFixed(2));
            if (isNewPriceAccepted) {
              print(
                  'Diferente punto - Usuario aceptó nueva tarifa - Solicitando conductores');
              taxiMapaX.whenPriceAndPositionConfirmed();
            } else {
              taxiMapaX.confirmedPickup = false;
              print('Diferente punto - Rechazó tarifa');
              await taxiMapaX.cambiarModoVista(ModoVista.pickup);
            }
          } else {
            print(
                'Diferente punto - Tarifa no sobrepasó por mucho al anterior - Solicitando conductores');
            taxiMapaX.whenPriceAndPositionConfirmed();
          }
        }
      } else {
        // En este punto, el punto de confirmación es el mismo punto
        // que el establecido en la primera parte.
        print('Mismo punto');
        taxiMapaX.whenPriceAndPositionConfirmed();
      }
    } else {
      AppSnackbar()
          .basic(message: 'Mueva el mapa para confirmar el punto de recogida.');
    }
  }

  Future<bool> _showModalNewPrice(String amount) async {
    taxiMapaX.enableBackRecalculating.value = true;
    final resp = await showMaterialModalBottomSheet(
      context: Get.overlayContext!,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      builder: (context) => CardNewPrice(
        amount: amount,
        onConfirmTap: () => Get.back(result: true),
      ),
    );
    taxiMapaX.enableBackRecalculating.value = false;
    taxiMapaX.showPickupMarker(false);
    return resp ?? false;
  }
}
