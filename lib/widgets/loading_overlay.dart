part of 'widgets.dart';

class LoadingOverlay extends StatelessWidget {
  final bool loading;
  final Color color;
  final double size;
  final double strokeWidth;

  const LoadingOverlay(
    this.loading, {
    this.color = Colors.white,
    this.size = 30.0,
    this.strokeWidth = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: loading
          ? Container(
              color: akPrimaryColor.withOpacity(0.5),
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0XFF8D8B8B).withOpacity(.20),
                        offset: Offset(0, 7),
                        blurRadius: 15.0,
                        spreadRadius: 0.0,
                      ),
                    ],
                  ),
                  child: Lottie.asset(
                    'assets/lottie/loading_animation.json',
                    width: Get.width * 0.20,
                    fit: BoxFit.fill,
                    delegates: LottieDelegates(
                      values: [
                        ValueDelegate.strokeColor(['LOADING', '**'],
                            value: akPrimaryColor)
                      ],
                    ),
                  ),
                ),
              ),
            )
          : SizedBox(),
    );
  }
}
