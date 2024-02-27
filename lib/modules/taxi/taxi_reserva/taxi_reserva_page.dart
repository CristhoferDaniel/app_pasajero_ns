import 'package:app_pasajero_ns/modules/taxi/taxi_mapa/taxi_mapa_controller.dart';
import 'package:app_pasajero_ns/modules/taxi/taxi_reserva/taxi_reserva_controller.dart';
import 'package:app_pasajero_ns/themes/ak_ui.dart';
import 'package:app_pasajero_ns/utils/utils.dart';
import 'package:app_pasajero_ns/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TaxiReservaPage extends StatelessWidget {
  final _conX = Get.put(TaxiReservaController());

  @override
  Widget build(BuildContext context) {
    _conX.setContext(context);

    return Scaffold(
      backgroundColor: akAccentColor,
      body: Column(
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
                  ]),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: akContentPadding),
                    // Selector del Tipo de Reserva
                    _TravelTypeSelector(_conX),
                    SizedBox(height: 20.0),

                    // Mensaje cuando selecciona Ida y Vuelta
                    _LabelBackTrip(_conX),

                    // Selector de fecha
                    _DateSelector(_conX),
                    SizedBox(height: 20.0),

                    // _CarTypeSection(_conX),

                    Content(
                        child: AkText('Selección de ruta',
                            type: AkTextType.subtitle1)),
                    SizedBox(height: 20.0),

                    // Punto de partida
                    Obx(() => _LocationSelector(
                          locationName: _conX.origenName.value,
                          isStart: true,
                          isLoading: _conX.loadingMyPosition.value,
                          onTap: () =>
                              _conX.onLugarSelected(BusquedaView.origen),
                        )),
                    SizedBox(height: 5.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.arrow_downward_rounded,
                          color: akTitleColor.withOpacity(.50),
                        ),
                      ],
                    ),
                    SizedBox(height: 5.0),
                    // Lugar de destino
                    Obx(
                      () => _LocationSelector(
                        locationName: _conX.destinoName.value,
                        isStart: false,
                        isLoading: _conX.loadingMyPosition.value,
                        onTap: () =>
                            _conX.onLugarSelected(BusquedaView.destino),
                      ),
                    ),

                    SizedBox(height: 20.0),

                    // Selector de auto
                    // _CarTypeSection(_conX),
                    // SizedBox(height: 30.0),
                    Content(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _PassengerSection(_conX),
                          SizedBox(height: 20.0),
                          _BaggageSection(_conX),
                          AkText('Comentarios', type: AkTextType.subtitle1),
                          SizedBox(height: 20.0),
                        ],
                      ),
                    ),

                    Content(
                      child: AkButton(
                        fluid: true,
                        onPressed: () {},
                        text: 'Continuar',
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TravelTypeSelector extends StatelessWidget {
  final TaxiReservaController _conX;
  const _TravelTypeSelector(this._conX, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Content(
      child: Obx(() => Row(
            children: [
              _CheckboxType(
                'Solo ida',
                isSelected: _conX.tipoReserva.value == TaxiReservaType.ida,
                onTap: () {
                  _conX.onTipoReservaTap(TaxiReservaType.ida);
                },
              ),
              SizedBox(width: 10.0),
              _CheckboxType(
                'Ida y vuelta',
                isSelected:
                    _conX.tipoReserva.value == TaxiReservaType.idayvuelta,
                onTap: () {
                  _conX.onTipoReservaTap(TaxiReservaType.idayvuelta);
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
  final TaxiReservaController _conX;
  const _LabelBackTrip(this._conX, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => AnimatedSwitcher(
          duration: Duration(milliseconds: 200),
          child: _conX.tipoReserva.value == TaxiReservaType.idayvuelta
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
  final TaxiReservaController _conX;
  const _DateSelector(this._conX, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: akContentPadding * 0.5),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(10.0),
          onTap: _conX.onFechaSelected,
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
                      color: akAccentColor,
                      borderRadius: BorderRadius.circular(7.0)),
                  child: Icon(
                    Icons.calendar_today_outlined,
                    size: akFontSize + 6.0,
                  ),
                ),
                SizedBox(width: 7.0),
                Expanded(
                  child: AkText(
                    'Fecha de ida',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: akTitleColor.withOpacity(.70),
                      fontSize: akFontSize + 2,
                    ),
                  ),
                ),
                Obx(
                  () => _conX.fechaIda.value != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            AkText(
                              DateFormat('EE d MMM', 'es')
                                  .format(_conX.fechaIda.value!),
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: akFontSize + 2,
                                color: akTitleColor,
                              ),
                            ),
                            AkText(
                              DateFormat('hh:mm a').format(
                                  _conX.fechaIda.value!), //_conX.ddd.value,
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

class _LocationSelector extends StatelessWidget {
  final String? locationName;
  final bool isStart;
  final bool isLoading;
  final void Function()? onTap;
  const _LocationSelector(
      {Key? key,
      this.locationName,
      this.isStart = true,
      this.isLoading = false,
      this.onTap})
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
            this.onTap?.call();
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
                      color: isStart ? akPrimaryColor : akAccentColor,
                      borderRadius: BorderRadius.circular(7.0)),
                  child: Icon(
                    isStart ? Icons.my_location : Icons.location_on_outlined,
                    size: akFontSize + 6.0,
                    color: isStart ? akWhiteColor : akPrimaryColor,
                  ),
                ),
                SizedBox(width: 7.0),
                Expanded(
                  child: locationName != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AkText(
                              locationName ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: akTitleColor,
                                fontSize: akFontSize + 1,
                              ),
                            ),
                            SizedBox(height: 3.0),
                            AkText(
                              isStart ? 'Punto de partida' : 'Lugar de destino',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: akTitleColor.withOpacity(.40),
                                fontSize: akFontSize - 1,
                              ),
                            )
                          ],
                        )
                      : Row(
                          children: [
                            Expanded(
                              child: AkText(
                                isStart
                                    ? 'Punto de partida'
                                    : 'Lugar de destino',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: akTitleColor.withOpacity(.70),
                                  fontSize: akFontSize + 2,
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                isLoading
                                    ? Container(
                                        child: SpinLoadingIcon(
                                          color: akPrimaryColor,
                                          size: akFontSize + 2.0,
                                        ),
                                      )
                                    : AkText(
                                        'Selecciona\naquí',
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                          color: akTitleColor.withOpacity(.50),
                                        ),
                                      ),
                              ],
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
  final TaxiReservaController _conX;
  _PassengerSection(this._conX);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AkText('Pasajeros', type: AkTextType.subtitle1),
        _CounterItem('Adultos', _conX.cantAdultos,
            minNumber: 1, subtitle: 'De 13 años o más'),
        _CounterItem('Niños', _conX.cantNinos, subtitle: 'De 2 a 12 años'),
        _CounterItem('Bebés', _conX.cantBebes, subtitle: 'Menos de 2 años'),
      ],
    );
  }
}

class _BaggageSection extends StatelessWidget {
  final TaxiReservaController _conX;
  _BaggageSection(this._conX);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AkText('Equipaje', type: AkTextType.subtitle1),
        _CounterItem('Maletas grandes', _conX.cantMaletasGrandes),
        _CounterItem('Maletas medianas', _conX.cantMaletasMedianas),
        _CounterItem('Mochilas', _conX.cantMochilas),
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

class _CarTypeSection extends StatelessWidget {
  final TaxiReservaController _conX;
  _CarTypeSection(this._conX);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Content(
          child: AkText('Tipo de vehículo', type: AkTextType.subtitle1),
        ),
        SizedBox(height: 15.0),
        SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          child: GetBuilder<TaxiReservaController>(
              id: 'gbListVehiculos',
              builder: (_) {
                List<Widget> items = [];

                _conX.listVehiculos.forEach((item) {
                  items.add(AnimatedSwitcher(
                    duration: Duration(milliseconds: 400),
                    child: _CarSelectionItem(
                      key: ValueKey('vhc_${_conX.idVehiculoSelected}'),
                      isSelected: _conX.idVehiculoSelected == item.id,
                      name: item.model,
                      photoUrl: item.photoUrl,
                      slots: item.slots,
                      onTap: () => _conX.setVehicleSelected(item.id),
                    ),
                  ));
                });

                return Row(
                  children: [
                    SizedBox(width: akContentPadding),
                    ...items,
                  ],
                );
              }),
        ),
        SizedBox(height: 20.0),
      ],
    );
  }
}

class _CarSelectionItem extends StatelessWidget {
  final cardInnerPadding = 13.0;
  final cardRadius = 10.0;
  final double width = Get.width * 0.40;
  final checkSize = 12.0;

  final bool isSelected;
  final String name;
  final int slots;
  final String photoUrl;
  final void Function()? onTap;

  _CarSelectionItem(
      {Key? key,
      this.isSelected = false,
      this.name = '',
      this.slots = 0,
      required this.photoUrl,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Container(
          margin: EdgeInsets.only(right: checkSize),
          decoration: BoxDecoration(
            color: isSelected
                ? akPrimaryColor.withOpacity(.06)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(cardRadius),
            border: Border.all(
                color: isSelected
                    ? akPrimaryColor
                    : akPrimaryColor.withOpacity(
                        .20,
                      )),
          ),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              borderRadius: BorderRadius.circular(cardRadius),
              onTap: () {
                this.onTap?.call();
              },
              child: Container(
                width: width,
                padding: EdgeInsets.only(
                  top: cardInnerPadding * 0.65,
                  bottom: cardInnerPadding * 0.65,
                  left: cardInnerPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: AkText(
                            name,
                            style: TextStyle(
                              fontSize: akFontSize + 2.0,
                              fontWeight: FontWeight.w500,
                              color: isSelected
                                  ? akPrimaryColor
                                  : akPrimaryColor.withOpacity(.75),
                              height: 1.35,
                            ),
                          ),
                        ),
                        Opacity(
                          opacity: isSelected ? 1 : 0.45,
                          child: Stack(
                            children: [
                              Positioned(
                                top: 0,
                                left: 0,
                                bottom: 0,
                                child: FadeInImage.memoryNetwork(
                                  placeholder: kTransparentImage,
                                  imageErrorBuilder: (_, __, ___) => Container(
                                    width: width * 0.5,
                                    child: Center(
                                      child: Icon(
                                        Icons.error,
                                        size: akFontSize + 15.0,
                                        color: Colors.grey.withOpacity(.2),
                                      ),
                                    ),
                                  ),
                                  image: photoUrl,
                                ),
                              ),
                              Container(
                                width: width * 0.48,
                                height: width * 0.45,
                                decoration: BoxDecoration(
                                    // border: Border.all(color: Colors.red),
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.0),
                    Opacity(
                      opacity: isSelected ? 1 : 0.80,
                      child: Container(
                        padding: EdgeInsets.only(right: cardInnerPadding),
                        child: Row(
                          children: [
                            SvgPicture.asset('assets/icons/two_users.svg',
                                width: akFontSize - 3.0,
                                color: akTitleColor.withOpacity(.40)),
                            SizedBox(width: 5.0),
                            Expanded(
                                child: AkText(
                              'Máx. $slots personas',
                              style: TextStyle(
                                  fontSize: akFontSize - 3.0,
                                  color: akTitleColor.withOpacity(.40)),
                            )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        isSelected
            ? Transform.translate(
                offset: Offset(-checkSize * 0.75, 0),
                child: Container(
                  decoration: BoxDecoration(
                    color: akPrimaryColor,
                    borderRadius: BorderRadius.circular(200.0),
                  ),
                  padding: EdgeInsets.all(3.0),
                  child: Icon(
                    Icons.check_rounded,
                    size: checkSize,
                    color: Colors.white,
                  ),
                ),
              )
            : SizedBox(),
      ],
    );
  }
}
