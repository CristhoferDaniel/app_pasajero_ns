import 'package:animate_do/animate_do.dart';
import 'package:app_pasajero_ns/data/providers/travel_info_provider.dart';
import 'package:app_pasajero_ns/modules/auth/auth_controller.dart';
import 'package:app_pasajero_ns/modules/taxi/taxi_mapa/taxi_mapa_page.dart';
import 'package:app_pasajero_ns/modules/taxi/taxi_travel/components/driver_info_tile.dart';
import 'package:app_pasajero_ns/modules/taxi/taxi_travel/taxi_travel_controller.dart';
import 'package:app_pasajero_ns/routes/app_pages.dart';
import 'package:app_pasajero_ns/themes/ak_ui.dart';
import 'package:app_pasajero_ns/utils/utils.dart';
import 'package:app_pasajero_ns/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

part 'components/layer_viajando.dart';

class TaxiTravelPage extends StatelessWidget {
  final _conX = Get.put(TaxiTravelController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await _conX.handleBack(context);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            _buildMapa(),
            _buildLayer(),
            _buildAppBar(),
            const StatusBarCurve(),
            _buildPlacerHolder(),
            _buildMarkers(),
            Positioned(top: 40, left: 15, child: _iconGoogleMaps()),
          ],
        ),
      ),
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
    return GetBuilder<TaxiTravelController>(
      id: 'gbOnlyMap',
      builder: (_) {
        return _conX.existsPosition
            ? Listener(
                onPointerDown: _conX.onUserStartMoveMap,
                child: GoogleMap(
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
                  minMaxZoomPreference: MinMaxZoomPreference(1, 19),
                ),
              )
            : SizedBox();
      },
    );
  }

  Widget _buildLayer() {
    return Obx(() {
      Widget widget = SizedBox();
      switch (_conX.modoVista.value) {
        case TravelView.viajando:
          widget = _LayerViajando(conX: _conX);
          break;
      }
      return AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeInOut,
        child: widget,
      );
    });
  }

  Widget _buildPlacerHolder() {
    Widget layer = Stack(
      children: [
        Container(color: akAccentColor),
        Opacity(
          opacity: .6,
          child: Container(
            decoration: BoxDecoration(
              color: akAccentColor,
              image: DecorationImage(
                image: AssetImage("assets/img/street_map_pattern.png"),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(akContentPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(Get.width * 0.03),
                decoration: BoxDecoration(
                  color: Helpers.darken(akAccentColor, 0.075),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: PulseAnimationCustom(
                  infinite: true,
                  child: RadarIcon(origin: false, pSize: Get.width * 0.20),
                  maxZoom: 1.2,
                ),
              ),
              SizedBox(height: 20.0),
              AkText(
                'Taxi encontrado!', // .toUpperCase(),
                type: AkTextType.h6,
                style: TextStyle(color: akPrimaryColor),
              ),
              SizedBox(height: 15.0),
              AkText(
                'Iniciando viaje...',
                type: AkTextType.h9,
                style: TextStyle(
                  color: akTextColor.withOpacity(.45),
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ],
    );

    return Obx(
      () => AnimatedSwitcher(
        duration: Duration(milliseconds: 400),
        child: _conX.isLocalizando.value ? layer : SizedBox(),
      ),
    );
  }

  Widget _buildMarkers() {
    return GetBuilder<TaxiTravelController>(
      id: 'gbMarkers',
      builder: (_) {
        return Transform.translate(
          offset: Offset(-Get.width, -Get.height),
          child: Column(
            children: [
              RepaintBoundary(
                key: _conX.markerOrigenKey,
                child: PopupMarker(
                  origin: true,
                  streetName: 'Partida',
                  mini: true,
                ),
              ),
              RepaintBoundary(
                key: _conX.markerDestinoKey,
                child: PopupMarker(
                  origin: false,
                  streetName: 'Destino',
                  mini: true,
                ),
              ),
              RepaintBoundary(
                key: _conX.markerDriverKey,
                child: Image.asset(
                  'assets/img/car_1_grey.png',
                  width: 18.0,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _iconGoogleMaps() {
    return GestureDetector(
      onTap: _conX.sendPosition,
      child: Icon(Icons.share),
    );
  }
}
