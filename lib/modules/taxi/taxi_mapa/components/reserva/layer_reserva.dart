part of '../../taxi_mapa_page.dart';

class _LayerReserva extends StatelessWidget {
  final _layerX = Get.find<LayerReservaCtlr>();

  @override
  Widget build(BuildContext context) {
    _layerX.setContext(context);

    return Container(
      decoration: BoxDecoration(color: akAccentColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SafeArea(
              child: SizedBox(
            height: 20.0,
          )),
          const _HeaderPage(),
          SizedBox(height: 20.0),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: akWhiteColor,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(25.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF8D8B8B).withOpacity(.20),
                    blurRadius: 12,
                    offset: Offset(0, -6),
                  )
                ],
              ),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: akContentPadding),
                    // Selector del Tipo de Reserva
                    _TravelTypeSelector(_layerX),
                    SizedBox(height: 20.0),

                    // Mensaje cuando selecciona Ida y Vuelta
                    // TODO: EVALUAR SI ELIMINAR
                    // _LabelBackTrip(_layerX),

                    // Selector de fecha
                    _DateSelector(
                      fechaRx: _layerX.taxiMapaX.fechaIda,
                      onFechaSelected: () {
                        _layerX.onFechaSelected(ida: true);
                      },
                    ),
                    SizedBox(height: 20.0),

                    Obx(() => AnimatedSwitcher(
                          duration: Duration(milliseconds: 200),
                          child: _layerX.taxiMapaX.tipoReserva.value ==
                                  TaxiReservaType.idayvuelta
                              ? Column(
                                  children: [
                                    _DateSelector(
                                      fechaRx: _layerX.taxiMapaX.fechaVuelta,
                                      ida: false,
                                      onFechaSelected: () {
                                        _layerX.onFechaSelected(ida: false);
                                      },
                                    ),
                                    SizedBox(height: 20.0),
                                  ],
                                )
                              : SizedBox(),
                        )),

                    Content(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _PassengerSection(_layerX),
                          SizedBox(height: 20.0),
                          _BaggageSection(_layerX),
                          SizedBox(height: 10.0),
                          AkText('Comentarios', type: AkTextType.subtitle1),
                          SizedBox(height: 15.0),
                          AkInput(
                            type: AkInputType.legend,
                            controller: _layerX.taxiMapaX.reservaComentario,
                            filledColor: Color(0xFFA7A7A7).withOpacity(.12),
                            filledFocusedColor:
                                Color(0xFFA7A7A7).withOpacity(.12),
                            enabledBorderColor: Colors.transparent,
                            focusedBorderColor: Colors.transparent,
                            hintText: 'Escribir un comentario',
                            labelColor: akTitleColor.withOpacity(.25),
                            enableClean: false,
                            maxLines: 4,
                            maxLength: 300,
                          ),
                          SizedBox(height: 20.0),
                          Obx(
                            () => Container(
                              color: Colors.transparent,
                              width: double.infinity,
                              height: _layerX.paddingBottomForm.value / 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            color: akWhiteColor,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: akWhiteColor,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(25.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF8D8B8B).withOpacity(.20),
                    blurRadius: 12,
                    offset: Offset(0, -6),
                  )
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0),
                child: Content(
                  child: AkButton(
                    fluid: true,
                    enableMargin: false,
                    onPressed: _layerX.onContinueButtonTap,
                    text: 'Continuar',
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _TravelTypeSelector extends StatelessWidget {
  final LayerReservaCtlr _layerX;
  const _TravelTypeSelector(this._layerX, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Content(
      child: Obx(() => Row(
            children: [
              _CheckboxType(
                'Solo ida',
                isSelected:
                    _layerX.taxiMapaX.tipoReserva.value == TaxiReservaType.ida,
                onTap: () {
                  _layerX.onTipoReservaTap(TaxiReservaType.ida);
                },
              ),
              SizedBox(width: 10.0),
              _CheckboxType(
                'Ida y vuelta',
                isSelected: _layerX.taxiMapaX.tipoReserva.value ==
                    TaxiReservaType.idayvuelta,
                onTap: () {
                  _layerX.onTipoReservaTap(TaxiReservaType.idayvuelta);
                },
              ),
            ],
          )),
    );
  }
}

class _CheckboxType extends StatelessWidget {
  final String text;
  final bool isSelected;
  final double checkSize = 8.0;
  final void Function()? onTap;
  const _CheckboxType(this.text,
      {Key? key, this.isSelected = false, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final borderColor = isSelected
        ? Helpers.darken(akAccentColor, 0.1)
        : akTitleColor.withOpacity(.0);
    final circleColor = isSelected
        ? Helpers.darken(akAccentColor, 0.1)
        : akTitleColor.withOpacity(.3);
    final textColor = isSelected ? akTitleColor : akTitleColor.withOpacity(.6);

    return Flexible(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: borderColor,
            width: checkSize * 0.2,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: BorderRadius.circular(8.0),
            onTap: () {
              this.onTap?.call();
            },
            child: Container(
              padding: EdgeInsets.all(10.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Column(
                      children: [
                        AkText(
                          text,
                          style: TextStyle(
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 5.0),
                  Container(
                    padding: EdgeInsets.all(checkSize * 0.3),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: circleColor,
                        width: checkSize * 0.2,
                      ),
                      borderRadius: BorderRadius.circular(
                        checkSize * 3,
                      ),
                    ),
                    child: Container(
                      width: checkSize,
                      height: checkSize,
                      decoration: BoxDecoration(
                        color: isSelected ? borderColor : Colors.transparent,
                        borderRadius: BorderRadius.circular(checkSize * 2),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LabelBackTrip extends StatelessWidget {
  final LayerReservaCtlr _layerX;
  const _LabelBackTrip(this._layerX, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => AnimatedSwitcher(
          duration: Duration(milliseconds: 200),
          child:
              _layerX.taxiMapaX.tipoReserva.value == TaxiReservaType.idayvuelta
                  ? Content(
                      child: Column(
                        children: [
                          AkText(
                            'Se solicitarán los datos del viaje de vuelta en la siguiente pantalla.',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: akFontSize - 0.5,
                            ),
                          ),
                          SizedBox(height: 20.0),
                        ],
                      ),
                    )
                  : SizedBox(),
        ));
  }
}

class _DateSelector extends StatelessWidget {
  final bool ida;
  final Rxn<DateTime> fechaRx;
  final void Function()? onFechaSelected;
  const _DateSelector(
      {Key? key, this.ida = true, required this.fechaRx, this.onFechaSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: akContentPadding * 0.5),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(10.0),
          onTap: () {
            onFechaSelected?.call();
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 12.0,
            ),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(.03),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                      color: ida ? akAccentColor : akPrimaryColor,
                      borderRadius: BorderRadius.circular(7.0)),
                  child: Icon(
                    Icons.calendar_today_outlined,
                    color: ida ? akPrimaryColor : akWhiteColor,
                    size: akFontSize + 6.0,
                  ),
                ),
                SizedBox(width: 7.0),
                Expanded(
                  child: AkText(
                    ida ? 'Fecha de ida' : 'Fecha de regreso',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: akTitleColor.withOpacity(.70),
                      fontSize: akFontSize + 2,
                    ),
                  ),
                ),
                Obx(
                  () => fechaRx.value != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            AkText(
                              DateFormat('EE d MMM', 'es')
                                  .format(fechaRx.value!),
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: akFontSize + 2,
                                color: akTitleColor,
                              ),
                            ),
                            AkText(
                              DateFormat('h:mm a')
                                  .format(fechaRx.value!), //_conX.ddd.value,
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                fontSize: akFontSize + 1,
                                color: akTitleColor,
                              ),
                            )
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            AkText(
                              'Selecciona\naquí',
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                color: akTitleColor.withOpacity(.50),
                              ),
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderPage extends StatelessWidget {
  const _HeaderPage();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: akContentPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AkText(
                  'Reservar viaje',
                  style: TextStyle(
                    color: akTitleColor,
                    fontWeight: FontWeight.w500,
                    fontSize: akFontSize + 6,
                  ),
                ),
                SizedBox(height: 3.0),
                AkText(
                  'Formulario',
                  style: TextStyle(
                    color: akTitleColor.withOpacity(.30),
                    fontSize: akFontSize - 2,
                  ),
                ),
              ],
            ),
          ),
          Transform.translate(
            offset: Offset(5.0, -5.0),
            child: IconButton(
              padding: EdgeInsets.all(5.0),
              constraints: BoxConstraints(),
              onPressed: () => Get.back(),
              icon: Icon(
                Icons.clear_rounded,
                color: akTitleColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PassengerSection extends StatelessWidget {
  final LayerReservaCtlr _layerX;
  _PassengerSection(this._layerX);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AkText('Pasajeros', type: AkTextType.subtitle1),
        _CounterItem('Adultos', _layerX.taxiMapaX.cantAdultos,
            minNumber: 1, subtitle: 'De 13 años o más'),
        _CounterItem('Niños', _layerX.taxiMapaX.cantNinos,
            subtitle: 'De 2 a 12 años'),
        _CounterItem('Bebés', _layerX.taxiMapaX.cantBebes,
            subtitle: 'Menos de 2 años'),
      ],
    );
  }
}

class _BaggageSection extends StatelessWidget {
  final LayerReservaCtlr _layerX;
  _BaggageSection(this._layerX);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AkText('Equipaje', type: AkTextType.subtitle1),
        _CounterItem('Maletas grandes', _layerX.taxiMapaX.cantMaletasGrandes),
        _CounterItem('Maletas medianas', _layerX.taxiMapaX.cantMaletasMedianas),
        _CounterItem('Mochilas', _layerX.taxiMapaX.cantMochilas),
      ],
    );
  }
}

class _CounterItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final RxInt reactive;
  final int minNumber;

  _CounterItem(this.title, this.reactive, {this.subtitle, this.minNumber = 0});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AkText(
                  title,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle != null
                    ? AkText(
                        subtitle ?? '',
                        style: TextStyle(
                          fontSize: akFontSize - 2.0,
                          color: akTitleColor.withOpacity(.40),
                        ),
                      )
                    : SizedBox(),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF8D8B8B).withOpacity(.16),
                  offset: Offset(0, 2),
                  spreadRadius: 1.5,
                  blurRadius: 3,
                )
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Row(
                children: [
                  _CounterNumberBtn(
                    isRemove: true,
                    onTap: () {
                      if (reactive.value > minNumber) {
                        reactive.value--;
                      }
                    },
                  ),
                  Container(
                    width: akFontSize * 3,
                    child: Obx(
                      () => AkText(
                        '${reactive.value}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  _CounterNumberBtn(
                    onTap: () {
                      if (reactive.value < 10) {
                        reactive.value++;
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CounterNumberBtn extends StatelessWidget {
  final bool isRemove;
  final void Function()? onTap;

  _CounterNumberBtn({this.isRemove = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        borderRadius: BorderRadius.circular(11.0),
        onTap: () {
          onTap?.call();
        },
        child: Container(
          width: akFontSize * 2.5,
          height: akFontSize * 2.5,
          child: Icon(
            isRemove ? Icons.remove : Icons.add,
            size: akFontSize - 2.0,
          ),
        ),
      ),
    );
  }
}
