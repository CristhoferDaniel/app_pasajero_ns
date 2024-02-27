import 'dart:io';

import 'package:app_pasajero_ns/config/config.dart';
import 'package:app_pasajero_ns/modules/mis_viajes/detalle/mis_viajes_detalle_controller.dart';
import 'package:app_pasajero_ns/modules/mis_viajes/mis_viajes_page.dart';
import 'package:app_pasajero_ns/themes/ak_ui.dart';
import 'package:app_pasajero_ns/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MisViajesDetallePage extends StatelessWidget {
  final _conX = Get.put(MisViajesDetalleController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: akPrimaryColor),
        title: Text(
          'Detalles del viaje',
          style: TextStyle(color: akPrimaryColor),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Stack(
          children: [
            Container(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        child: AspectRatio(
                          aspectRatio: 5 / 5,
                          child: Container(
                            child: Obx(
                              () => _conX.delayingMap.value
                                  ? SizedBox()
                                  : _buildMapa(),
                            ),
                            width: double.infinity,
                          ),
                        ),
                      ),
                      // _buildShadowMap(),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: _buildShadowMap(reflect: true),
                      ),
                      /* Positioned.fill(
                            child: Center(
                              child: _MarkerAnimated(),
                            ),
                          ), */
                      Positioned.fill(
                        child: Obx(() => AnimatedSwitcher(
                              duration: Duration(milliseconds: 300),
                              child: _conX.showOverlayLoadingMap.value
                                  ? _OverlayLoadingMap()
                                  : Container(),
                            )),
                      )
                    ],
                  ),
                  SizedBox(height: 15.0),
                  Content(
                    child: Row(
                      children: [
                        LabelTypeDetalleViaje(
                          isReserva: _conX.data?.idTipoServicio ==
                              Config.ID_TIPO_SERVICIO_TURISTICO,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15.0),
                  InfoRuta(
                    showTitle: false,
                    fechaReserva: _conX.data?.fechaSalida,
                    origenName: _conX.data?.ruta?.nombreOrigen ?? '',
                    destinoName: _conX.data?.ruta?.nombreDestino ?? '',
                  ),
                ],
              ),
            ),
            _buildMarkers(),
          ],
        ),
      ),
    );
  }

  Widget _buildShadowMap({bool reflect = false}) {
    final colors = [
      akScaffoldBackgroundColor,
      akScaffoldBackgroundColor,
      akScaffoldBackgroundColor.withOpacity(.5),
      akScaffoldBackgroundColor.withOpacity(0),
    ];

    Widget shadow = Container(
      width: double.infinity,
      height: 50.0,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: reflect ? colors.reversed.toList() : colors,
        ),
      ),
    );

    return shadow;
  }

  Widget _buildMapa() {
    return GetBuilder<MisViajesDetalleController>(
      id: _conX.gbOnlyMap,
      builder: (_) {
        return _conX.existsPosition
            ? IgnorePointer(
                child: GoogleMap(
                  liteModeEnabled: Platform.isAndroid,
                  padding: _conX.mapInsetPadding,
                  initialCameraPosition: _conX.initialPosition,
                  mapType: MapType.normal,
                  myLocationEnabled: false,
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

  Widget _buildMarkers() {
    return GetBuilder<MisViajesDetalleController>(
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
                  origin: true,
                  onlyDot: true,
                ),
              ),
              RepaintBoundary(
                key: _conX.markerDestinoKey,
                child: PopupMarker(
                  origin: false,
                  onlyDot: true,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _OverlayLoadingMap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: akScaffoldBackgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SpinLoadingIcon(
            color: akPrimaryColor,
            size: akFontSize + 2.0,
          ),
          SizedBox(
            height: 10.0,
          ),
          AkText(
            'Cargando...',
            style: TextStyle(
              color: akPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
