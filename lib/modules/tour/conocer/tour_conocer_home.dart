import 'package:app_pasajero_ns/data/models/site.dart';
import 'package:app_pasajero_ns/modules/tour/conocer/tour_conocer_home_controller.dart';
import 'package:app_pasajero_ns/modules/tour/conocer/tour_conocer_routes.dart';
import 'package:app_pasajero_ns/modules/tour/detalle_lugar/tour_detalle_item_controller.dart';
import 'package:app_pasajero_ns/themes/ak_ui.dart';
import 'package:app_pasajero_ns/widgets/widgets.dart';
import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TourConocerHome extends StatelessWidget {
  final int tabIndex;
  TourConocerHome({required this.tabIndex});

  final _conX = Get.put(TourConocerHomeController());

  final options = LiveOptions(
    // Start animation after (default zero)
    delay: Duration(seconds: 6),

    // Show each item through (default 250)
    showItemInterval: Duration(milliseconds: 500),

    // Animation duration (default 250)
    showItemDuration: Duration(seconds: 2),

    // Animations starts at 0.05 visible
    // item fraction in sight (default 0.025)
    visibleFraction: 0.05,

    // Repeat the animation of the appearance
    // when scrolling in the opposite direction (default false)
    // To get the effect as in a showcase for ListView, set true
    reAnimateOnVisibility: false,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conocer'),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            size: akDefaultGutterSize + 10.0,
          ),
        ),
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    return GetBuilder<TourConocerHomeController>(
      builder: (_) {
        if (_conX.fetchError) {
          return Center(
            child: AppError(
              message: _conX.errorMessage,
              onRetry: _conX.retryFetch,
            ),
          );
        }

        if (_conX.fetchFinish) {
          if (_conX.listaSites.isEmpty) {
            return Center(child: Text('No hay resultados'));
          }

          return ListView.builder(
            physics: BouncingScrollPhysics(),
            itemBuilder: (_, int i) {
              return i >= _conX.listaSites.length
                  ? _BottomLoader()
                  : Container(
                      margin: EdgeInsets.only(
                        bottom: 20.0,
                        top: i == 0 ? 0.0 : 0.0,
                      ),
                      child: _ItemItem(
                        site: _conX.listaSites[i],
                        listIndex: i,
                        tabIndex: tabIndex,
                      ),
                    );
            },
            itemCount: _conX.hasReachedMax
                ? _conX.listaSites.length
                : _conX.listaSites.length + 1,
            controller: _conX.scrollController,
          );
        }

        return Center(
          child: _BottomLoader(), // Loading inicial central
        );
      },
    );
  }
}

class _ItemItem extends StatelessWidget {
  final Site site;
  final int listIndex;
  final int tabIndex;

  _ItemItem(
      {required this.site, required this.listIndex, required this.tabIndex});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          Get.toNamed(
            TourConocerRoutes.DETALLE_ITEM,
            id: tabIndex,
            arguments: TourDetalleItemArguments(tabIndex: tabIndex, site: site),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(0.0),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: ImageFade(
                  height: Get.size.height * 0.25,
                  imageUrl:
                      'https://images.unsplash.com/photo-1609252871434-4e282b868d9a?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
                ),
              ),
            ),
            SizedBox(height: akContentPadding),
            Container(
              padding: EdgeInsets.symmetric(horizontal: akContentPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AkText(
                    '${listIndex + 1}. ${site.nombre}',
                    type: AkTextType.h7,
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 4.0),
                  StarsRating(),
                  SizedBox(height: 6.0),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AkText(
                              site.categoria?.nombre ?? '',
                              type: AkTextType.caption,
                              style: TextStyle(
                                  color: akTextColor.withOpacity(.75)),
                            ),
                            SizedBox(height: 6.0),
                            Row(
                              children: [
                                Icon(
                                  Icons.sell_outlined,
                                  size: akFontSize,
                                  color: akTextColor.withOpacity(.75),
                                ),
                                SizedBox(width: 7.0),
                                Expanded(
                                  child: AkText(
                                    site.rangoPrecio ?? '',
                                    type: AkTextType.caption,
                                    style: TextStyle(
                                        color: akTextColor.withOpacity(.75)),
                                  ),
                                ),
                                SizedBox(width: 10.0),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IgnorePointer(
                        child: AkButton(
                          size: AkButtonSize.small,
                          onPressed: () {},
                          text: 'Ver lugar',
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: akContentPadding * 2.5),
            Divider(
              color: Color(0xFFE5E5E5),
              height: 1.0,
              thickness: 1.0,
            ),
          ],
        ),
      ),
    );
  }

  /* Widget _barGradientContainer(bool topToDown, Widget child) {
    final size = Get.size;

    return Container(
      width: size.width,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: topToDown ? Alignment.topCenter : Alignment.bottomCenter,
              end: topToDown ? Alignment.bottomCenter : Alignment.topCenter,
              colors: [
            Colors.black.withOpacity(0.6),
            Colors.black.withOpacity(0.3),
            Colors.black.withOpacity(0.0),
          ])),
      child: Column(
        children: [
          !topToDown
              ? SizedBox(
                  height: 15,
                )
              : SizedBox(),
          child,
          topToDown
              ? SizedBox(
                  height: 35,
                )
              : SizedBox()
        ],
      ),
    );
  } */
}

class _BottomLoader extends StatelessWidget {
  const _BottomLoader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20.0, bottom: 30.0),
      alignment: Alignment.center,
      child: Center(
        child: SizedBox(
          width: 33,
          height: 33,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
            color: akPrimaryColor,
          ),
        ),
      ),
    );
  }
}
