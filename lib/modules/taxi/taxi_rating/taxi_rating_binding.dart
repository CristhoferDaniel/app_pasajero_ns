import 'package:app_pasajero_ns/modules/taxi/taxi_rating/taxi_rating_controller.dart';
import 'package:get/get.dart';

class TaxiRatingBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(TaxiRatingController());
  }
}
