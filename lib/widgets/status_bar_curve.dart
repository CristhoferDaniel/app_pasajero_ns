part of 'widgets.dart';

class StatusBarCurve extends StatelessWidget {
  const StatusBarCurve();

  /* @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Opacity(
        opacity: 0,
        child: Container(
          width: double.infinity,
          child: AspectRatio(
            aspectRatio: 15 / 1,
            child: CustomPaint(
              painter: CurvePainter4(
                color: akAccentColor,
              ),
            ),
          ),
        ),
      ),
    );
  } */

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(akAccentColor.withOpacity(1),
            BlendMode.srcOut), // This one will create the magic
        child: Stack(
          children: [
            Container(
              height: 100.0,
              decoration: BoxDecoration(
                  color: akAccentColor,
                  backgroundBlendMode: BlendMode
                      .dstOut), // This one will handle background + difference out
            ),
            SafeArea(
              child: Container(
                margin: EdgeInsets.only(top: 5.0),
                height: 100.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(20.0)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
