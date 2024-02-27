import 'dart:convert';
import 'dart:typed_data';

import 'package:app_pasajero_ns/utils/utils.dart';
import 'package:get/get.dart';

class PerfilPhotoController extends GetxController {
  String title = '';
  Uint8List? imgBytes;
  String imgUrl = '';

  bool isRemoteImage = false;

  @override
  void onInit() {
    super.onInit();

    if (!(Get.arguments is PerfilPhotoArguments)) {
      Helpers.showError('Error pasando los argumentos');
      return;
    }

    final arguments = Get.arguments as PerfilPhotoArguments;
    title = arguments.title;

    final _imgburl = arguments.imageB64orUrl;

    // Comprueba si es imagen base64 o si es una por url.
    isRemoteImage = _imgburl.isURL;

    if (isRemoteImage) {
      imgUrl = _imgburl;
    } else {
      imgBytes = base64.decode(_imgburl);
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}

class PerfilPhotoArguments {
  final String title;
  final String imageB64orUrl;
  const PerfilPhotoArguments(
      {required this.title, required this.imageB64orUrl});
}
