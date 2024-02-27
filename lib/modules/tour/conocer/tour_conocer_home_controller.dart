import 'package:app_pasajero_ns/data/models/site.dart';
import 'package:app_pasajero_ns/data/providers/site_provider.dart';
import 'package:app_pasajero_ns/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TourConocerHomeController extends GetxController {
  final SiteProvider _siteProvider = SiteProvider();
  final CancelToken cancelToken = CancelToken();

  // Ej: _scrollThreshold = 200. Hará llamadas a partir de
  // los 200 pixeles previos a terminar la lista.
  final _scrollThreshold = 200.0;
  final _scrollController = ScrollController();
  final RxDouble _scrollDifference = RxDouble(0.0);
  bool hasReachedMax = false;
  ScrollController get scrollController => this._scrollController;

  int limitResults = 20;
  List<Site> listaSites = [];

  bool fetchError = false;
  bool fetchFinish = false;
  bool fetchLoading = false;

  String errorMessage = '';

  @override
  void onInit() {
    super.onInit();
    _init();
  }

  @override
  void onClose() {
    _scrollController.dispose();
    cancelToken.cancel();
    super.onClose();
  }

  void _init() {
    _scrollController.addListener(_onScroll);

    _fetchData(1, limitResults);

    debounce<double>(_scrollDifference, (difference) {
      if (difference <= _scrollThreshold) {
        final int page = ((listaSites.length / limitResults) + 1).toInt();
        _fetchData(page, limitResults);
      }
    });
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    this._scrollDifference.value = maxScroll - currentScroll;
  }

  void _fetchData(int page, int limit) async {
    if (fetchLoading || hasReachedMax) return;

    if (fetchError) {
      fetchError = false;
      fetchFinish = false;
      update();
    }

    try {
      fetchLoading = true;
      final resp = await _siteProvider.getSitesPaginated(page, limit,
          cancelToken: cancelToken);

      if (resp.content.isEmpty) {
        hasReachedMax = true;
      } else {
        this.listaSites = this.listaSites + resp.content;
        hasReachedMax = false;
      }
    } on ApiException catch (e) {
      fetchError = true;
      errorMessage = e.message;
      Helpers.logger.e(errorMessage);
    } catch (e) {
      fetchError = true;
      errorMessage = 'Parece que hubo un error';
      Helpers.logger.e(errorMessage);
    } finally {
      fetchFinish = true;
      fetchLoading = false;
      update();
    }
  }

  void retryFetch() {
    _fetchData(listaSites.length, limitResults);
  }
}
