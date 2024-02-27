part of '../../taxi_mapa_page.dart';

class _LayerSolicitando extends StatelessWidget {
  final _layerX = Get.find<LayerSolicitandoCtlr>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // _getBottomActions(),
        _getBuilderPanel(context),
        // ButtonBackMap(onPressed: taxiX.handleBack),
      ],
    );
  }

  Widget _getBuilderPanel(BuildContext context) {
    // Reset variables. Important!
    _layerX.panelHeightUpdated = false;
    _layerX.heightFromWidgets = false;

    return GetBuilder<TaxiMapaController>(
        id: _layerX.gbSlidePanel,
        builder: (_) {
          return SlidingUpPanel(
            boxShadow: TaxiMapaPage.cardShadows,
            maxHeight: _layerX.panelHeightOpen,
            minHeight: _layerX.panelHeightClosed,
            backdropEnabled: true,
            backdropOpacity: .15,
            panelBuilder: (sc) => _buildPanelCard(sc, context),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0)),
            onPanelSlide: (double pos) {
              _layerX.updatePanelMaxHeight();
            },
          );
        });
  }

  Widget _buildPanelCard(ScrollController sc, BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: Column(
        children: [
          _buildPanelTitle(),
          Expanded(
            child: SingleChildScrollView(
              physics: _layerX.heightFromWidgets
                  ? NeverScrollableScrollPhysics()
                  : BouncingScrollPhysics(),
              controller: sc,
              child: _buildPanelBody(),
            ),
          ),
        ],
      ),
    );
  }

  RepaintBoundary _buildPanelTitle() {
    return RepaintBoundary(
      key: _layerX.panelTitleKey,
      child: Column(children: [
        SizedBox(
          height: 8.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 35,
              height: 4.5,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.all(Radius.circular(12.0))),
            ),
          ],
        ),
        Stack(
          children: [
            Positioned(
              top: -Get.width * 0.63,
              right: -Get.width * 0.42,
              left: -Get.width * 0.42,
              child: Lottie.asset(
                'assets/lottie/loading_bar.json',
                width: Get.width,
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                left: akContentPadding,
                right: akContentPadding,
                top: akContentPadding,
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: AkText(
                        'Buscando taxi...',
                        type: AkTextType.h8,
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.only(
            left: akContentPadding,
            right: akContentPadding,
            top: akContentPadding,
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 0.0),
                  child: AkText(
                    'Notificando a los conductores cercanos. Espera un momento.',
                    style: TextStyle(
                        color: akTextColor.withOpacity(.75),
                        fontSize: akFontSize - 1.0),
                  ),
                ),
              ),
              SizedBox(width: 20.0),
              SvgPicture.asset(
                'assets/icons/car_signal.svg',
                width: Get.width * 0.14,
              ),
            ],
          ),
        ),
      ]),
    );
  }

  RepaintBoundary _buildPanelBody() {
    return RepaintBoundary(
      key: _layerX.panelBodyKey,
      child: Column(
        children: [
          SizedBox(height: 30.0),
          Container(
            padding: EdgeInsets.symmetric(horizontal: akContentPadding),
            child: EtiquetasInicioFin(
              origenText: _layerX.taxiMapaX.tarifaOrigenName,
              destinoText: _layerX.taxiMapaX.tarifaDestinoName,
            ),
          ),
          SizedBox(height: 20.0),
          AkButton(
            variant: AkButtonVariant.red,
            type: AkButtonType.outline,
            enableMargin: false,
            onPressed: _layerX.onUserCancelTap,
            text: 'Cancelar solicitud',
          ),
          SizedBox(height: 20.0),
        ],
      ),
    );
  }
}
