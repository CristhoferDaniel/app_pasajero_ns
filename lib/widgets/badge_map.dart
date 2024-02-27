part of 'widgets.dart';

class BadgeMap extends StatelessWidget {
  final String text;
  final double dotSize;
  final bool whiteDot;

  const BadgeMap(
      {Key? key, this.text = '', this.dotSize = 10.0, this.whiteDot = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          decoration: BoxDecoration(
              color: akPrimaryColor,
              borderRadius: BorderRadius.circular(akRadiusGeneral)),
          child: Text(
            this.text,
            style: TextStyle(
                color: Colors.white,
                fontSize: akFontSize,
                fontWeight: FontWeight.w300),
          ),
        ),
        SizedBox(height: 2.0),
        Container(
          width: 20,
          height: 20,
          color: Colors.transparent,
          child: Center(
            child: Container(
              width: this.dotSize,
              height: this.dotSize,
              decoration: BoxDecoration(
                  color: akPrimaryColor,
                  borderRadius: BorderRadius.circular(500)),
              child: this.whiteDot
                  ? Center(
                      child: Container(
                        width: this.dotSize * 0.35,
                        height: this.dotSize * 0.35,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(500)),
                      ),
                    )
                  : SizedBox(),
            ),
          ),
        ),
      ],
    );
  }
}

class BadgeMapPin extends StatelessWidget {
  final String text;
  final double pinSize;
  final bool moving;

  const BadgeMapPin(
      {Key? key, this.text = '', this.pinSize = 35.0, this.moving = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dotSize = this.pinSize * 0.80;
    final pinColor = akPrimaryColor;
    final centerDotColor = akAccentColor;
    final basePinWidth = pinSize * 0.12;
    final jumpHeight = pinSize * 0.35;

    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          !moving ? SizedBox(height: jumpHeight) : SizedBox(),
          Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                margin: EdgeInsets.only(top: dotSize * 0.78),
                height: dotSize * 0.75,
                width: basePinWidth,
                decoration: BoxDecoration(
                  color: pinColor,
                  borderRadius: BorderRadius.circular(
                    100.0,
                  ),
                ),
              ),
              Container(
                width: dotSize,
                height: dotSize,
                color: Colors.transparent,
                child: Center(
                  child: Container(
                    width: this.pinSize,
                    height: this.pinSize,
                    decoration: BoxDecoration(
                        color: pinColor,
                        borderRadius: BorderRadius.circular(500)),
                    child: Center(
                      child: Container(
                        width: dotSize * 0.45,
                        height: dotSize * 0.45,
                        decoration: BoxDecoration(
                            color: centerDotColor,
                            borderRadius: BorderRadius.circular(500)),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          moving
              ? Container(
                  width: dotSize,
                  height: jumpHeight,
                  alignment: Alignment.bottomCenter,
                  child: ClipOval(
                    child: Container(
                      color: Color(0xFF696C8A),
                      height: basePinWidth * 0.85,
                      width: basePinWidth * 1.65,
                    ),
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
