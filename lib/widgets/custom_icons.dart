part of 'widgets.dart';

class CustomIconMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 3.5),
          width: 22.0,
          height: 3.5,
          decoration: BoxDecoration(
            color: akTitleColor,
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        SizedBox(height: 2.5),
        Container(
          width: 14.0,
          height: 3.5,
          decoration: BoxDecoration(
            color: akTitleColor,
            borderRadius: BorderRadius.circular(30),
          ),
        )
      ],
    );
  }
}

class SpinLoadingIcon extends StatelessWidget {
  final Color color;
  final double size;
  final double strokeWidth;

  const SpinLoadingIcon(
      {this.color = Colors.white, this.size = 30.0, this.strokeWidth = 2.0});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: this.size,
      width: this.size,
      child: CircularProgressIndicator(
        backgroundColor: Colors.transparent,
        strokeWidth: strokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(this.color),
      ),
    );
  }
}

class TimelineIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _circleDot(),
        _dottedLines(count: 5),
        _circleDot(isOrigin: false),
      ],
    );
  }

  Widget _circleDot({double size = 12.0, bool isOrigin = true}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        color: isOrigin ? akAccentColor : akSecondaryColor,
      ),
      height: size,
      width: size,
      child: SizedBox(),
    );
  }

  Widget _dottedLines({@required count, double height = 6.0}) {
    final line = Container(color: akSecondaryColor, width: 1, height: height);
    List<Widget> items = [];
    for (var i = 0; i < count; i++) {
      if (items.length > 0) {
        items.add(SizedBox(
          height: height * 0.35,
        ));
      }
      items.add(line);
    }
    return Column(mainAxisSize: MainAxisSize.min, children: items);
  }
}

class RadarIcon extends StatelessWidget {
  final String streetName;
  final bool origin;
  final double pSize;
  final Color pColor1 = akPrimaryColor; // Helpers.darken(akPrimaryColor, .1);
  final Color pColor2 = Colors.white;
  final Color pColor3 = akWhiteColor;
  final Color pTextColor = akWhiteColor;
  final Color pIconColor = akWhiteColor;
  final Color borderDotColor = akWhiteColor;
  final bool hidePopup;

  RadarIcon(
      {this.streetName = '',
      this.pSize = 70.0,
      this.origin = true,
      this.hidePopup = false});

  @override
  Widget build(BuildContext context) {
    return _pinDot(isOrigin: origin, size: pSize * 0.6);
  }

  Widget _pinDot({bool isOrigin = true, double size = 30.0}) {
    Color destinyColor = pColor3;

    return _circleBlur(
      padding: size * 0.25,
      color: isOrigin ? Colors.transparent : destinyColor.withOpacity(.25),
      child: _circleBlur(
        padding: size * 0.35,
        color: isOrigin ? Colors.transparent : destinyColor.withOpacity(.35),
        child: _circleDot(
            size: size * 0.3,
            color: isOrigin ? akPrimaryColor : destinyColor,
            shadows: isOrigin),
      ),
    );
  }

  Widget _circleDot(
      {double size = 20.0,
      Color color = Colors.greenAccent,
      bool shadows = true}) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(500.0), color: color),
      height: size,
      width: size,
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
}

class PulseAnimationCustom extends StatefulWidget {
  final Key? key;
  final Widget child;
  final Duration duration;
  final Duration delay;
  final bool infinite;
  final Function(AnimationController)? controller;
  final bool manualTrigger;
  final bool animate;
  final double maxZoom;

  PulseAnimationCustom({
    this.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1000),
    this.delay = const Duration(milliseconds: 0),
    this.infinite = false,
    this.controller,
    this.manualTrigger = false,
    this.animate = true,
    this.maxZoom = 1.5,
  }) : super(key: key) {
    if (manualTrigger == true && controller == null) {
      throw FlutterError('If you want to use manualTrigger:true, \n\n'
          'Then you must provide the controller property, that is a callback like:\n\n'
          ' ( controller: AnimationController) => yourController = controller \n\n');
    }
  }

  @override
  _PulseAnimationCustomState createState() => _PulseAnimationCustomState();
}

/// State class, where the magic happens
class _PulseAnimationCustomState extends State<PulseAnimationCustom>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;
  bool disposed = false;
  late Animation<double> animationInc;
  late Animation<double> animationDec;
  @override
  void dispose() {
    disposed = true;
    controller!.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    controller = AnimationController(duration: widget.duration, vsync: this);

    animationInc = Tween<double>(begin: 1, end: widget.maxZoom).animate(
        CurvedAnimation(
            parent: controller!,
            curve: Interval(0, 0.5, curve: Curves.easeOut)));

    animationDec = Tween<double>(begin: widget.maxZoom, end: 1).animate(
        CurvedAnimation(
            parent: controller!,
            curve: Interval(0.5, 1, curve: Curves.easeIn)));

    if (!widget.manualTrigger && widget.animate) {
      Future.delayed(widget.delay, () {
        if (!disposed) {
          (widget.infinite) ? controller!.repeat() : controller?.forward();
        }
      });
    }

    if (widget.controller is Function) {
      widget.controller!(controller!);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.animate && widget.delay.inMilliseconds == 0) {
      controller?.forward();
    }

    return AnimatedBuilder(
        animation: controller!,
        builder: (BuildContext context, Widget? child) {
          return Transform.scale(
            scale: (controller!.value < 0.5)
                ? animationInc.value
                : animationDec.value,
            child: widget.child,
          );
        });
  }
}
