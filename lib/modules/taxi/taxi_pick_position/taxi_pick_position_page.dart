/* import 'package:animate_do/animate_do.dart';
import 'package:app_pasajero_ns/modules/taxi/taxi_mapa/taxi_mapa_controller.dart';
import 'package:app_pasajero_ns/modules/taxi/taxi_pick_position/taxi_pick_position_controller.dart';
import 'package:app_pasajero_ns/themes/ak_ui.dart';
import 'package:app_pasajero_ns/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TaxiPickPositionPage extends StatelessWidget {
  final TaxiPickPositionController _conX;

  TaxiPickPositionPage(this._conX, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return WillPopScope(
    //   onWillPop: () async {
    //     return await loginBack();
    //   },
    //   child: Scaffold(
    //     resizeToAvoidBottomInset: false,
    //     // appBar: _buildAppBar(),
    //     body: Stack(
    //       children: [
    //         _buildMapa(),
    //         _buildAppBar(),
    //         _buildPlaceHolder(),
    //         _LayerManualPicker(conX: _conX),
    //         const StatusBarCurve(),
    //       ],
    //     ),
    //   ),
    // ); 
    return Stack(
      children: [
        _buildMapa(),
        _buildAppBar(),
        _buildPlaceHolder(),
        _LayerManualPicker(conX: _conX),
        const StatusBarCurve(),
      ],
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
    return GetBuilder<TaxiPickPositionController>(
      id: 'gbMapPicker',
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
                markers: _conX.markers.values.toSet(),
                onMapCreated: _conX.onMapCreated,
                onCameraMove: _conX.onMapMoving,
                onCameraIdle: _conX.onMapStopCamera,
              )
            : SizedBox();
      },
    );
  }

  Widget _buildPlaceHolder() {
    return Obx(
      () => AnimatedOpacity(
        duration: Duration(milliseconds: 300),
        opacity: _conX.isLocalizando.value ? 1 : 0,
        child: MapPlaceholder(
          ignorePoint: !_conX.isLocalizando.value,
          hideLocalizando: true,
        ),
      ),
    );
  }
}

class _LayerManualPicker extends StatelessWidget {
  final TaxiPickPositionController conX;

  const _LayerManualPicker({required this.conX});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          child: _buildMarkerCentral(),
        ),
        _getMarcadorActions(),
        Container(
          padding: EdgeInsets.all(akContentPadding),
          child: SafeArea(
            child: CommonButtonMap(
              icon: Icons.arrow_back_rounded,
              onTap: conX.onBackTap,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMarkerCentral() {
    return Obx(
      () => Center(
        child: Transform.translate(
          offset: Offset(0, -115),
          child: SlideInDown(
            from: 100,
            duration: Duration(milliseconds: 200),
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 200),
              switchInCurve: Curves.easeInOut,
              switchOutCurve: Curves.easeInOut,
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(child: child, scale: animation);
              },
              child: !conX.moviendoMapa.value
                  ? BadgeMapPin(
                      key: ValueKey<String>('mark1'),
                      moving: conX.moviendoMapa.value,
                    )
                  : BadgeMapPin(
                      key: ValueKey<String>('mark2'),
                      moving: conX.moviendoMapa.value,
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getMarcadorActions() {
    final _title = conX.busquedaView == BusquedaView.destino
        ? 'lugar de destino'
        : 'punto de origen';
    Widget actions = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 2.0),
        AkText(
          'Fijar $_title',
          type: AkTextType.h7,
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 12.0),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(akIptFactorPadding * akFontSize),
                decoration: BoxDecoration(
                    color: Color(0xFFF5F6FA),
                    borderRadius: BorderRadius.circular(akIptBorderRadius)),
                child: Row(
                  children: [
                    Expanded(
                      child: Obx(
                        () => AkText(
                          conX.streetName.value,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Icon(
                      Icons.search,
                      color: akTextColor.withOpacity(.5),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 7.0),
        Obx(() => AkButton(
              fluid: true,
              enableMargin: false,
              text: conX.busquedaView == BusquedaView.destino
                  ? 'Llegar aquí'
                  : 'Recoger aquí',
              onlyIcon: conX.manualLoading.value
                  ? Center(
                      child: SpinLoadingIcon(
                        size: 20.0,
                      ),
                    )
                  : null,
              onPressed: conX.confirmarPuntoMarcador,
            ))
      ],
    );

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    right: akContentPadding, bottom: akContentPadding * 0.5),
                child: CommonButtonMap(
                  icon: Icons.my_location,
                  onTap: conX.centrarMapaOrigen,
                ),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(akCardBorderRadius * 1.5),
                topRight: Radius.circular(akCardBorderRadius * 1.5),
              ),
            ),
            width: double.infinity,
            padding: EdgeInsets.all(akContentPadding),
            child: Obx(() => AbsorbPointer(
                  absorbing: conX.manualLoading.value,
                  child: actions,
                )),
          ),
        ],
      ),
    );
  }
}
*/