part of '../taxi_travel_page.dart';

class _LayerViajando extends StatelessWidget {
  final TaxiTravelController conX;

  const _LayerViajando({required this.conX});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildToolbarButtons(),
        CommonButtonMap(
          icon: Icons.arrow_back_rounded,
          onTap: () {},
        ),
        _getBuilderPanel(context),
      ],
    );
  }

  Widget _getBuilderPanel(BuildContext context) {
    // Reset variables. Important!
    conX.panelHeightUpdated = false;
    conX.heightFromWidgets = false;

    return GetBuilder<TaxiTravelController>(
        id: 'gbSlidePanel',
        builder: (_) {
          return SlidingUpPanel(
            controller: conX.slidePanelController,
            boxShadow: TaxiMapaPage.cardShadows,
            maxHeight: conX.panelHeightOpen,
            minHeight: conX.panelHeightClosed,
            backdropEnabled: true,
            backdropOpacity: .15,
            panelBuilder: (sc) => _buildPanelCard(sc, context),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0)),
            onPanelSlide: (double pos) {
              conX.updatePanelMaxHeight();
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
              physics: conX.heightFromWidgets
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
      key: conX.panelTitleKey,
      child: Column(children: [
        SizedBox(height: 8.0),
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
        SizedBox(height: 3.0),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: akContentPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Obx(
                      () => FadeInDown(
                        from: 50.0,
                        key: ValueKey('tsL' + conX.travelStatusLabel.value),
                        duration: Duration(milliseconds: 600),
                        child: AkText(
                          conX.travelStatusLabel.value,
                          type: AkTextType.h9,
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                    decoration: BoxDecoration(
                        color: akPrimaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    child: Column(
                      children: [
                        AkText(
                          conX.tiempoRestanteM.value,
                          type: AkTextType.h8,
                          style: TextStyle(color: Colors.white),
                        ),
                        AkText(
                          'min',
                          type: AkTextType.body,
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 13.0),
              Divider(color: Color(0xFFF6F6F6), height: 2.0, thickness: 2.0),
            ],
          ),
        ),
      ]),
    );
  }

  Widget _buildSecureCodeSection() {
    final code = FadeIn(
      duration: Duration(milliseconds: 800),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: akContentPadding * 1.45),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    SizedBox(height: 18.0),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                          color: akAccentColor,
                          borderRadius: BorderRadius.circular(12.0)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/lock_pattern_2.svg',
                            width: 30.0,
                            color: akPrimaryColor,
                          ),
                          SizedBox(width: 8.0),
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: AkText(conX.code.toString(),
                                type: AkTextType.h4),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.0),
                    AkText(
                      'Código de viaje',
                      type: AkTextType.body1,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 3.0),
                    AkText(
                      'El conductor lo solicitará',
                      style: TextStyle(color: akTextColor.withOpacity(.56)),
                    ),
                    SizedBox(height: 7.0),
                  ],
                )
              ],
            ),
          ),
          SizedBox(height: 10.0),
          Divider(color: Color(0xFFF6F6F6), height: 2.0, thickness: 2.0),
        ],
      ),
    );

    final ok = FadeIn(
        duration: Duration(milliseconds: 800),
        child: Container(
          width: double.infinity,
          color: akAccentColor,
          padding: EdgeInsets.symmetric(horizontal: akContentPadding * 1.45),
          child: Column(
            children: [
              SizedBox(height: 18.0),
              PulseAnimationCustom(
                delay: Duration(milliseconds: 1000),
                infinite: true,
                child: SvgPicture.asset(
                  'assets/icons/shield_ok_2.svg',
                  width: 50.0,
                  color: akPrimaryColor,
                ),
                maxZoom: 1.2,
              ),
              SizedBox(height: 10.0),
              AkText(
                'El conductor ingresó\nel código correcto.',
                style: TextStyle(
                  color: akPrimaryColor,
                  fontWeight: FontWeight.normal,
                  fontSize: akFontSize + 1.0,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 15.0),
            ],
          ),
        ));

    if (conX.showSecureSection) {
      if (conX.secureCodeOk) {
        return ok;
      } else {
        return code;
      }
    } else {
      return SizedBox();
    }
  }

  RepaintBoundary _buildPanelBody() {
    return RepaintBoundary(
      key: conX.panelBodyKey,
      child: Column(
        children: [
          _buildSecureCodeSection(),
          // Info del conductor
          SizedBox(height: 15.0),
          Container(
            padding: EdgeInsets.symmetric(horizontal: akContentPadding * 1.45),
            child: DriverTileInfo(conductor: conX.conductor),
          ),
          SizedBox(height: 25.0),
          Divider(color: Color(0xFFF6F6F6), height: 2.0, thickness: 2.0),
          SizedBox(height: 20.0),
          Container(
            padding: EdgeInsets.symmetric(horizontal: akContentPadding * 1.45),
            child: EtiquetasInicioFinStyle2(
              origenText: conX.ruta?.nombreOrigen ?? '',
              destinoText: conX.ruta?.nombreDestino ?? '',
            ),
          ),
          SizedBox(height: 1.0),
          Container(
            width: double.infinity,
            color: akPrimaryColor,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: akWhiteColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                    ),
                  ),
                  height: 20,
                ),
                SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _hideButton(
                        text: 'Cancelar',
                        icon: Icons.close,
                        onTap: conX.canceledTravel),
                    _hideButton(
                        text: 'Llamar al 105',
                        icon: Icons.phone,
                        emergency: true,
                        onTap: conX.call105),
                    _hideButton(
                        text: 'Enviar SOS',
                        icon: Icons.warning_amber_rounded,
                        emergency: true,
                        // onTap: conX.onEmergencyBtnTap
                        onTap: conX.sendSOS),
                  ],
                ),
                SizedBox(height: 15.0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _hideButton(
      {IconData icon = Icons.check,
      String text = '',
      void Function()? onTap,
      bool emergency = false}) {
    final txtColor = emergency ? akSecondaryColor : akWhiteColor;

    final btn = AkButton(
      contentPadding: EdgeInsets.all(akFontSize * 0.75),
      variant: emergency ? AkButtonVariant.secondary : AkButtonVariant.white,
      type: AkButtonType.outline,
      enableMargin: false,
      onPressed: () {
        onTap?.call();
      },
      child: Column(
        children: [
          Icon(
            icon,
            color: txtColor,
            size: akFontSize * 1.85,
          ),
          AkText(
            text,
            type: AkTextType.comment,
            style: TextStyle(color: txtColor),
          )
        ],
      ),
    );

    return Opacity(
        opacity: .45, child: Transform.scale(scale: .85, child: btn));
  }

  Widget _buildToolbarButtons() {
    return GetBuilder<TaxiTravelController>(
      id: 'gbMapButtons',
      builder: (_) => Positioned(
        bottom: conX.panelHeightClosed + 10.0,
        right: akContentPadding * 0.75,
        child: Column(
          children: [
            // ButtonBoundsMap(onPressed: conX.otherButton),
            SizedBox(height: 8.0),
            CommonButtonMap(
              child: SvgPicture.asset(
                'assets/icons/route_3.svg',
                width: 20.5,
                color: akPrimaryColor,
              ),
              onTap: conX.onBoundsButtonTap,
            ),
            SizedBox(height: 8.0),
            CommonButtonMap(
              icon: Icons.my_location,
              onTap: conX.onCenterButtonTap,
            ),
          ],
        ),
      ),
    );
  }
}
