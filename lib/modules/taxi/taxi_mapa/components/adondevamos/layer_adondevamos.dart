part of '../../taxi_mapa_page.dart';

class _LayerAdondeVamos extends StatelessWidget {
  final _layerX = Get.find<LayerAdondeVamosCtlr>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildWhereWeGoButton(),
        Positioned(
          top: 0,
          right: 0,
          left: 0,
          child: SafeArea(
            child: Container(
              width: Get.width,
              padding: EdgeInsets.symmetric(
                  horizontal: akContentPadding * 0.5,
                  vertical: akContentPadding * 1.35),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CommonButtonMap(
                    icon: Icons.arrow_back_rounded,
                    onTap: () async {
                      if (await _layerX.taxiMapaX.handleBack()) Get.back();
                    },
                  ),
                  /* CommonButtonMap(
                    child: Row(
                      children: [
                        AkText(
                          'Cupón descuento'.toUpperCase(),
                          style: TextStyle(
                              fontSize: akFontSize - 4.0,
                              fontWeight: FontWeight.w500,
                              color: akTitleColor.withOpacity(.75)),
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
                      final resp = await Get.toNamed(AppRoutes.CUPONES);
                      print('Respuesta de cupones $resp');
                    },
                  ), */
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWhereWeGoButton() {
    Widget actions = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 2.0),
        AkText(
          '¿A dónde vamos?',
          type: AkTextType.h7,
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 12.0),
        GestureDetector(
          onTap: () async {
            _layerX.onWhereWeGoTap();
          },
          child: Row(
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
                        child: AkText(
                          'Escribe tu destino',
                          style: TextStyle(color: akTextColor.withOpacity(.56)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
        ),
        SizedBox(height: 7.0),
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
                  onTap: _layerX.taxiMapaX.centerToMyPosition,
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
              boxShadow: TaxiMapaPage.cardShadows,
            ),
            width: double.infinity,
            padding: EdgeInsets.all(akContentPadding),
            child: actions,
          ),
        ],
      ),
    );
  }
}
