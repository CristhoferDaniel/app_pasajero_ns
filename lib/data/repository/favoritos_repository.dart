import 'dart:convert';

import 'package:app_pasajero_ns/data/models/favorito.dart';
import 'package:flutter/services.dart';

class FavoritosRepository {
  // final ApiClient apiClient;

  // FavoritesRepository({@required this.apiClient}) : assert(apiClient != null);
  FavoritosRepository();

  Future<List<Favorito>> getAll() async {
    final String favoritesString =
        await rootBundle.loadString('assets/data/favorites.json');

    final resp = (jsonDecode(favoritesString) as List)
        .map((e) => Favorito.fromJson(e))
        .toList();

    return resp;
  }

  Future getId(id) async {
    return 4;
  }
}
