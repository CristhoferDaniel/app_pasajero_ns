import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LayerCurrencyCtlr extends GetxController {
  late ScrollController scrollController;

  final loading = false.obs;

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

  Future<bool> handleBack() async {
    if (loading.value) return false;
    Get.focusScope?.unfocus();
    return true;
  }
}
