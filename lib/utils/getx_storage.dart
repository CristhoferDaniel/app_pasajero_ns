import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:get_storage/get_storage.dart'; // Importa get_storage

class GetxStorageController extends GetxController {
  final RxString userId = ''.obs;

  // Utiliza GetStorage para manejar el almacenamiento local
  final GetStorage _box = GetStorage('app_data');

  Future<void> save(String key, value) async {
    try {
      String jsonValue = json.encode(value);
      await _box.write(key, jsonValue);
      print("Saved $key: $jsonValue");
    } catch (e) {
      print("Error saving $key: $e");
    }
  }

  Future<dynamic> read(String key) async {
    String? value = _box.read(key);
    if (value == null) return null;
    return json.decode(value);
  }

  Future<bool> contains(String key) async {
    return _box.hasData(key);
  }

  Future<void> remove(String key) async {
    return _box.remove(key);
  }

  void logout(BuildContext context) async {
    await remove('token');
  }
}
