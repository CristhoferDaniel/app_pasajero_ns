import 'package:app_pasajero_ns/data/providers/travel_info_provider.dart';
import 'package:app_pasajero_ns/modules/auth/auth_controller.dart';
import 'package:app_pasajero_ns/routes/app_pages.dart';
import 'package:get/get.dart';

class TaxiRatingController extends GetxController {
  final _authX = Get.find<AuthController>();
  final _travelInfoProvider = TravelInfoProvider();

  double rating = 4;

  Future<void> guardarCalificacion() async {
    try {
      final travelResp =
          await _travelInfoProvider.getByUidClient(_authX.getUser!.uid);
      
      final respRating = await _travelInfoProvider.putRatingDriver(
          travelResp!.idServicio, rating);

      Get.offAllNamed(AppRoutes.HOME);
    } catch (e) {
      Get.offAllNamed(AppRoutes.HOME);
      print('Error en getInitialData: ' + e.toString());
    }
  }
}
