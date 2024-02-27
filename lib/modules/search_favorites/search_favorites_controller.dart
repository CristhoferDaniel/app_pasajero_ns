import 'dart:convert';

import 'package:app_pasajero_ns/data/models/google_suggestion_response.dart';
import 'package:app_pasajero_ns/modules/auth/auth_controller.dart';
import 'package:app_pasajero_ns/utils/utils.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SearchFavoritesController extends GetxController {
  final _authX = AuthController();
  GetStorage? box;

  List<Prediction> _lista = [];
  List<Prediction> get lista => this._lista;

  @override
  void onInit() {
    super.onInit();
    _initStorage();
  }

  Future<void> _initStorage() async {
    box = GetStorage();
    if (box != null) {
      final userUid = box!.read('user_uid');
      if (userUid != _authX.getUser!.uid) {
        await box!.write('user_uid', _authX.getUser!.uid);
        await box!.write('search_favorites', null);
      }
    }
    listItems();
  }

  Future<void> listItems() async {
    final List<Prediction> favoritos = [];
    try {
      final favStorageString = box!.read('search_favorites');
      final favList = Map<String, Prediction>();
      if (favStorageString != null) {
        final decoded = jsonDecode(favStorageString) as Map<String, dynamic>;
        favList.addAll(decoded.map<String, Prediction>(
            (key, value) => MapEntry(key, Prediction.fromJson(value))));
      }
      favList.forEach((key, value) {
        final castPrediction = value;

        favoritos.add(castPrediction);
      });
      this._lista = [...favoritos];
    } catch (e) {
      Helpers.logger.e(e.toString());
    }
    update(['gbLista']);
  }

  Future<void> onItemLongPress(Prediction prediction) async {
    final exitAppConfirm =
        await Helpers.confirmDialog('¿Deseas eliminar el favorito?');
    if (exitAppConfirm != null && exitAppConfirm) {
      await onFavoriteRemove(prediction);
      listItems();
    }
  }

  Future<void> onFavoriteRemove(Prediction prediction) async {
    if (box != null) {
      try {
        final favStorageString = box!.read('search_favorites');
        if (favStorageString != null) {
          final decoded = jsonDecode(favStorageString) as Map<String, dynamic>;
          var castList = decoded.map<String, Prediction>(
              (key, value) => MapEntry(key, Prediction.fromJson(value)));
          castList.remove(prediction.placeId);
          final encodeFavList = jsonEncode(castList);
          await box!.write('search_favorites', encodeFavList);
        }
      } catch (e) {
        Helpers.logger.e(e.toString());
      }
    }
  }
}
