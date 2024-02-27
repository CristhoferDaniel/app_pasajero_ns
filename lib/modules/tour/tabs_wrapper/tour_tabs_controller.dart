import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TourTabsController extends GetxController {
  PageController _pageController = new PageController();
  PageController get pageController => this._pageController;

  int _paginaActual = 0;
  int get paginaActual => this._paginaActual;

  Map<int, GlobalKey<NavigatorState>?> navigatorKeys = {
    0: Get.nestedKey(0),
    1: Get.nestedKey(1),
    2: Get.nestedKey(2),
  };

  void onItemTapped(int i) {
    _paginaActual = i;

    /* _pageController.animateToPage(
      i,
      duration: Duration(milliseconds: 250),
      curve: Curves.easeOut,
    ); */

    _pageController.jumpToPage(i);

    update(['gbBottomNavigations']);
  }
}
