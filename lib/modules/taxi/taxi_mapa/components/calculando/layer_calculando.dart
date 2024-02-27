part of '../../taxi_mapa_page.dart';

class _LayerCalculando extends StatelessWidget {
  final TaxiMapaController taxiX;

  const _LayerCalculando({required this.taxiX});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: Colors.transparent),
        _getBottomSection(),
        Obx(() => taxiX.enableBackRecalculating.value
            ? _buildBackButton()
            : SizedBox()),
      ],
    );
  }

  Widget _getBottomSection() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Column(
        children: [
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
            child: Obx(() => _getSkeleton(taxiX.recalculating.value)),
          ),
        ],
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
                // Dejar onTap vacío, es solo para mostrar un bottón
                // El dimmer del modal detectará el gesto para retroceder
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getSkeleton(bool calcultingCost) {
    Widget skeleton = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: calcultingCost ? 0.0 : 10.0),
        calcultingCost
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            AkText(
                              'Confirmando el punto de partida...',
                              style: TextStyle(
                                fontSize: akFontSize + 6.0,
                              ),
                            ),
                            Row(
                              children: [],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 15.0,
                      ),
                      Skeleton(height: 35.0, width: Get.width * 0.25),
                    ],
                  ),
                  SizedBox(height: 15.0),
                  Row(
                    children: [
                      Expanded(
                          flex: 4, child: Skeleton(height: 10.0, fluid: true)),
                      Expanded(flex: 2, child: Container()),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    children: [
                      Expanded(
                          flex: 4, child: Skeleton(height: 10.0, fluid: true)),
                      Expanded(flex: 2, child: Container()),
                    ],
                  )
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          flex: 4, child: Skeleton(height: 35.0, fluid: true)),
                      Expanded(flex: 2, child: Container()),
                      Expanded(
                          flex: 2, child: Skeleton(height: 35.0, fluid: true)),
                    ],
                  ),
                  SizedBox(height: 15.0),
                  Row(
                    children: [
                      Expanded(
                          flex: 1, child: Skeleton(height: 30.0, fluid: true)),
                      Expanded(flex: 2, child: Container()),
                    ],
                  )
                ],
              ),
        SizedBox(height: 15.0),
        Skeleton(
          fluid: true,
          height: 50.0,
        ),
      ],
    );

    return Opacity(opacity: .65, child: skeleton);
  }
}
