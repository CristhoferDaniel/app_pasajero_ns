part of 'utils.dart';

enum SnackBarVariant { primary, success, error, info, warning }

class Helpers {
  static Future<void> sleep(int milliseconds) async {
    await Future.delayed(Duration(milliseconds: milliseconds));
  }

  static final logger = Logger(
    printer: PrettyPrinter(
        methodCount: 2, // number of method calls to be displayed
        errorMethodCount: 8, // number of method calls if stacktrace is provided
        lineLength: 120, // width of the output
        colors: true, // Colorful log messages
        printEmojis: true, // Print an emoji for each log message
        printTime: false // Should each log print contain a timestamp
        ),
  );

  static void showError(String message, {String? devError}) async {
    Helpers.logger.e(devError ?? message);
    Future.delayed(Duration(milliseconds: 200))
        .then((value) => AppSnackbar().error(message: message));
  }

  static String removeTagHTML({htmlString, callback}) {
    String parsedString = '';
    try {
      var document = htmlLib.parse(htmlString);
      parsedString = htmlLib.parse(document.body?.text).documentElement!.text;
    } catch (e) {
      parsedString = htmlString;
    }
    return parsedString;
  }

  static void snackbar(
      {String? title,
      String message = '',
      SnackBarVariant variant = SnackBarVariant.info,
      bool hideIcon = false,
      SnackPosition snackPosition = SnackPosition.BOTTOM,
      bool snackMini = false}) {
    Color color = akPrimaryColor;
    IconData icon = Icons.android;
    String titleMsg = '';
    switch (variant) {
      case SnackBarVariant.primary:
        color = akPrimaryColor;
        icon = Icons.check;
        titleMsg = title ?? 'Mensaje';
        break;
      case SnackBarVariant.success:
        color = akSuccessColor;
        icon = Icons.check;
        titleMsg = title ?? 'Exitoso';
        break;
      case SnackBarVariant.error:
        color = akErrorColor;
        icon = Icons.error;
        titleMsg = title ?? 'Hubo un error';
        break;
      case SnackBarVariant.info:
        color = akInfoColor;
        icon = Icons.info;
        titleMsg = title ?? 'Mensaje';
        break;
      case SnackBarVariant.warning:
        color = akWarningColor;
        icon = Icons.warning;
        titleMsg = title ?? 'Advertencia';
        break;
    }

    if (snackMini) {
      Get.snackbar(
        '',
        '',
        margin: EdgeInsets.all(0),
        snackPosition: snackPosition,
        messageText: Center(
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6), color: color),
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            child: AkText(
              message,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        titleText: SizedBox(),
        backgroundColor: Colors.transparent,
      );
      return;
    }

    if (hideIcon) {
      Get.snackbar(
        titleMsg,
        message,
        colorText: Colors.white,
        backgroundColor: color,
        snackPosition: SnackPosition.BOTTOM,
        borderRadius: akRadiusSnackbar,
        margin: EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 10),
      );
    } else {
      Get.snackbar(
        titleMsg,
        message,
        colorText: Colors.white,
        backgroundColor: color,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 10),
        borderRadius: akRadiusSnackbar,
        icon: Icon(icon, color: Colors.white),
      );
    }
  }

  static Future<bool> confirmCloseAppDialog() async {
    return await Get.dialog(
        AlertDialog(
          content: Text('¿Desea cerrar la aplicación?'),
          actions: [
            MaterialButton(
              child: Text('SI'),
              onPressed: () {
                Get.back(result: true);
              },
            ),
            MaterialButton(
              child: Text('NO'),
              onPressed: () {
                Get.back(result: false);
              },
            )
          ],
        ),
        barrierDismissible: false);
  }

  static Future<bool?> confirmDialog(String message) async {
    return await Get.dialog(
        AlertDialog(
          content: Text(message),
          actions: [
            MaterialButton(
              child: Text('SI'),
              onPressed: () {
                Get.back(result: true);
              },
            ),
            MaterialButton(
              child: Text('NO'),
              onPressed: () {
                Get.back(result: false);
              },
            )
          ],
        ),
        barrierDismissible: false);
  }

  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  static String capitalizeFirstLetter(String s) =>
      s.isNotEmpty ? '${s[0].toUpperCase()}${s.substring(1).toLowerCase()}' : s;

  static String nameFormatCase(String name) {
    final parts = name.split(' ');
    final capitalizeParts = parts.map((p) => capitalizeFirstLetter(p));
    return capitalizeParts.join(' ').trim();
  }

  static String getObfuscateEmail(String completeEmail) {
    List<String> arrs = completeEmail.split('@');
    if (arrs.length == 2) {
      String firstPart = arrs[0];
      String obfuscateFp = '';
      int fpLength = firstPart.length;
      if (fpLength >= 5) {
        int middleCount = fpLength - 4;
        obfuscateFp = '${firstPart[0]}${firstPart[1]}';
        for (var i = 0; i < middleCount; i++) {
          obfuscateFp += '*';
        }
        obfuscateFp +=
            '${firstPart[fpLength - 2]}${firstPart[fpLength - 1]}@${arrs[1]}';
      } else if (fpLength >= 3) {
        int middleCount = fpLength - 2;
        obfuscateFp = '${firstPart[0]}';
        for (var i = 0; i < middleCount; i++) {
          obfuscateFp += '*';
        }
        obfuscateFp += '${firstPart[fpLength - 1]}@${arrs[1]}';
      } else {
        obfuscateFp = completeEmail;
      }
      return obfuscateFp;
    } else {
      return completeEmail;
    }
  }

  static Color darken(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  static Color lighten(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslLight =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }

  static Future<BitmapDescriptor?> getCustomIcon(GlobalKey iconKey) async {
    Future<Uint8List?> _capturePng(GlobalKey iconKey) async {
      try {
        final renderObject = iconKey.currentContext?.findRenderObject();

        if (renderObject != null) {
          RenderRepaintBoundary boundary =
              renderObject as RenderRepaintBoundary;
          ui.Image image = await boundary.toImage(pixelRatio: 3.0);
          ByteData? byteData =
              await image.toByteData(format: ui.ImageByteFormat.png);
          if (byteData != null) {
            var pngBytes = byteData.buffer.asUint8List();
            return pngBytes;
          }
        }
      } catch (e) {
        print(e);
      }
    }

    Uint8List? imageData = await _capturePng(iconKey);
    if (imageData != null) {
      return BitmapDescriptor.fromBytes(imageData);
    }
  }

  /// Obtiene la primera parte del nombre largo de una ruta
  ///
  /// Ejemplo:
  ///
  /// Av. San Juan, Lima, Peru --> Av. San Juan
  static String shortStreetName(String text) {
    final parts = text.split(',');

    if (parts.length >= 2) {
      return parts[0];
    } else {
      return text;
    }
  }

  static String getShortName(bool isLastName, String name) {
    String result = '';
    // Remueve los múltiples espacios
    final sanitizeStr = name.replaceAll(RegExp(' +'), ' ').trim();
    // Separa las nombres
    final arr = sanitizeStr.split(' ');
    result = arr[0];
    if (isLastName) {
      if (result.length <= 4) {
        if (arr.length > 2) {
          // Para apellidos como: La Rosa, Del Castillo
          result = result + ' ' + arr[1];
        }
      }
    }
    return result;
  }

  static int random(int min, int max) {
    return min + Random().nextInt(max - min);
  }
}

