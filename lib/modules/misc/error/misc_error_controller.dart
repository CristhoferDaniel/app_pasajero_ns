import 'package:get/get.dart';

class MiscErrorController extends GetxController {
  String title = 'Opps!';
  String content = 'Parece que hubo un error.\nInténtalo de nuevo.';

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments is MiscErrorArguments) {
      final arguments = Get.arguments as MiscErrorArguments;

      title = arguments.title ?? title;
      content = arguments.content ?? content;
    }
  }

  void onRetryButtonTap() {
    Get.back(result: MiscErrorResult.retry);
  }

  void onCancelButtonTap() {
    Get.back(result: MiscErrorResult.cancel);
  }
}

enum MiscErrorResult { retry, cancel }

class MiscErrorArguments {
  final String? title;
  final String? content;
  const MiscErrorArguments({this.title, this.content});
}
