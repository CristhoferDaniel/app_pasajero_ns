import 'package:app_pasajero_ns/data/models/google_suggestion_response.dart';
import 'package:app_pasajero_ns/modules/search_favorites/search_favorites_controller.dart';
import 'package:app_pasajero_ns/modules/taxi/taxi_mapa/components/buscar/widget/prediction_item_list.dart';
import 'package:app_pasajero_ns/themes/ak_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchFavoritesPage extends StatelessWidget {
  final _conX = Get.put(SearchFavoritesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis favoritos'),
        /* leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: akTitleColor,
            size: akFontSize + 4.0,
          ),
        ), */
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(akContentPadding),
            child: Column(
              children: [
                AkText(
                  'Lugares favoritos para una búsqueda más rápida. Mantén presionado para eliminar.',
                  style: TextStyle(color: akTextColor.withOpacity(.65)),
                ),
              ],
            ),
          ),
          Expanded(
            child: GetBuilder<SearchFavoritesController>(
              id: 'gbLista',
              builder: (_) => _buildLista(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLista() {
    if (_conX.lista.isEmpty) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              child: Container(
            padding: EdgeInsets.all(akContentPadding),
            child: AkText(
              'No tienes favoritos agregados.',
              textAlign: TextAlign.center,
              style: TextStyle(color: akTextColor.withOpacity(.50)),
            ),
          )),
        ],
      );
    }

    return ListView.separated(
        separatorBuilder: (_, i) => Container(
              padding:
                  EdgeInsets.symmetric(horizontal: akContentPadding * 0.75),
              child: Divider(
                color: Color(0xFFF6F6F6),
                height: 1,
                thickness: 1,
              ),
            ),
        physics: BouncingScrollPhysics(),
        itemCount: _conX.lista.length,
        itemBuilder: (_, i) {
          if (_conX.lista[i] is Prediction) {
            Prediction prediction = _conX.lista[i];
            String typeIcon =
                prediction.types.isNotEmpty ? prediction.types.first : '';

            return PredictionItemList(
              prediction: prediction,
              typeIcon: typeIcon,
              onFavoriteAdd: (_) {},
              onFavoriteRemove: (_) {},
              onLongPress: (prediction) {
                _conX.onItemLongPress(prediction);
              },
            );
          } else {
            return SizedBox();
          }
        });
  }
}
