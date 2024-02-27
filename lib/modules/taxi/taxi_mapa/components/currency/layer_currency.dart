import 'package:app_pasajero_ns/modules/app_prefs/app_prefs_controller.dart';
import 'package:app_pasajero_ns/modules/taxi/taxi_mapa/components/currency/layer_currency_ctlr.dart';
import 'package:app_pasajero_ns/themes/ak_ui.dart';
import 'package:app_pasajero_ns/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class LayerCurrency extends StatelessWidget {
  final _appX = Get.find<AppPrefsController>();
  final _conX = Get.put(LayerCurrencyCtlr());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => await _conX.handleBack(),
      child: Scaffold(
        body: Stack(
          children: [
            SliverContainer<LayerCurrencyCtlr>(
              gbAppbarId: _conX.gbAppbar,
              scrollController: _conX.scrollController,
              type: _appX.type,
              title: 'Medios de pago',
              subtitle: 'Seleccione alguna opción',
              onBack: () async {
                if (await _conX.handleBack()) Get.back();
              },
              children: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(height: 20.0),
                            Content(
                              child: AkText(
                                'Métodos de pago',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(height: 5.0),
                            Material(
                              type: MaterialType.transparency,
                              child: InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: akContentPadding,
                                    vertical: 15.0,
                                  ),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/icons/currency.svg',
                                        width: akFontSize + 10.0,
                                      ),
                                      SizedBox(width: 10.0),
                                      Expanded(
                                        child: AkText(
                                          'Efectivo',
                                          style: TextStyle(
                                            color: akTitleColor,
                                            fontWeight: FontWeight.w500,
                                            fontSize: akFontSize + 1.0,
                                          ),
                                        ),
                                      ),
                                      Icon(
                                        Icons.check,
                                        size: akFontSize - 2.0,
                                        color: akSuccessColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20.0),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Obx(() => LoadingOverlay(_conX.loading.value)),
          ],
        ),
      ),
    );
  }
}
