import 'package:app_pasajero_ns/modules/secure/countries/code_countries_es.dart';
import 'package:app_pasajero_ns/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class CountrySelectionController extends GetxController {
  late ScrollController scrollController;
  final gbAppbar = 'gbAppbar';

  final TextEditingController searchCtlr = new TextEditingController();
  final RxBool searchInputIsEmpty = RxBool(false);

  List<Map> paises = [];

  List<Map<dynamic, dynamic>> countries = [];
  List<Map<dynamic, dynamic>> filtered = [];

  String countrySelected = 'PE';

  @override
  void onInit() {
    super.onInit();

    scrollController = ScrollController()
      ..addListener(() {
        update([gbAppbar]);
      });

    if (Get.arguments != null) {
      final selected = Get.arguments['countrySelected'];
      if (selected != null) {
        countrySelected = selected.toString();
      }
    }

    final m = countriesSpanish.where((e) {
      List<String> mainCountries = [
        'AR',
        'BR',
        'CL',
        'CO',
        'EC',
        'PE',
        'UR',
        'UY',
        'VE'
      ];
      if (mainCountries.contains(e['code'])) {
        return true;
      } else {
        return false;
      }
    }).toList();

    final d = m.map((i) {
      Map<dynamic, dynamic> n = {...i};
      n['group'] = '_main';
      n['selected'] = (n['code'] == countrySelected) ? 'true' : 'false';
      return n;
    }).toList();

    final o = countriesSpanish.map((i) {
      Map<dynamic, dynamic> n = {...i};
      n['group'] = '_others';
      n['selected'] = (n['code'] == countrySelected) ? 'true' : 'false';
      return n;
    }).toList();

    countries.addAll(d);
    countries.addAll(o);
    filtered = countries;
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void onSearchChange(String text) {
    final txtClean = removeDiacritics(text);
    final filter = new RegExp(txtClean, caseSensitive: false);
    filtered = countries.where((e) {
      if (e['name'] != null) {
        String countryName = removeDiacritics(e['name']);
        return filter.hasMatch(countryName);
      } else {
        return false;
      }
    }).toList();
    update(['gbList']);
  }

  void sendResponse(String countryCode, String dialCode) async {
    final resp = CountryResponse(countryCode, dialCode);
    Get.focusScope?.unfocus();
    Get.back(result: resp);
  }

  Future<bool> handleBack() async {
    Get.focusScope?.unfocus();
    return true;
  }
}

class CountryResponse {
  final String countryCode;
  final String dialCode;
  CountryResponse(this.countryCode, this.dialCode);
}
