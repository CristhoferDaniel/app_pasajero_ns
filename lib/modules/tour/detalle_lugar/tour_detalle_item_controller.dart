import 'package:app_pasajero_ns/data/models/site.dart';
import 'package:get/get.dart';

class TourDetalleItemArguments {
  final int tabIndex;
  final Site site;

  TourDetalleItemArguments({required this.tabIndex, required this.site});
}

class TourDetalleItemController extends GetxController {
  TourDetalleItemController(this.arguments);

  final TourDetalleItemArguments arguments;

  final RxInt counter = RxInt(0);

  final RxString year = RxString('');

  final RxBool readMore = RxBool(false);

  @override
  void onInit() {
    super.onInit();
    print('oniniiiiii');
    print('${arguments.runtimeType}');

    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);
    year.value = date.year.toString();
  }

  void aumentar() {
    counter.value = counter.value + 1;
  }

  void onBackPressed() {
    Get.back(id: arguments.tabIndex);
  }

  void toggleReadMore() {
    readMore.value = !readMore.value;
  }

  String getLorem() {
    return 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam vel egestas nunc, sit amet fringilla diam. Proin hendrerit orci mauris, sit amet hendrerit dui fringilla sit amet. Sed sit amet facilisis ligula. Curabitur tristique porttitor lacus, sit amet porttitor diam lacinia quis. Maecenas eget laoreet ex. Aliquam eu massa nec nisi mattis pulvinar eu sit amet odio. Vivamus euismod orci nec nibh sollicitudin sodales. Praesent vel sapien imperdiet, ornare diam id, feugiat dolor. Curabitur porta, augue vitae imperdiet auctor, quam elit facilisis urna, ut tincidunt massa turpis ut erat. Mauris et tempus quam. Cras mattis congue massa et tincidunt. Aenean sed nisl auctor, sagittis augue et, blandit elit. Aliquam dolor sapien, dignissim ac tellus quis, hendrerit pulvinar mauris';
  }
}
