import 'package:app_pasajero_ns/data/models/categoria_site.dart';
import 'package:app_pasajero_ns/data/providers/categoria_site_provider.dart';
import 'package:app_pasajero_ns/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class TourCategoriasHomeController extends GetxController {
  final CancelToken cancelToken = CancelToken();

  bool existsError = false;
  bool loading = false;
  String errorMessage = '';

  CategoriaSiteProvider _categoriaSiteProvider = CategoriaSiteProvider();

  List<CategoriaSite> lista = [];

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  @override
  void onClose() {
    cancelToken.cancel();
    super.onClose();
  }

  Future<void> fetchData() async {
    try {
      loading = true;
      existsError = false;
      update();

      final resp = await _categoriaSiteProvider
          .getCategoriaSitesPaginated(1, 1000, cancelToken: cancelToken);

      if (resp.content.isNotEmpty) {
        this.lista = [...resp.content];
      }
    } on ApiException catch (e) {
      existsError = true;
      errorMessage = e.message;
      Helpers.logger.e(errorMessage);
    } catch (e) {
      existsError = true;
      errorMessage = 'Parece que hubo un error';
      Helpers.logger.e(errorMessage);
    } finally {
      loading = false;
      update();
    }
  }
}
