part of '../../taxi_mapa_page.dart';

class _LayerProgramado extends StatelessWidget {
  final _layerX = Get.find<LayerProgramadoCtlr>();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(.5),
      width: double.infinity,
      height: double.infinity,
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: Get.height * 0.10,
            ),
            Expanded(
              child: SlideInUp(
                duration: Duration(milliseconds: 300),
                child: Container(
                  decoration: BoxDecoration(
                    color: akScaffoldBackgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(akCardBorderRadius * 1.5),
                      topRight: Radius.circular(akCardBorderRadius * 1.5),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF8D8B8B).withOpacity(.20),
                        blurRadius: 12,
                        offset: Offset(0, -6),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              child: Content(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 30.0),
                                    Container(
                                      width: double.infinity,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          FadeIn(
                                            duration:
                                                Duration(milliseconds: 600),
                                            delay: Duration(milliseconds: 400),
                                            child: Container(
                                              width: Get.width * 0.85,
                                              child: Lottie.asset(
                                                'assets/lottie/reservation_ok.json',
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 20.0),
                                    AkText(
                                      'Reserva programada!',
                                      style: TextStyle(
                                        fontSize: akFontSize + 6.0,
                                        color: akTitleColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 10.0),
                                    AkText(
                                      "Dentro de poco asignaremos un conductor a tu reserva. Puedes revisar los detalles desde la opción 'Mis viajes'.",
                                      style: TextStyle(
                                        fontSize: akFontSize,
                                      ),
                                    ),
                                    SizedBox(height: 25.0),
                                  ],
                                ),
                              ),
                            ),
                            _DividerLine(),
                            SizedBox(height: 15.0),
                            InfoRuta(
                              origenName: _layerX.taxiMapaX.tarifaOrigenName,
                              destinoName: _layerX.taxiMapaX.tarifaDestinoName,
                              fechaReserva: _layerX.taxiMapaX.fechaIda.value,
                            ),

                            _layerX.taxiMapaX.tipoReserva.value ==
                                    TaxiReservaType.idayvuelta
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 15.0),
                                      _DividerLine(),
                                      SizedBox(height: 15.0),
                                      InfoRuta(
                                        vuelta: true,
                                        origenName:
                                            _layerX.taxiMapaX.tarifaDestinoName,
                                        destinoName:
                                            _layerX.taxiMapaX.tarifaOrigenName,
                                        fechaReserva:
                                            _layerX.taxiMapaX.fechaVuelta.value,
                                      ),
                                    ],
                                  )
                                : SizedBox(),
                            SizedBox(height: 15.0),
                            // NO RETIRAR EL SIZEDBOX.
                            // Sirve de espacio para que el bottom button no tape la lista
                            SizedBox(height: 80.0),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              height: 15.0,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    akScaffoldBackgroundColor.withOpacity(0),
                                    akScaffoldBackgroundColor.withOpacity(0.5),
                                    akScaffoldBackgroundColor,
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              color: akScaffoldBackgroundColor,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 15.0),
                                child: Content(
                                  child: Material(
                                    type: MaterialType.transparency,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(
                                          akBtnBorderRadius),
                                      onTap: _layerX.onOkButtonTap,
                                      child: Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 16.0, horizontal: 16.0),
                                        decoration: BoxDecoration(
                                          color: akPrimaryColor.withOpacity(.1),
                                          borderRadius:
                                              akBtnBorderRadiusGeometry,
                                        ),
                                        child: AkText(
                                          'Entendido',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: akPrimaryColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
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
          ],
        ),
      ),
    );
  }
}

class _DividerLine extends StatelessWidget {
  const _DividerLine({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(
          height: 1,
          thickness: 1,
          color: Color(0xFFF9F9FD),
        ),
        Divider(
          height: 1,
          thickness: 1,
          color: Color(0xFFECEDF9),
        ),
      ],
    );
  }
}
