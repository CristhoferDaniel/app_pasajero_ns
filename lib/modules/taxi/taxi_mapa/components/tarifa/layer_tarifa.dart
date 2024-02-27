part of '../../taxi_mapa_page.dart';

class _LayerTarifa extends StatelessWidget {
  final _layerX = Get.find<LayerTarifaCtlr>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IgnorePointer(
          child: Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.transparent,
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          left: 0,
          child: SafeArea(
            child: Container(
              width: Get.width,
              padding: EdgeInsets.symmetric(
                  horizontal: akContentPadding * 0.5,
                  vertical: akContentPadding * 1.25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonButtonMap(
                        icon: Icons.arrow_back_rounded,
                        onTap: _layerX.taxiMapaX.handleBack,
                      ),
                      /* CommonButtonMap(
                        child: Row(
                          children: [
                            AkText(
                              'Cupón descuento'.toUpperCase(),
                              style: TextStyle(
                                  fontSize: akFontSize - 4.0,
                                  fontWeight: FontWeight.w600,
                                  color: akTextColor.withOpacity(.75)),
                            ),
                            SizedBox(width: 5.0),
                            Icon(
                              Icons.local_offer_rounded,
                              size: akFontSize + 2.0,
                              color: akSecondaryColor,
                            ),
                          ],
                        ),
                        onTap: () async {
                          Get.toNamed(AppRoutes.CUPONES);
                        },
                      ), */
                    ],
                  ),
                  SizedBox(height: 10.0),
                  /* CommonButtonMap(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AkText('${_layerX.taxiMapaX.tarifaDistanciaM} m'),
                        AkText('${_layerX.taxiMapaX.tarifaDuracionS} s'),
                      ],
                    ),
                    onTap: () {},
                  ), */
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: _layerX.taxiMapaX.typeService == ServiceType.regular
              ? _layerX.panelHeightClosed + _layerX.footerSpace + 6.0
              : _layerX.footerSpace + 12.0,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    right: akContentPadding, bottom: akContentPadding * 0.5),
                child: CommonButtonMap(
                  icon: Icons.my_location,
                  onTap: _layerX.taxiMapaX.centerToRoute,
                ),
              ),
            ],
          ),
        ),
        _TarifaSelector(layerX: _layerX),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(height: _layerX.footerSpace, color: Colors.white),
        ),
        _getBottomActions(),
      ],
    );
  }

  Widget _getBottomActions() {
    String reservaFecha = '';

    if (_layerX.taxiMapaX.fechaIda.value != null) {
      reservaFecha = DateFormat('h:mm aa, EE, d', 'es')
              .format(_layerX.taxiMapaX.fechaIda.value!) +
          ' de ' +
          DateFormat('MMM', 'es').format(_layerX.taxiMapaX.fechaIda.value!);
    }

    Widget actions = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: _layerX.goToCurrencyPage,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: akContentPadding,
                vertical: 16.0,
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/currency.svg',
                    width: akFontSize + 15.0,
                  ),
                  SizedBox(width: 12.0),
                  Expanded(
                    child: AkText(
                      'Efectivo',
                      style: TextStyle(
                        color: akTitleColor,
                        fontWeight: FontWeight.w500,
                        fontSize: akFontSize - 1.0,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: akFontSize - 2.0,
                    color: akTextColor.withOpacity(.60),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 5.0),
        Container(
          padding: EdgeInsets.only(
            left: akContentPadding,
            right: akContentPadding,
            bottom: akContentPadding,
          ),
          child: Obx(() => AkButton(
                fluid: true,
                enableMargin: false,
                contentPadding:
                    _layerX.taxiMapaX.typeService == ServiceType.reservation
                        ? EdgeInsets.all(10.0)
                        : EdgeInsets.all(16.0),
                child: Stack(
                  children: [
                    Opacity(
                      opacity: _layerX.taxiMapaX.loading.value ? 0 : 1,
                      child: Container(
                        width: double.infinity,
                        child: _layerX.taxiMapaX.typeService ==
                                ServiceType.reservation
                            ? Column(
                                children: [
                                  AkText(
                                    'PROGRAMAR RESERVA',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: akWhiteColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: akFontSize + 1.0,
                                    ),
                                  ),
                                  SizedBox(height: 5.0),
                                  AkText(
                                    reservaFecha,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: akWhiteColor.withOpacity(.6),
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  AkText(
                                    'Solicitar Taxi',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: akWhiteColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: akFontSize + 1.0,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    Positioned.fill(
                      child: _layerX.taxiMapaX.loading.value
                          ? Center(
                              child: SpinLoadingIcon(
                                color: akWhiteColor,
                                size: akFontSize + 4.0,
                              ),
                            )
                          : SizedBox(),
                    ),
                  ],
                ),
                // Cuando loading es true, el absorbing de abajo
                // bloquea la vista
                onPressed: _layerX.onReservaOSolicitarTaxiTap,
              )),
        )
      ],
    );

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: IgnorePointer(
        ignoring: _layerX.taxiMapaX.loading.value,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF8D8B8B).withOpacity(.20),
                    offset: Offset(0, -3),
                    blurRadius: 6,
                  )
                ],
              ),
              width: double.infinity,
              /* child: Obx(() => AbsorbPointer(
                    absorbing: conX.manualLoading.value,
                    child: actions,
                  )), */
              child: Obx(
                () => AbsorbPointer(
                  absorbing: _layerX.taxiMapaX.loading.value,
                  child: actions,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TarifaSelector extends StatelessWidget {
  const _TarifaSelector({
    Key? key,
    required LayerTarifaCtlr layerX,
  })  : _layerX = layerX,
        super(key: key);

  final LayerTarifaCtlr _layerX;

  @override
  Widget build(BuildContext context) {
    if (_layerX.taxiMapaX.typeService == ServiceType.reservation) {
      return SizedBox();
    }

    final maxOpenedHeight =
        (MediaQuery.of(context).size.height - _layerX.footerSpace) * .87;

    List<SCTarifa> lista = _layerX.taxiMapaX.tarifas;

    if (lista.length > _layerX.slotsDisplayed) {
      final _possibleHeight = (_layerX.itemHeight *
              (_layerX.slotsDisplayed +
                  (lista.length - _layerX.slotsDisplayed))) +
          _layerX.headerSpaceAprox;
      if (_possibleHeight <= maxOpenedHeight) {
        _layerX.panelHeightOpen = _possibleHeight;
      } else {
        _layerX.panelHeightOpen = maxOpenedHeight;
      }
    } else {
      _layerX.panelHeightOpen = maxOpenedHeight;
    }

    return GetBuilder<LayerTarifaCtlr>(
      id: _layerX.gbPanelTarifa,
      builder: (_) {
        SCTarifa selected = _layerX.taxiMapaX.tarifaSelected;
        return SlidingUpPanel(
          margin: EdgeInsets.only(bottom: _layerX.footerSpace),
          controller: _layerX.panelController,
          maxHeight: _layerX.panelHeightOpen,
          minHeight: _layerX.panelHeightClosed,
          backdropColor: Colors.black,
          backdropEnabled: true,
          backdropOpacity: 0.5,
          isDraggable: _layerX.showMoreItems,
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(akCardBorderRadius * 1.5)),
          boxShadow: TaxiMapaPage.cardShadows,
          panel: Container(
            child: Column(
              children: [
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 45,
                        height: 4.5,
                        decoration: BoxDecoration(
                            color: Colors.grey[350],
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0))),
                      ),
                      if (_layerX.showMoreItems)
                        SizedBox(
                          height: 8.0,
                        ),
                      if (_layerX.showMoreItems)
                        FadeIn(
                          key: ValueKey('_vkDezli${_layerX.panelHidden}'),
                          child: AkText(
                            'Desliza hacia ${_layerX.panelHidden ? 'arriba' : 'abajo'} para ver ${_layerX.panelHidden ? 'más' : 'menos'}',
                            style: TextStyle(
                              fontSize: akFontSize - 2.0,
                              color: akTextColor.withOpacity(.60),
                            ),
                          ),
                        ),
                    ],
                  ),
                  height: _layerX.headerSpaceAprox,
                ),
                Divider(
                  height: 0.5,
                  color: Colors.grey[300],
                ),
                Flexible(
                  child: SingleChildScrollView(
                    controller: _layerX.scrollController,
                    physics: _layerX.panelHidden
                        ? NeverScrollableScrollPhysics()
                        : BouncingScrollPhysics(),
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (var i = 0; i < lista.length; i++)
                            _TarifaItem(
                              isSelected: lista[i].idTipoVehiculo ==
                                  selected.idTipoVehiculo,
                              height: _layerX.itemHeight,
                              data: lista[i],
                              onTap: () {
                                if (!_layerX.taxiMapaX.loading.value) {
                                  _layerX.onTarifaItemTap(lista[i]);
                                }
                              },
                            ),
                          Container(
                            height: _layerX.panelHidden
                                ? (_layerX.footerSpace *
                                    10) // 10 to generate a big space
                                : 0.0,
                            color: Colors.blue,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          onPanelSlide: _layerX.onPanelSlide,
          onPanelClosed: _layerX.onPanelClosed,
        );
      },
    );
  }
}

class _TarifaItem extends StatelessWidget {
  final bool isSelected;
  final double height;
  final SCTarifa data;
  final VoidCallback? onTap;
  const _TarifaItem({
    Key? key,
    this.isSelected = false,
    required this.height,
    this.onTap,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorSelected = akAccentColor;

    return Stack(
      children: [
        Positioned.fill(
          child: FadeIn(
            key: ValueKey('_vkTarItem${data.idTipoVehiculo}$isSelected'),
            child: Container(
              color: isSelected
                  ? colorSelected.withOpacity(.15)
                  : Colors.transparent,
            ),
          ),
        ),
        Material(
          type: MaterialType.transparency,
          child: InkWell(
            highlightColor:
                Helpers.darken(colorSelected.withOpacity(.15), 0.03),
            splashColor: Helpers.darken(colorSelected.withOpacity(.15), 0.05),
            onTap: () {
              onTap?.call();
            },
            child: Container(
              width: double.infinity,
              height: height,
              padding: EdgeInsets.only(
                left: 5.0,
                right: akContentPadding * 0.75,
              ),
              child: Row(
                children: [
                  Container(
                    width: 3.5,
                    height: height * 0.70,
                    decoration: BoxDecoration(
                      color: isSelected ? colorSelected : Colors.transparent,
                      borderRadius: BorderRadius.circular(300.0),
                    ),
                  ),
                  SizedBox(width: 6.0),
                  Image.network(
                    'https://i.imgur.com/I7vSMtN.png',
                    height: height * 0.42,
                  ),
                  SizedBox(width: 10.0),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AkText(
                          '${Helpers.nameFormatCase(data.tipoVehiculo)}',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: akFontSize + 2.0,
                            color: isSelected
                                ? akTitleColor
                                : akTitleColor.withOpacity(.6),
                          ),
                        ),
                        SizedBox(height: 3.0),
                        AkText(
                          '6 min',
                          style: TextStyle(
                            fontSize: akFontSize - 2.0,
                            color: isSelected
                                ? akTextColor
                                : akTextColor.withOpacity(.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  AkText(
                    'S/.${data.precioCalculado}',
                    style: TextStyle(
                      fontSize: akFontSize + 3.5,
                      color: isSelected
                          ? akTitleColor
                          : akTitleColor.withOpacity(.6),
                    ),
                  ),
                ],
              ),
              alignment: Alignment.centerLeft,
            ),
          ),
        ),
      ],
    );
  }
}
