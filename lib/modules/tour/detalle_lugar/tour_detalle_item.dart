import 'package:app_pasajero_ns/data/models/site.dart';
import 'package:app_pasajero_ns/modules/tour/detalle_lugar/tour_detalle_item_controller.dart';
import 'package:app_pasajero_ns/themes/ak_ui.dart';
import 'package:app_pasajero_ns/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TourDetalleItem extends StatelessWidget {
  final TourDetalleItemArguments arguments;

  TourDetalleItem({required this.arguments});

  @override
  Widget build(BuildContext context) {
    final Site site = arguments.site;

    return GetBuilder<TourDetalleItemController>(
      tag: 'TourDetalleItemController_${this.arguments.tabIndex}',
      init: TourDetalleItemController(arguments),
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: Text(
            site.nombre ?? '',
            maxLines: 2,
            textAlign: TextAlign.center,
            style: TextStyle(
                height: .95,
                fontSize: akFontSize - 1.0,
                fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            // onPressed: () => Get.back(id: tabIndex),
            onPressed: _.onBackPressed,
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              size: akDefaultGutterSize + 10.0,
            ),
          ),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImageFade(
                height: Get.size.height * 0.28,
                imageUrl:
                    'https://images.unsplash.com/photo-1609252871434-4e282b868d9a?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
              ),
              SizedBox(height: akContentPadding),
              _container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AkText(
                      site.nombre ?? '',
                      type: AkTextType.h4,
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 7.0),
                    StarsRating(),
                    SizedBox(height: 12.0),
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
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(width: 10.0),
                              Expanded(
                                child: AkText(
                                  site.rangoPrecio ?? '',
                                  type: AkTextType.caption,
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      color: akTextColor.withOpacity(.75)),
                                ),
                              ),
                              SizedBox(width: 7.0),
                              Icon(
                                Icons.sell_outlined,
                                size: akFontSize,
                                color: akTextColor.withOpacity(.75),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 25.0),
                    AkButton(
                      fluid: true,
                      onPressed: () {},
                      text: 'Agregar ruta',
                    ),
                    SizedBox(height: 5.0),
                    AkButton(
                      fluid: true,
                      type: AkButtonType.outline,
                      onPressed: () {},
                      text: 'Contactar',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                padding:
                    EdgeInsets.symmetric(vertical: akContentPadding * 1.75),
                width: double.infinity,
                color: akPrimaryColor.withOpacity(.035),
                child: _container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AkText(
                        'Dirección',
                        type: AkTextType.h6,
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: 5.0),
                      AkText(
                        site.direccion ?? '',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 20.0),
                      AkText(
                        'Mapa del lugar',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: 10.0),
                      AspectRatio(
                        aspectRatio: 6 / 2,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                      'https://i.imgur.com/82IvGWz.png'),
                                  fit: BoxFit.cover),
                              boxShadow: [
                                BoxShadow(
                                    color: akBlackColor.withOpacity(.05),
                                    blurRadius: 5,
                                    offset: Offset(0.0, 4.0))
                              ]),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              _container(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: akContentPadding * 1.5),
                  AkText(
                    'Acerca de',
                    type: AkTextType.h6,
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 5.0),
                  Obx(
                    () => AkText(
                      _.getLorem(),
                      maxLines: _.readMore.value ? null : 3,
                      overflow: _.readMore.value ? null : TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Obx(
                    () => GestureDetector(
                      onTap: _.toggleReadMore,
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 5.0),
                            child: Row(
                              children: [
                                AkText(
                                  _.readMore.value ? 'Leer menos' : 'Leer más',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.underline,
                                      decorationThickness: 2.0,
                                      decorationColor: akTextColor),
                                ),
                                Icon(
                                  _.readMore.value
                                      ? Icons.keyboard_arrow_up_rounded
                                      : Icons.keyboard_arrow_down_rounded,
                                  color: akTextColor,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: akContentPadding * 1.5),
                  AkText(
                    'Actualizado',
                    type: AkTextType.h6,
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 5.0),
                  Obx(() => AkText(_.year.value)),
                  SizedBox(height: akContentPadding * 2),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }

  Widget _container({required Widget child}) {
    return Container(
        padding: EdgeInsets.symmetric(
          horizontal: akContentPadding,
        ),
        child: child);
  }
}
