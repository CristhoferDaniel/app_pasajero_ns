part of '../../taxi_mapa_page.dart';

class LayerBuscar extends StatelessWidget {
  final _layerX = Get.find<LayerBuscarCtlr>();

  final _appBarHeight = 55.0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Obx(() => Container(
              child: SafeArea(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: akScaffoldBackgroundColor,
                        boxShadow: [
                          BoxShadow(
                            color: akPrimaryColor.withOpacity(.1),
                            blurRadius: 3.0,
                            spreadRadius: 1.0,
                            offset: Offset(1.0, 2.0),
                          )
                        ],
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: akContentPadding * 0.75),
                      child: Column(
                        children: [
                          SizedBox(
                              height:
                                  _appBarHeight + (akContentPadding * 0.75)),
                          _buildInputs(),
                          SizedBox(height: 10.0),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: IgnorePointer(
                              child: FadeIn(
                                delay: Duration(milliseconds: 600),
                                child: Container(
                                  child: Obx(
                                    () => Center(
                                      child: Transform.translate(
                                        offset: Offset(0, -65),
                                        child: SlideInDown(
                                          from: 100,
                                          duration: Duration(milliseconds: 200),
                                          child: AnimatedSwitcher(
                                            duration:
                                                Duration(milliseconds: 200),
                                            switchInCurve: Curves.easeInOut,
                                            switchOutCurve: Curves.easeInOut,
                                            transitionBuilder: (Widget child,
                                                Animation<double> animation) {
                                              return ScaleTransition(
                                                  child: child,
                                                  scale: animation);
                                            },
                                            child: !_layerX.taxiMapaX
                                                    .movingPickMap.value
                                                ? BadgeMapPin(
                                                    key: ValueKey<String>(
                                                        'mark1'),
                                                    moving: _layerX.taxiMapaX
                                                        .movingPickMap.value,
                                                  )
                                                : BadgeMapPin(
                                                    key: ValueKey<String>(
                                                        'mark2'),
                                                    moving: _layerX.taxiMapaX
                                                        .movingPickMap.value,
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned.fill(
                            child: Container(
                              child: FadeIn(
                                delay: Duration(milliseconds: 600),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              right: akContentPadding,
                                              bottom: akContentPadding * 0.5),
                                          child: CommonButtonMap(
                                            icon: Icons.my_location,
                                            onTap: _layerX
                                                .onCenterPickTap, // taxiX.centerToMyPosition,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Content(
                                      child: AkButton(
                                        backgroundColor: _layerX.taxiMapaX
                                                .searchingAddressFromPick.value
                                            ? Helpers.lighten(
                                                akPrimaryColor, 0.3)
                                            : akPrimaryColor,
                                        fluid: true,
                                        enableMargin: false,
                                        text: 'Listo',
                                        onPressed: _layerX.taxiMapaX
                                                .searchingAddressFromPick.value
                                            ? () {}
                                            : _layerX.onSaveManualPosition,
                                      ),
                                    ),
                                    SizedBox(
                                      height: akContentPadding,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Obx(() => TweenAnimationBuilder<double>(
                                duration: Duration(milliseconds: 300),
                                tween: _layerX.isSearchResultListVisible.value
                                    ? Tween<double>(begin: 0, end: 1)
                                    : Tween<double>(begin: 1, end: 0),
                                builder: (BuildContext context, double value,
                                    Widget? child) {
                                  return Opacity(opacity: value, child: child);
                                },
                                child: IgnorePointer(
                                  ignoring:
                                      !_layerX.isSearchResultListVisible.value,
                                  child: Container(
                                    color: akScaffoldBackgroundColor
                                        .withOpacity(1),
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: GetBuilder<LayerBuscarCtlr>(
                                            id: _layerX.gbResultados,
                                            builder: (_) {
                                              if (_layerX
                                                  .showItemListPlaceHolder) {
                                                return _buildPlaceHolderList();
                                              }
                                              return _buildResultados();
                                            },
                                          ),
                                        ),
                                        // Para agregar un padding cuando el teclado aparezca
                                        Obx(
                                          () => Container(
                                            color: Colors.transparent,
                                            width: double.infinity,
                                            height: _layerX
                                                .paddingBottomResultList.value,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: _buildAppBar(context),
        ),
        _buildLoading(),
      ],
    );
  }

  Widget _buildPlaceHolderList() {
    return ListView.separated(
      physics: NeverScrollableScrollPhysics(),
      itemCount: 20,
      separatorBuilder: (_, i) {
        return Divider();
      },
      itemBuilder: (_, i) {
        return Opacity(opacity: .56, child: _buildItemPlaceHolder());
      },
    );
  }

  Widget _buildItemPlaceHolder() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(10.0),
          child: Skeleton(
            height: 30.0,
            width: 30.0,
            borderRadius: 6.0,
          ),
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(flex: 4, child: Skeleton(fluid: true, height: 15.0)),
                  Expanded(flex: 5, child: SizedBox()),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                children: [
                  Expanded(flex: 8, child: Skeleton(fluid: true, height: 12.0)),
                  Expanded(flex: 2, child: SizedBox()),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      toolbarHeight: _appBarHeight,
      title: Obx(
        () => AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          switchInCurve: Curves.easeInOut,
          switchOutCurve: Curves.easeInOut,
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(child: child, scale: animation);
          },
          child: Text(
            '${_layerX.tituloAppBar.value}',
            style: TextStyle(
              color: akPrimaryColor,
              fontWeight: FontWeight.w400,
            ),
            key: ValueKey<String>(_layerX.tituloAppBar.value),
          ),
        ),
      ),
      backgroundColor: akAccentColor,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_rounded,
          color: akPrimaryColor,
          size: akFontSize + 4.0,
        ),
        onPressed: _layerX.taxiMapaX.handleBack,
      ),
    );
  }

  Widget _buildLoading() {
    return Obx(() {
      if (_layerX.taxiMapaX.fetchingGoogleRoute.value) {
        Get.focusScope?.unfocus();
        return Container(
          width: Get.width,
          height: Get.height,
          decoration: BoxDecoration(color: Colors.black.withOpacity(.35)),
          child: Center(
            child: SpinLoadingIcon(),
          ),
        );
      }
      return SizedBox();
    });
  }

  Widget _buildResultados() {
    List<dynamic> items = [];

    if (_layerX.searchText.isEmpty) {
      items.addAll(_layerX.sugerencias);
      items.add('manual');
    } else {
      if (_layerX.loadingSearchPrediction) {
        items.add('searching');
        items.add('manual');
      } else {
        if (_layerX.errorSearchingPrediction) {
          items.add('error');
        } else {
          if (_layerX.sugerencias.isEmpty) {
            items.add('noresults');
            items.add('manual');
          } else {
            items.addAll(_layerX.sugerencias);
            items.add('manual');
          }
        }
      }
    }

    return ListView.separated(
      separatorBuilder: (_, i) => Container(
        padding: EdgeInsets.symmetric(horizontal: akContentPadding * 0.75),
        child: Divider(
          color: Color(0xFFF6F6F6),
          height: 1,
          thickness: 1,
        ),
      ),
      physics: BouncingScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (_, i) {
        if (items[i] is Prediction) {
          Prediction prediction = items[i];
          String typeIcon =
              prediction.types.isNotEmpty ? prediction.types.first : '';

          return PredictionItemList(
              prediction: prediction,
              typeIcon: typeIcon,
              onPress: (item) {
                _layerX.onItemListTap(item);
              },
              onFavoriteAdd: _layerX.onFavoriteAdd,
              onFavoriteRemove: _layerX.onFavoriteRemove);
        }

        if (items[i] is String && items[i] == 'searching') {
          return _LoadingPredictions(_layerX.searchText.value);
        }

        if (items[i] is String && items[i] == 'error') {
          return Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: () {
                  _layerX.searchAddressFromText(_layerX.searchText.value);
                },
                child: _ErrorPredictions(),
              ));
        }

        if (items[i] is String && items[i] == 'manual') {
          return _SelectManualItem(
            onTap: _layerX.onManualMapItemTap,
          );
        }

        if (items[i] is String && items[i] == 'noresults') {
          return _NoResults();
        }

        return SizedBox();
      },
    );
  }

  Widget _buildInputs() {
    return Row(
      children: [
        SizedBox(width: 5.0),
        const ShapeRoute(),
        SizedBox(width: 15.0),
        Expanded(
            child: Column(
          children: [
            _buildInptOrigen(),
            _buildInptDestino(),
          ],
        )),
      ],
    );
  }

  Widget _buildInptOrigen() {
    return Obx(() => Container(
          child: Stack(
            children: [
              AkInput(
                contentPadding:
                    EdgeInsets.only(left: 11.0, top: 12.0, bottom: 12.0),
                filledColor: !_layerX.isSearchResultListVisible.value &&
                        _layerX.busquedaView == BusquedaView.origen
                    ? Colors.white
                    : Color(0xFFF1F1F1),
                enabledBorderColor: !_layerX.isSearchResultListVisible.value &&
                        _layerX.busquedaView == BusquedaView.origen
                    ? akPrimaryColor
                    : Colors.white,
                forceOutline: true,
                filledFocusedColor: Colors.white,
                keyboardType: TextInputType.text,
                controller: _layerX.origenCtlr,
                hintText: 'Punto de origen',
                labelColor: akTextColor.withOpacity(.3),
                focusNode: _layerX.focusNodeOrigen,
                enableMargin: false,
                suffixIcon: _layerX.isSearchResultListVisible.value
                    ? Icon(Icons.search)
                    : (_layerX.busquedaView == BusquedaView.origen &&
                            _layerX.taxiMapaX.searchingAddressFromPick.value
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SpinLoadingIcon(
                                color: akPrimaryColor,
                                size: akFontSize,
                              ),
                            ],
                          )
                        : null),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                type: AkInputType.outline,
                borderRadius: 8.0,
                onFieldCleaned: () {
                  _layerX.setSearchText('');
                },
                onChanged: (text) {
                  _layerX.setSearchText(text);
                },
              ),
              !_layerX.isSearchResultListVisible.value
                  ? Positioned.fill(
                      child: Container(
                        color: Colors.red.withOpacity(0.0),
                      ),
                    )
                  : SizedBox(),
            ],
          ),
          padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 5.0),
        ));
  }

  Widget _buildInptDestino() {
    final _taxiX = Get.find<TaxiMapaController>();

    return Container(
      child: Stack(
        children: [
          AkInput(
            contentPadding:
                EdgeInsets.only(left: 11.0, top: 12.0, bottom: 12.0),
            filledColor: !_layerX.isSearchResultListVisible.value &&
                    _layerX.busquedaView == BusquedaView.destino
                ? Colors.white
                : Color(0xFFF1F1F1),
            enabledBorderColor: !_layerX.isSearchResultListVisible.value &&
                    _layerX.busquedaView == BusquedaView.destino
                ? akPrimaryColor
                : Colors.white,
            forceOutline: true,
            filledFocusedColor: Colors.white,
            keyboardType: TextInputType.text,
            controller: _layerX.destinoCtlr,
            hintText: 'Lugar de destino',
            labelColor: akTextColor.withOpacity(.3),
            focusNode: _layerX.focusNodeDestino,
            enableMargin: false,
            suffixIcon: _layerX.isSearchResultListVisible.value
                ? Icon(Icons.search)
                : (_layerX.busquedaView == BusquedaView.destino &&
                        _taxiX.searchingAddressFromPick.value
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SpinLoadingIcon(
                            color: akPrimaryColor,
                            size: akFontSize,
                          ),
                        ],
                      )
                    : null),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            type: AkInputType.outline,
            borderRadius: 8.0,
            onFieldCleaned: () {
              _layerX.setSearchText('');
            },
            onChanged: (text) {
              _layerX.setSearchText(text);
            },
          ),
          !_layerX.isSearchResultListVisible.value
              ? Positioned.fill(
                  child: Container(
                    color: Colors.red.withOpacity(0.0),
                  ),
                )
              : SizedBox(),
        ],
      ),
      padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 5.0),
    );
  }
}

class _ErrorPredictions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          SizedBox(width: 15.0),
          SvgPicture.asset(
            'assets/icons/error_phone.svg',
            width: 25.0,
            color: akErrorColor,
          ),
          SizedBox(width: 15.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AkText(
                  'Predicciones no disponibles',
                  style: TextStyle(color: akPrimaryColor),
                ),
                AkText(
                  'Reintentar',
                  style: TextStyle(
                      fontSize: akFontSize - 3.0, color: akSecondaryColor),
                )
              ],
            ),
          ),
          SizedBox(width: 20.0),
        ],
      ),
    );
  }
}

