import 'dart:async';
import 'dart:convert';

import 'package:app_pasajero_ns/data/models/google_suggestion_response.dart';
import 'package:app_pasajero_ns/modules/taxi/taxi_mapa/taxi_mapa_controller.dart';
import 'package:app_pasajero_ns/utils/utils.dart';
import 'package:app_pasajero_ns/widgets/widgets.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LayerBuscarCtlr extends GetxController {
  // _keyX = Get.find<KeyboardController>();
  final taxiMapaX = Get.find<TaxiMapaController>();

  // Dio
  CancelToken cancelToken = CancelToken();

  // GetBuilders ID's
  final gbResultados = 'gbResultados';

  // *******************************************
  // ****** LÓGICA DE BUSCAR DIRECCIONES *******
  // *******************************************
  bool showItemListPlaceHolder = true;
  final isSearchResultListVisible = true.obs;

  // Variables
  final tituloAppBar = '-'.obs;
  final paddingBottomResultList = (0.0).obs;
  BusquedaView _busquedaView = BusquedaView.destino;
  BusquedaView get busquedaView => _busquedaView;

// Search List variables
  final searchText = ''.obs;
  List<Prediction> _sugerencias = [];
  List<Prediction> get sugerencias => this._sugerencias;

  // Search UI Variables
  bool loadingSearchPrediction = false;
  bool errorSearchingPrediction = false;
  StreamSubscription<List<Prediction>>? _predictionsStreamSub;

  final focusNodeOrigen = FocusNode();
  final focusNodeDestino = FocusNode();
  final origenCtlr = TextEditingController();
  final destinoCtlr = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _init();
  }

  void onClose() {
    focusNodeOrigen.removeListener(_onOrigenFocus);
    focusNodeDestino.removeListener(_onDestinoFocus);

    if (!cancelToken.isCancelled) cancelToken.cancel();
    _predictionsStreamSub?.cancel();

    super.onClose();
  }

  Future<void> _init() async {
    focusNodeOrigen.addListener(_onOrigenFocus);
    focusNodeDestino.addListener(_onDestinoFocus);

    debounce(searchText, (txt) {
      searchAddressFromText(txt.toString());
    }, time: Duration(milliseconds: 1000));

    /*  ever<double>(_keyX.keyboardHeight, (kheight) {
      paddingBottomResultList.value = kheight;
    });*/
  }

  void setSearchText(String text) {
    searchText.value = text;
  }

  //*** METHODS ****/
  Future<void> onItemListTap(Prediction prediction) async {
    if (_busquedaView == BusquedaView.origen) {
      taxiMapaX.confirmedPickup = false;
      _updateInputOrigen(
          address: prediction.structuredFormatting.mainText,
          placeId: prediction.placeId);
    } else {
      _updateInputDestino(
          address: prediction.structuredFormatting.mainText,
          placeId: prediction.placeId);
    }

    validateInputs();
  }

  Future<void> onManualMapItemTap() async {
    Get.focusScope?.unfocus();
    taxiMapaX.resetPickUpVariables();
    await taxiMapaX.showHideMarkersPolyline(false);
    isSearchResultListVisible.value = false;

    // No eliminar el sleep
    if (taxiMapaX.tarifaDisplayed) {
      if (_busquedaView == BusquedaView.origen) {
        origenCtlr.text = taxiMapaX.tarifaOrigenName;
        taxiMapaX.lastPositionOnMoving = LatLng(
            taxiMapaX.tarifaOrigenCoords!.latitude,
            taxiMapaX.tarifaOrigenCoords!.longitude);
        await Helpers.sleep(300);
        taxiMapaX.centerTo(LatLng(taxiMapaX.tarifaOrigenCoords!.latitude,
            taxiMapaX.tarifaOrigenCoords!.longitude));
      } else {
        destinoCtlr.text = taxiMapaX.tarifaDestinoName;
        taxiMapaX.lastPositionOnMoving = LatLng(
            taxiMapaX.tarifaDestinoCoords!.latitude,
            taxiMapaX.tarifaDestinoCoords!.longitude);
        await Helpers.sleep(300);
        taxiMapaX.centerTo(LatLng(taxiMapaX.tarifaDestinoCoords!.latitude,
            taxiMapaX.tarifaDestinoCoords!.longitude));
      }
    } else {
      if (_busquedaView == BusquedaView.origen) {
        origenCtlr.text = taxiMapaX.myPositonName;
        taxiMapaX.lastPositionOnMoving = LatLng(
            taxiMapaX.myPosition.latitude, taxiMapaX.myPosition.longitude);
      } else {
        destinoCtlr.text = taxiMapaX.myPositonName;
        taxiMapaX.lastPositionOnMoving = LatLng(
            taxiMapaX.myPosition.latitude, taxiMapaX.myPosition.longitude);
      }
      await Helpers.sleep(300); // No eliminar
      taxiMapaX.centerToMyPosition();
    }
  }

  Future<void> onFavoriteAdd(Prediction prediction) async {
    if (taxiMapaX.box != null) {
      try {
        final favStorageString = taxiMapaX.box!.read('search_favorites');
        final favList = Map<String, Prediction>();
        if (favStorageString != null) {
          final decoded = jsonDecode(favStorageString) as Map<String, dynamic>;
          favList.addAll(decoded.map<String, Prediction>(
              (key, value) => MapEntry(key, Prediction.fromJson(value))));
        }
        favList.addIf(
            true, prediction.placeId, prediction.copyWith(isFavorite: true));
        final encodeFavList = jsonEncode(favList);
        await taxiMapaX.box!.write('search_favorites', encodeFavList);
      } catch (e) {
        Helpers.logger.e(e.toString());
      }
    }
  }

  Future<void> onFavoriteRemove(Prediction prediction) async {
    if (taxiMapaX.box != null) {
      try {
        final favStorageString = taxiMapaX.box!.read('search_favorites');
        if (favStorageString != null) {
          final decoded = jsonDecode(favStorageString) as Map<String, dynamic>;
          var castList = decoded.map<String, Prediction>(
              (key, value) => MapEntry(key, Prediction.fromJson(value)));
          castList.remove(prediction.placeId);
          final encodeFavList = jsonEncode(castList);
          await taxiMapaX.box!.write('search_favorites', encodeFavList);
        }
      } catch (e) {
        Helpers.logger.e(e.toString());
      }
    }
  }

  // El debounce asociado a searchText ejecuta esta función
  Future<void> searchAddressFromText(String query) async {
    if (showItemListPlaceHolder == true) {
      showItemListPlaceHolder = false;
    }

    _predictionsStreamSub?.cancel();

    this._sugerencias = [];
    loadingSearchPrediction = true;

    if (query.isEmpty) {
      this._sugerencias = await _searchFavoriteInStorage(query);
      loadingSearchPrediction = false;
      update([gbResultados]);
      return;
    }

    loadingSearchPrediction = true;
    update([gbResultados]);

    _predictionsStreamSub = _getPredictionsFromGoogleApi(query)
        .asStream()
        .listen((fetchList) async {
      loadingSearchPrediction = false;
      final List<Prediction> newList = [];
      final storagePreds = await _searchFavoriteInStorage(query);
      newList.addAll(storagePreds);
      newList.addAll(fetchList);
      this._sugerencias = [...newList];
      update([gbResultados]);
    });
  }

  Future<List<Prediction>> _searchFavoriteInStorage(String text) async {
    final List<Prediction> favoritos = [];
    try {
      final favStorageString = taxiMapaX.box!.read('search_favorites');
      final favList = Map<String, Prediction>();
      if (favStorageString != null) {
        final decoded = jsonDecode(favStorageString) as Map<String, dynamic>;
        favList.addAll(decoded.map<String, Prediction>(
            (key, value) => MapEntry(key, Prediction.fromJson(value))));
      }

      favList.forEach((key, value) {
        final castPrediction = value;

        String name =
            removeDiacritics(castPrediction.description).toLowerCase();
        if (name.contains(text.toLowerCase())) {
          favoritos.add(castPrediction);
        }
      });
    } catch (e) {
      Helpers.logger.e(e.toString());
    }
    return favoritos;
  }

  Future<List<Prediction>> _getPredictionsFromGoogleApi(String query) async {
    errorSearchingPrediction = false;
    final List<Prediction> listPredictions = [];
    try {
      final myLatLng =
          LatLng(taxiMapaX.myPosition.latitude, taxiMapaX.myPosition.longitude);
      final GoogleSuggestionResponse resp = await taxiMapaX
          .autocompletePlaceService
          .fetchSugerencias(query, cancelToken, location: myLatLng);
      if (resp.status == 'OK') {
        listPredictions.addAll(resp.predictions);
      }
      if (resp.status == 'ZERO_RESULTS') {
        listPredictions.addAll([]);
      }
    } catch (e) {
      print(e.toString());
      errorSearchingPrediction = true;
      Helpers.logger.e('Hubo un error obteniendo las predicciones');
    }
    return listPredictions;
  }

  void toggleBusquedaView(BusquedaView type) {
    switch (type) {
      case BusquedaView.origen:
        _busquedaView = BusquedaView.origen;
        tituloAppBar.value = 'Punto de origen';
        break;
      case BusquedaView.destino:
        _busquedaView = BusquedaView.destino;
        tituloAppBar.value = 'Lugar de destino';
        break;
    }
  }

  // *******************************************
  // ****** LÓGICA DE BUSCAR DIRECCIONES *******
  // *******************************************

  void _onOrigenFocus() {
    if (focusNodeOrigen.hasFocus) {
      setInputsWithPreviousSavedData();
      toggleBusquedaView(BusquedaView.origen);
      searchText.value = this.origenCtlr.text;
    }
  }

  void _onDestinoFocus() {
    if (focusNodeDestino.hasFocus) {
      setInputsWithPreviousSavedData();
      toggleBusquedaView(BusquedaView.destino);
      searchText.value = this.destinoCtlr.text;
    }
  }

  void setInputsWithPreviousSavedData() {
    this.destinoCtlr.text = taxiMapaX.savedDestinoName;
    this.origenCtlr.text = taxiMapaX.savedOrigenName;
  }

  void validateInputs() {
    if (_isOrigenCorrect() && _isDestinoCorrect()) {
      Get.focusScope?.unfocus();
      taxiMapaX.calculateRouteFromGoogle();
    } else {
      if (!_isOrigenCorrect()) {
        focusNodeOrigen.requestFocus();
      } else if (!_isDestinoCorrect()) {
        focusNodeDestino.requestFocus();
      }
    }
  }

  bool _isOrigenCorrect() {
    if (taxiMapaX.savedOrigenName.isNotEmpty) {
      if ((taxiMapaX.savedOrigenPlaceId != null &&
              taxiMapaX.savedOrigenCoords == null) ||
          (taxiMapaX.savedOrigenPlaceId == null &&
              taxiMapaX.savedOrigenCoords != null)) {
        return true;
      }
    }
    return false;
  }

  bool _isDestinoCorrect() {
    if (taxiMapaX.savedDestinoName.isNotEmpty) {
      if ((taxiMapaX.savedDestinoPlaceId != null &&
              taxiMapaX.savedDestinoCoords == null) ||
          (taxiMapaX.savedDestinoPlaceId == null &&
              taxiMapaX.savedDestinoCoords != null)) {
        return true;
      }
    }
    return false;
  }

  //** ACTIONS BETWEEN LAYERS */
  void actionsFromAdondeVamosLayer() {
    taxiMapaX.savedOrigenName = '';
    taxiMapaX.savedOrigenPlaceId = null;
    taxiMapaX.savedOrigenCoords = null;

    taxiMapaX.savedDestinoName = '';
    taxiMapaX.savedDestinoPlaceId = null;
    taxiMapaX.savedDestinoCoords = null;

    setInputsWithPreviousSavedData();
    _updateInputOrigen(
        address: Helpers.shortStreetName(taxiMapaX.myPositonName),
        coords: LatLng(
            taxiMapaX.myPosition.latitude, taxiMapaX.myPosition.longitude));
    focusNodeDestino.requestFocus();
  }

  void actionsFromTarifaLayer() {
    setInputsWithPreviousSavedData();
  }

  void _updateInputOrigen({
    required String address,
    String? placeId,
    LatLng? coords,
  }) {
    taxiMapaX.setSaveOrigenData(
        address: address, coords: coords, placeId: placeId);
    origenCtlr.text = address;
  }

  void _updateInputDestino({
    required String address,
    String? placeId,
    LatLng? coords,
  }) {
    taxiMapaX.setSaveDestinoData(
        address: address, coords: coords, placeId: placeId);
    destinoCtlr.text = address;
  }

  void onCenterPickTap() {
    taxiMapaX.centerToMyPosition();
  }

  void onSaveManualPosition() {
    if (taxiMapaX.searchingAddressFromPick.value) return;
    if (taxiMapaX.lastPositionOnMoving != null) {
      if (busquedaView == BusquedaView.origen) {
        taxiMapaX.confirmedPickup = true;
        taxiMapaX.setSaveOrigenData(
            address: origenCtlr.text,
            coords: LatLng(taxiMapaX.lastPositionOnMoving!.latitude,
                taxiMapaX.lastPositionOnMoving!.longitude));
      } else {
        taxiMapaX.setSaveDestinoData(
            address: destinoCtlr.text,
            coords: LatLng(taxiMapaX.lastPositionOnMoving!.latitude,
                taxiMapaX.lastPositionOnMoving!.longitude));
      }

      setInputsWithPreviousSavedData();
      isSearchResultListVisible.value = true;

      validateInputs();
    } else {
      AppSnackbar()
          .basic(message: 'Mueva el mapa para seleccionar una ubicación.');
    }
  }
}
