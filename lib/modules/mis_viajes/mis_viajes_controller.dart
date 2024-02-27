import 'package:app_pasajero_ns/data/models/servicio.dart';
import 'package:app_pasajero_ns/data/providers/servicio_provider.dart';
import 'package:app_pasajero_ns/modules/misc/error/misc_error_controller.dart';
import 'package:app_pasajero_ns/routes/app_pages.dart';
import 'package:app_pasajero_ns/utils/utils.dart';
import 'package:get/get.dart';

class MisViajesController extends GetxController {
  // Instances
  late MisViajesController _self;
  final _servicioProvider = ServicioProvider();

  final fetching = true.obs;

  List<ServicioModelItem> lista = [];

  @override
  void onInit() {
    super.onInit();
    _self = this;

    _init();
  }

  Future<void> _init() async {
    _fetchList();
  }

  Future<void> _fetchList() async {
    String? errorMsg;
    lista = [];
    try {
      fetching.value = true;
      await Helpers.sleep(600);
      final resp = await _servicioProvider.getByClient();
      lista = resp.content.reversed.toList();
    } on ApiException catch (e) {
      errorMsg = e.message;
      Helpers.logger.e(e.message);
    } on BusinessException catch (e) {
      errorMsg = e.message;
      Helpers.logger.e(e.message);
    } catch (e) {
      errorMsg = 'Ocurrió un error inesperado.';
      Helpers.logger.e(e.toString());
    }

    if (_self.isClosed) return;
    if (errorMsg != null) {
      final ers = await Get.toNamed(AppRoutes.MISC_ERROR,
          arguments: MiscErrorArguments(content: errorMsg));
      if (ers == MiscErrorResult.retry) {
        await Helpers.sleep(1500);
        _fetchList();
      } else {
        fetching.value = false;
      }
    } else {
      fetching.value = false;
    }
  }
}