class _LoadingPredictions extends StatelessWidget {
  final String text;

  const _LoadingPredictions(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        children: [
          SizedBox(width: 20.0),
          SpinLoadingIcon(
            color: akPrimaryColor,
            size: 16.0,
            strokeWidth: 2.5,
          ),
          SizedBox(width: 15.0),
          Expanded(
            child: AkText(
              'Buscando "$text"',
              style: TextStyle(color: akPrimaryColor.withOpacity(.5)),
            ),
          ),
          SizedBox(width: 20.0),
        ],
      ),
    );
  }
}

class _SelectManualItem extends StatelessWidget {
  final void Function() onTap;

  const _SelectManualItem({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () {
          this.onTap.call();
        },
        child: Container(
          padding: EdgeInsets.symmetric(
              vertical: akContentPadding * 0.72,
              horizontal: akContentPadding * 0.75),
          child: Row(
            children: [
              Container(
                width: 35.0,
                child: Padding(
                  padding: EdgeInsets.only(left: 3.0),
                  child: Icon(
                    Icons.my_location,
                    size: 23.0,
                    color: akSecondaryColor,
                  ),
                ),
                alignment: Alignment.centerLeft,
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AkText(
                      ' Fijar ubicación en el mapa',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _NoResults extends StatelessWidget {
  const _NoResults();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        children: [
          SizedBox(width: 20.0),
          Expanded(
            child: AkText(
              'No se encontraron resultados',
              style: TextStyle(color: akPrimaryColor.withOpacity(.5)),
            ),
          ),
          SizedBox(width: 20.0),
        ],
      ),
    );
  }
}
