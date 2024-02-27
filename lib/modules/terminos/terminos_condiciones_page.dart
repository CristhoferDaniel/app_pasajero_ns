import 'package:app_pasajero_ns/data/models/app_type.dart';
import 'package:app_pasajero_ns/modules/app_prefs/app_prefs_controller.dart';
import 'package:app_pasajero_ns/modules/terminos/terminos_condiciones_controller.dart';
import 'package:app_pasajero_ns/themes/ak_ui.dart';
import 'package:app_pasajero_ns/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TerminosCondicionesPage extends StatelessWidget {
  final _conX = Get.put(TerminosCondicionesController());
  final _appX = Get.find<AppPrefsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SliverContainer<TerminosCondicionesController>(
        gbAppbarId: _conX.gbAppbar,
        scrollController: _conX.scrollController,
        type: _appX.type,
        title: 'Términos',
        subtitle: 'Revisa nuestros términos y condiciones',
        onBack: () async {
          if (await _conX.handleBack()) Get.back();
        },
        children: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Container(), // No quitar
                      Positioned.fill(
                        child: Obx(
                          () => _conX.showWebview.value
                              ? Container(
                                  padding: EdgeInsets.only(
                                      top: _appX.type == AppType.passenger
                                          ? akContentPadding
                                          : 0.0),
                                  child: /* WebView(
                                    javascriptMode: JavascriptMode.unrestricted,
                                    onWebViewCreated: _conX.onWebviewCreated,
                                  ) */
                                      WebViewWidget(
                                    controller: _conX.webViewController,
                                  ),
                                )
                              : SizedBox(),
                        ),
                      ),
                      _LoadingBuilder(_conX),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: !_conX.showActionButtons
          ? null
          : Container(
              padding: EdgeInsets.all(akContentPadding),
              child: Row(
                children: [
                  Expanded(
                    child: AkButton(
                      fluid: true,
                      type: AkButtonType.outline,
                      enableMargin: false,
                      onPressed: _conX.onRejectTap,
                      text: 'Rechazar',
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Expanded(
                    child: AkButton(
                      fluid: true,
                      enableMargin: false,
                      onPressed: _conX.onAcceptTap,
                      text: 'Aceptar',
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _LoadingBuilder extends StatelessWidget {
  final TerminosCondicionesController conX;
  const _LoadingBuilder(this.conX, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Obx(
        () => AnimatedSwitcher(
          duration: Duration(milliseconds: 400),
          child: conX.webviewLoading.value
              ? /* _LoadingOverlay(
                  text: 'Cargando información...',
                  opacityNumber: 1,
                ) */
              Container(
                  color: akScaffoldBackgroundColor,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SpinLoadingIcon(
                          color: akPrimaryColor,
                        ),
                        SizedBox(height: 100.0),
                      ],
                    ),
                  ),
                )
              : SizedBox(),
        ),
      ),
    );
  }
}
