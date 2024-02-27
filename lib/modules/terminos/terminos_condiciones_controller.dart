import 'dart:async';
import 'dart:convert';

import 'package:app_pasajero_ns/data/providers/tc_cliente_provider.dart';
import 'package:app_pasajero_ns/modules/misc/error/misc_error_controller.dart';
import 'package:app_pasajero_ns/routes/app_pages.dart';
import 'package:app_pasajero_ns/themes/ak_ui.dart';
import 'package:app_pasajero_ns/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TerminosCondicionesController extends GetxController {
  // Instances
  late TerminosCondicionesController _self;

  late ScrollController scrollController;
  final gbAppbar = 'gbAppbar';

  final _tcClienteProvider = TCClienteProvider();

  final _webviewController = Completer<WebViewController>();

  final showWebview = false.obs;
  final webviewLoading = true.obs;

  bool showActionButtons = false;

  get webViewController => null;

  @override
  void onInit() {
    super.onInit();
    _self = this;

    scrollController = ScrollController()
      ..addListener(() {
        update([gbAppbar]);
      });

    _init();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  Future<void> _init() async {
    if (!(Get.arguments is TerminosCondicionesControllerArguments)) {
      Helpers.showError('Error pasando los argumentos');
      return;
    }

    final arguments = Get.arguments as TerminosCondicionesControllerArguments;
    showActionButtons = arguments.showActionButtons;

    _fetchInfo();
  }

  String dataVPSI = '';
  Future<void> _fetchInfo() async {
    String? errorMsg;
    try {
      webviewLoading.value = true;
      await Helpers.sleep(500);
      final resp = await _tcClienteProvider.getHtmlText();
      dataVPSI = resp.contenido;
    } on ApiException catch (e) {
      errorMsg = e.message;
      Helpers.logger.e(e.message);
    } catch (e) {
      errorMsg = 'Ocurrió un error inesperado.';
      Helpers.logger.e(e.toString());
    }

    if (_self.isClosed) return;
    if (errorMsg != null) {
      final ers = await Get.toNamed(AppRoutes.MISC_ERROR,
          arguments: MiscErrorArguments(content: errorMsg));
      if (ers == MiscErrorResult.retry) {
        await Helpers.sleep(2500);
        _fetchInfo();
      } else {
        Get.back();
      }
    } else {
      showWebview.value = true;
    }
  }

  Future<bool> handleBack() async {
    // if (loading.value) return false;
    Get.focusScope?.unfocus();
    return true;
  }

  // **** Begin::Funciones webview ***************
  Future<void> onWebviewCreated(WebViewController controller) async {
    _webviewController.complete(controller);
    await (await _webviewController.future).clearCache();

    final String contentBase64 =
        base64Encode(const Utf8Encoder().convert(_buildHtmlBody()));

    // Utiliza loadUrl en lugar de loadUrl
    await (await _webviewController.future)
        .loadRequest('data:text/html;base64,$contentBase64' as Uri);

    await Helpers.sleep(1000);
    webviewLoading.value = false;
  }

  String _buildHtmlBody() {
    final hexValue = akScaffoldBackgroundColor.value.toRadixString(16);
    final hexColor = '#${hexValue.substring(2, hexValue.length)}';
    final akCP = akContentPadding.toInt() - 6.0;
    return '''<!DOCTYPE html>
      <html lang="en">
      <head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Document</title>
      </head>
      <style>
        body {
          background-color: $hexColor;
          font-family: sans-serif;
          color: rgba(12, 32, 67, 0.6);
          padding-left: $akCP''' +
        '''px;
          padding-right: $akCP''' +
        '''px;
          padding-bottom: $akCP''' +
        '''px;
        }
        h1, h2, h3, h4, h5, h6 {
          color: rgba(12, 32, 67, 1);
        }
        img {
          width: 100% !important;
        }
      </style>
      <body>
        $dataVPSI
      </body>
      </html>''';
  }

  void onRejectTap() {
    Get.back(result: false);
  }

  void onAcceptTap() {
    Get.back(result: true);
  }
}

class TerminosCondicionesControllerArguments {
  final bool showActionButtons;
  const TerminosCondicionesControllerArguments(
      {required this.showActionButtons});
}
