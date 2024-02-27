part of 'widgets.dart';

class AppError extends StatelessWidget {
  final String title = 'Error!';
  final void Function()? onRetry;
  final String message;

  const AppError({required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    final widthIcon = Get.size.width * 0.20;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(akContentPadding),
      // color: Colors.red,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              'assets/icons/gear.svg',
              width: widthIcon,
              color: akTextColor.withOpacity(.35),
            ),
            SizedBox(height: 25.0),
            AkText(
              title,
              type: AkTextType.h8,
              style: TextStyle(color: akTextColor.withOpacity(.95)),
            ),
            SizedBox(height: 10.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: AkText(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(color: akTextColor.withOpacity(.55)),
              ),
            ),
            SizedBox(height: 25.0),
            AkButton(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 11.0, horizontal: 20.0),
              onPressed: () {
                this.onRetry?.call();
              },
              type: AkButtonType.outline,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.replay_rounded, color: akTextColor),
                  SizedBox(width: 5.0),
                  AkText('Reintentar'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
