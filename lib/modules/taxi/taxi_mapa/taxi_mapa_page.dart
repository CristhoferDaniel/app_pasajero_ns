import 'package:animate_do/animate_do.dart';
import 'package:app_pasajero_ns/data/models/concepto.dart';
import 'package:app_pasajero_ns/data/models/google_suggestion_response.dart';
import 'package:app_pasajero_ns/modules/taxi/taxi_mapa/components/adondevamos/layer_adondevamos_ctlr.dart';
import 'package:app_pasajero_ns/modules/taxi/taxi_mapa/components/buscar/layer_buscar_ctlr.dart';
import 'package:app_pasajero_ns/modules/taxi/taxi_mapa/components/buscar/widget/prediction_item_list.dart';
import 'package:app_pasajero_ns/modules/taxi/taxi_mapa/components/pickup/layer_pickup_cltr.dart';
import 'package:app_pasajero_ns/modules/taxi/taxi_mapa/components/programado/layer_programado_ctlr.dart';
import 'package:app_pasajero_ns/modules/taxi/taxi_mapa/components/reserva/layer_reserva_ctlr.dart';
import 'package:app_pasajero_ns/modules/taxi/taxi_mapa/components/solicitando/layer_solicitando_ctlr.dart';
import 'package:app_pasajero_ns/modules/taxi/taxi_mapa/components/tarifa/layer_tarifa_ctlr.dart';
import 'package:app_pasajero_ns/modules/taxi/taxi_mapa/taxi_mapa_controller.dart';
import 'package:app_pasajero_ns/themes/ak_ui.dart';
import 'package:app_pasajero_ns/utils/utils.dart';
import 'package:app_pasajero_ns/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

part 'components/adondevamos/layer_adondevamos.dart';
part 'components/buscar/layer_buscar.dart';
part 'components/calculando/layer_calculando.dart';
part 'components/pickup/layer_pickup.dart';
part 'components/programado/layer_programado.dart';
part 'components/reserva/layer_reserva.dart';
part 'components/solicitando/layer_solicitando.dart';
part 'components/tarifa/layer_tarifa.dart';

class TaxiMapaPage extends StatelessWidget {
  final _conX = Get.put(TaxiMapaController());
  final temp = Get.put(LayerAdondeVamosCtlr());
  final temp2 = Get.put(LayerReservaCtlr());

  static final cardShadows = [
    BoxShadow(
      color: Color(0xFF8D8B8B).withOpacity(.4),
      blurRadius: 8,
      offset: Offset(0, -4),
    )
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await _conX.handleBack();
      },
      child: ScaffoldMessenger(
        key: _conX.smKey,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              _buildMapa(),
              _buildMarkers(),
              Obx(() {
                Widget widget = SizedBox();
                switch (_conX.modoVista.value) {
                  case ModoVista.adondevamos:
                    widget = _LayerAdondeVamos();
                    break;
                  case ModoVista.reserva:
                    widget = _LayerReserva();
                    break;
                  case ModoVista.searchaddress:
                    widget = LayerBuscar();
                    break;
                  case ModoVista.tarifa:
                    widget = _LayerTarifa();
                    break;
                  case ModoVista.pickup:
                    widget = _LayerPickup();
                    break;
                  case ModoVista.calculando:
                    widget = _LayerCalculando(taxiX: _conX);
                    break;
                  case ModoVista.solicitando:
                    widget = _LayerSolicitando();
                    break;
                  case ModoVista.programado:
                    widget = _LayerProgramado();
                    break;
                }
                return AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  switchInCurve: Curves.easeInOut,
                  switchOutCurve: Curves.easeInOut,
                  child: widget,
                );
              }),
              _buildPlaceHolder(),
              _buildAppBar(),
              const StatusBarCurve(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMarkers() {
    return GetBuilder<TaxiMapaController>(
      id: _conX.gbMarkers,
      builder: (_) {
        return Transform.translate(
          offset: Offset(-Get.width, -Get.height),
          // offset: Offset(100, 100),
          child: Column(
            children: [
              RepaintBoundary(
                key: _conX.markerOrigenKey,
                child: PopupMarker(
                    origin: true, streetName: _conX.tarifaOrigenName),
              ),
              RepaintBoundary(
                key: _conX.markerDestinoKey,
                child: PopupMarker(
                    origin: false, streetName: _conX.tarifaDestinoName),
              ),
              RepaintBoundary(
                key: _conX.markerPickupKey,
                child: PopupMarker(
                  origin: true,
                  onlyDot: true,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAppBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: AppBar(
        backgroundColor: akAccentColor,
        toolbarHeight: 0,
        // brightness: Brightness.light,
      ),
    );
  }

  Widget _buildMapa() {
    return GetBuilder<TaxiMapaController>(
      id: _conX.gbOnlyMap,
      builder: (_) {
        return _conX.existsPosition
            ? GoogleMap(
                padding: _conX.mapInsetPadding,
                initialCameraPosition: _conX.initialPosition!,
                mapType: MapType.normal,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                compassEnabled: false,
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
                tiltGesturesEnabled: false,
                markers: _conX.markers,
                polylines: _conX.polylines,
                onMapCreated: _conX.onMapCreated,
                onCameraMove: _conX.onMapMoving,
                onCameraIdle: _conX.onMapStopCamera,
              )
            : SizedBox();
      },
    );
  }

  Widget _buildPlaceHolder() {
    return Obx(() => AnimatedOpacity(
          duration: Duration(milliseconds: 300),
          opacity: _conX.isLocalizando.value ? 1 : 0,
          child: MapPlaceholder(ignorePoint: !_conX.isLocalizando.value),
        ));
  }
}
