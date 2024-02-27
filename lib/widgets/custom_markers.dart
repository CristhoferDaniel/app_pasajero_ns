part of 'widgets.dart';

class PopupMarker extends StatelessWidget {
  final String streetName;
  final bool mini;
  final bool origin;
  final double pSize;
  final Color pColor1 = akPrimaryColor; // Helpers.darken(akPrimaryColor, .1);
  final Color pColor2 = Colors.white;
  final Color pTextColor = akPrimaryColor;
  final Color pIconColor = Colors.white;
  final bool onlyDot;

  PopupMarker({
    this.streetName = '',
    this.mini = false,
    this.pSize = 40.0,
    this.origin = true,
    this.onlyDot = false,
  });

  @override
  Widget build(BuildContext context) {
    // final sizeTriangle = pSize * 0.15;

    final popup = Stack(
      fit: StackFit.loose,
      children: [
        _buildShadow(),
        Column(
          children: [
            _buildBox(isOrigin: origin),
            /* Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationX(math.pi),
              child: Container(
                width: sizeTriangle,
                child: AspectRatio(
                  aspectRatio: 20 / 8,
                  child: CustomPaint(
                    painter: _DrawTriangleShape(colorTriangle: pColor2),
                  ),
                ),
              ),
            ), */
          ],
        ),
      ],
    );

    return Stack(
      children: [
        Positioned(
          top: onlyDot ? 0.0 : pSize * 0.5,
          left: 0.0,
          child: _pinDot(isOrigin: origin, size: pSize * 0.6),
        ),
        onlyDot
            ? Container(
                child: SizedBox(width: pSize * 1.25, height: pSize * 1.25),
                /* decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.red,
                  ),
                ), */
              )
            : Container(
                child: popup,
                padding: EdgeInsets.only(
                  left: pSize * 0.6,
                  bottom: pSize * 0.8,
                ),
                /* decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.red,
                  ),
                ), */
              ),
      ],
    );
  }

  Widget _pinDot({bool isOrigin = true, double size = 30.0}) {
    Color destinyColor = akSecondaryColor;

    return _circleBlur(
      padding: size * 0.25,
      color: isOrigin ? Colors.transparent : destinyColor.withOpacity(.08),
      child: _circleBlur(
        padding: size * 0.35,
        color: isOrigin ? Colors.transparent : destinyColor.withOpacity(.1),
        child: _circleBlur(
          padding: size * 0.1,
          color: isOrigin ? Colors.transparent : destinyColor.withOpacity(.15),
          child: _circleDot(
              size: size * 0.5,
              color: isOrigin ? akPrimaryColor : destinyColor,
              shadows: isOrigin),
        ),
      ),
    );
  }

  Widget _circleDot(
      {double size = 20.0,
      Color color = Colors.greenAccent,
      bool shadows = true}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(500.0),
        color: color,
        border: Border.all(color: akWhiteColor, width: size * 0.25),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, size * 0.15),
            color: shadows ? color.withOpacity(.15) : Colors.transparent,
            blurRadius: size * 0.35,
            spreadRadius: size * 0.15,
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(500.0), color: color),
        height: size,
        width: size,
      ),
    );
  }

  Widget _circleBlur(
      {double padding = 20.0,
      Color color = Colors.greenAccent,
      Widget child = const SizedBox()}) {
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(200.0),
        color: color,
      ),
      child: child,
    );
  }

  Widget _buildBox({bool isOrigin = true}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(pSize * 0.1),
      child: Container(
        decoration: BoxDecoration(
          color: isOrigin ? pColor1 : pColor1,
        ),
        child: Container(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: pSize * 0.2),
                child: Icon(
                  isOrigin ? Icons.my_location : Icons.location_on_rounded,
                  size: pSize * 0.35,
                  color: isOrigin ? pIconColor : pIconColor,
                ),
              ),
              Container(
                color: pColor2,
                height: pSize * 0.85,
                width: mini ? pSize * 1.85 : pSize * 3,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(
                    horizontal: pSize * 0.18, vertical: pSize * 0.1),
                child: Row(
                  children: [
                    Expanded(
                      child: AkText(
                        streetName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: mini ? pSize * 0.35 : pSize * 0.25,
                          color: pTextColor,
                          // fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    mini
                        ? SizedBox()
                        : Padding(
                            padding: EdgeInsets.only(
                              left: pSize * 0.1,
                            ),
                            child: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: pSize * 0.3,
                              color: pTextColor,
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShadow() {
    final factor = 0.05;

    return Positioned.fill(
      child: Container(
        margin: EdgeInsets.only(
          top: pSize * factor * 2,
          left: pSize * factor,
          right: pSize * factor * 0.5,
          bottom: pSize * factor * 0.5,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.1),
              blurRadius: pSize * 0.05,
              spreadRadius: pSize * 0.075,
            ),
          ],
        ),
      ),
    );
  }
}

/* class _DrawTriangleShape extends CustomPainter {
  final Color colorTriangle;

  _DrawTriangleShape({required this.colorTriangle});

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    var paint = Paint();
    paint.color = colorTriangle;
    paint.style = PaintingStyle.fill;

    var path = Path();
    path.moveTo(0, height);
    path.lineTo(width / 2, 0);
    path.lineTo(width, height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
} */