/* 
Future<void> _showDia() async {
    Widget dialog = AlertDialog(
      elevation: 0,
      insetPadding: EdgeInsets.all(0.0),
      contentPadding: EdgeInsets.all(0.0),
      actionsOverflowButtonSpacing: 0.0,
      backgroundColor: Colors.transparent,
      content: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(akCardBorderRadius)),
        width: Get.size.width - 60.0,
        padding: EdgeInsets.all(akContentPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.0),
            Container(
              width: double.infinity,
              child: AkText(
                'Sincronizar cuentas',
                type: AkTextType.h7,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20.0),
            AkText(
              'Parece que ya tienes una cuenta creada.',
              type: AkTextType.subtitle,
            ),
            SizedBox(height: 15.0),
            AkText(
              'Inicia sesión para continuar.',
              type: AkTextType.subtitle,
            ),
            SizedBox(height: 15.0),
            AkText(
              '¿Deseas continuar?',
              type: AkTextType.subtitle,
            ),
            SizedBox(height: 30.0),
            Row(
              children: [
                Expanded(
                  child: AkButton(
                    variant: AkButtonVariant.primary,
                    type: AkButtonType.outline,
                    enableMargin: false,
                    fluid: true,
                    onPressed: () => Get.back(),
                    text: 'No',
                  ),
                ),
                SizedBox(width: 5.0),
                Expanded(
                  child: AkButton(
                    variant: AkButtonVariant.primary,
                    enableMargin: false,
                    fluid: true,
                    onPressed: () => Get.back(result: true),
                    text: 'Sí',
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );

    final dialogResp = await Get.dialog(
      WillPopScope(
        onWillPop: () async => false,
        child: dialog,
      ),
      useSafeArea: false,
    );
    final val = dialogResp ?? false;
    print('vall $val');
  } */