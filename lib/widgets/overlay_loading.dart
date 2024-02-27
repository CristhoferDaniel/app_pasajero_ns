part of 'widgets.dart';

class OverlayLoading extends StatelessWidget {
  final bool loading;

  const OverlayLoading(this.loading);

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Container(
        height: Get.height,
        width: Get.width,
        color: Colors.black.withOpacity(0.5),
        child: Center(
          child: SpinLoadingIcon(
            size: 30,
          ),
        ),
      );
    } else {
      return Container(
        height: Get.height,
        width: Get.width,
      );
    }
  }
}
