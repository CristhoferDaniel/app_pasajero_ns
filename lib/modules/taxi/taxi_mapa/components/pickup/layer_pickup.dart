part of '../../taxi_mapa_page.dart';

class _LayerPickup extends StatelessWidget {
  final _layerX = Get.find<LayerPickupCtlr>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: _CardConfirmPickup(
            onCenterActionTap: _layerX.taxiMapaX.centerToMyPosition,
            onConfirmButtonTap: _layerX.onConfirmPickUp,
            cardStyle: true,
            labelChild: Obx(
              () => _AdressLabel(
                text: _layerX.taxiMapaX.pickupAddressName.value,
                loading: _layerX.taxiMapaX.searchingAddressFromPick.value,
              ),
            ),
          ),
        ),
        _buildBackButton(),
        Container(
          child: _buildMarkerCentral(),
        ),
      ],
    );
  }

  Widget _buildMarkerCentral() {
    return Obx(
      () => Center(
        child: Transform.translate(
          offset: Offset(0, -78),
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
              child: !_layerX.taxiMapaX.movingPickMap.value
                  ? BadgeMapPin(
                      key: ValueKey<String>('mark1'),
                      moving: _layerX.taxiMapaX.movingPickMap.value,
                    )
                  : BadgeMapPin(
                      key: ValueKey<String>('mark2'),
                      moving: _layerX.taxiMapaX.movingPickMap.value,
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return Positioned(
      top: 0,
      right: 0,
      left: 0,
      child: SafeArea(
        child: Container(
          width: Get.width,
          padding: EdgeInsets.symmetric(
              horizontal: akContentPadding * 0.5,
              vertical: akContentPadding * 1.25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CommonButtonMap(
                icon: Icons.arrow_back_rounded,
                onTap: _layerX.taxiMapaX.handleBack,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardConfirmPickup extends StatelessWidget {
  final bool cardStyle;
  final void Function()? onCenterActionTap;
  final void Function()? onConfirmButtonTap;
  final Widget labelChild;

  const _CardConfirmPickup({
    Key? key,
    this.onCenterActionTap,
    this.onConfirmButtonTap,
    this.cardStyle = false,
    required this.labelChild,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  right: akContentPadding, bottom: akContentPadding * 0.5),
              child: CommonButtonMap(
                icon: Icons.my_location,
                onTap: () {
                  onCenterActionTap?.call();
                },
              ),
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            color: cardStyle ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(akCardBorderRadius * 1.5),
              topRight: Radius.circular(akCardBorderRadius * 1.5),
            ),
            boxShadow: cardStyle ? TaxiMapaPage.cardShadows : [],
          ),
          width: double.infinity,
          padding: EdgeInsets.only(
            top: cardStyle ? akContentPadding : 0.0,
            bottom: akContentPadding,
            left: akContentPadding,
            right: akContentPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              cardStyle ? labelChild : SizedBox(),
              AkButton(
                fluid: true,
                enableMargin: false,
                text: 'Confirmar',
                onPressed: () {
                  onConfirmButtonTap?.call();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AdressLabel extends StatelessWidget {
  final String text;
  final bool loading;

  const _AdressLabel({Key? key, required this.text, this.loading = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AkText(
          'Confirma tu punto de recogida',
          type: AkTextType.h9,
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 12.0),
        Container(
          padding: EdgeInsets.all(akIptFactorPadding * akFontSize),
          decoration: BoxDecoration(
              color: Color(0xFFF5F6FA),
              borderRadius: BorderRadius.circular(akIptBorderRadius)),
          child: Row(
            children: [
              Expanded(
                child: AkText(
                  text,
                  style: TextStyle(
                    color: loading
                        ? akTextColor.withOpacity(.5)
                        : akTitleColor.withOpacity(.70),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(
                width: 15.0,
              ),
              loading
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3.0),
                      child: SpinLoadingIcon(
                        size: akFontSize + 2.0,
                        color: akTextColor.withOpacity(.5),
                      ),
                    )
                  : Icon(
                      Icons.location_history_outlined,
                      color: akTextColor,
                      size: akFontSize + 8.0,
                    ),
            ],
          ),
        ),
        SizedBox(height: 12.0),
      ],
    );
  }
}

class CardCalculatingNewPrice extends StatelessWidget {
  const CardCalculatingNewPrice({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(akCardBorderRadius * 1.5),
          topRight: Radius.circular(akCardBorderRadius * 1.5),
        ),
        boxShadow: TaxiMapaPage.cardShadows,
      ),
      padding: EdgeInsets.all(akContentPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 10.0),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AkText(
                      'Calculando punto de partida...',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: akFontSize + 8.0,
                        color: akTitleColor,
                      ),
                    ),
                    SizedBox(height: 15.0),
                    Opacity(
                        opacity: .65,
                        child: Skeleton(height: 20.0, width: Get.width * 0.25)),
                  ],
                ),
              ),
              SizedBox(width: 20.0),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: Get.width * 0.25,
                    height: Get.width * 0.25,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Get.width),
                      color: Helpers.darken(
                        akScaffoldBackgroundColor,
                        0.05,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -5,
                    right: -20,
                    left: 0,
                    child: Icon(
                      Icons.alt_route,
                      size: Get.width * 0.22,
                      color: Colors.transparent,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 15.0),
          Container(
            width: double.infinity,
            child: Opacity(
              opacity: .65,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Skeleton(height: 10.0, width: Get.width * 0.60),
                  SizedBox(height: 10.0),
                  Skeleton(height: 10.0, width: Get.width * 0.60),
                  SizedBox(height: 10.0),
                  Skeleton(height: 10.0, width: Get.width * 0.50),
                  SizedBox(height: 20.0),
                  Skeleton(height: 40.0, fluid: true),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CardNewPrice extends StatelessWidget {
  final String amount;
  final Function() onConfirmTap;

  const CardNewPrice(
      {Key? key, required this.amount, required this.onConfirmTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(akCardBorderRadius * 1.5),
          topRight: Radius.circular(akCardBorderRadius * 1.5),
        ),
        boxShadow: TaxiMapaPage.cardShadows,
      ),
      padding: EdgeInsets.all(akContentPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 10.0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: akFontSize * 0.5),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AkText(
                        'Confirmar la tarifa nueva',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: akFontSize + 8.0,
                          color: akTitleColor,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      AkText(
                        'S/ $amount',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: akFontSize + 8.0,
                          color: akTitleColor,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 20.0),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: Get.width * 0.25,
                      height: Get.width * 0.25,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Get.width),
                        color: Helpers.darken(
                          akScaffoldBackgroundColor,
                          0.05,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -5,
                      right: -20,
                      left: 0,
                      child: Icon(
                        Icons.alt_route,
                        size: Get.width * 0.22,
                        color: akSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 15.0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: akFontSize * 0.5),
            child: AkText(
                'La tarifa aproximada se actualizó según el punto de recogida.',
                type: AkTextType.body1,
                style: TextStyle(color: akTextColor.withOpacity(.65))),
          ),
          SizedBox(height: 25.0),
          Row(
            children: [
              Expanded(
                child: AkButton(
                  enableMargin: false,
                  elevation: 0.0,
                  onPressed: () => onConfirmTap.call(),
                  text: 'Confirmar tarifa',
                  fluid: true,
                ),
              ),
            ],
          ),
          SizedBox(height: 0.0)
        ],
      ),
    );
  }
}
