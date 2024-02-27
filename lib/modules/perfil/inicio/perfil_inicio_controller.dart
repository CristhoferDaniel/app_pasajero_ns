import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PerfilInicioController extends GetxController {
  late ScrollController scrollController;
  final gbAppbar = 'gbAppbar';

  @override
  void onInit() {
    super.onInit();

    scrollController = ScrollController()
      ..addListener(() {
        update([gbAppbar]);
      });
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
