part of 'widgets.dart';

class MapPlaceholder extends StatelessWidget {
  final bool ignorePoint;
  final bool hideLocalizando;

  const MapPlaceholder(
      {this.ignorePoint = false, this.hideLocalizando = false});

  @override
  Widget build(BuildContext context) {
    Widget placeHolder = Container(
      decoration: BoxDecoration(
        color: Color(0xFFDCE4E4),
        image: DecorationImage(
          image: AssetImage("assets/img/mapholder.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: this.hideLocalizando
          ? Center(child: SizedBox())
          : Center(
              child: FadeIn(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AkButton(
                      enableMargin: false,
                      text: 'Localizando... ',
                      suffixIcon: Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: SizedBox(
                          width: 15.0,
                          height: 15.0,
                          child: SpinLoadingIcon(
                            strokeWidth: 1.5,
                          ),
                        ),
                      ),
                      onPressed: () {},
                    ),
                    SizedBox(height: 5.0),
                    _DotCircle(
                      padding: 12.0,
                      opacity: .15,
                      child: _DotCircle(
                        padding: 7.0,
                        opacity: .35,
                        child: _DotCircle(
                          opacity: 1,
                          child: SizedBox(
                            height: 2.0,
                            width: 2.0,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );

    return ignorePoint ? IgnorePointer(child: placeHolder) : placeHolder;
  }
}

class _DotCircle extends StatelessWidget {
  final Widget child;

  final double padding;

  final double opacity;

  const _DotCircle(
      {this.child = const SizedBox(), this.padding = 3.0, this.opacity = 1});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: akPrimaryColor.withOpacity(opacity),
        borderRadius: BorderRadius.circular(100.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: child,
      ),
    );
  }
}

class CommonButtonMap extends StatelessWidget {
  final void Function()? onTap;
  final IconData? icon;
  final bool isDark;
  final Widget? child;
  final EdgeInsetsGeometry? contentPadding;

  CommonButtonMap(
      {required this.onTap,
      this.icon,
      this.isDark = false,
      this.child,
      this.contentPadding});

  @override
  Widget build(BuildContext context) {
    Widget buttonChild = SizedBox();
    if (child != null) {
      buttonChild = child!;
    } else {
      if (icon != null) {
        buttonChild = Icon(
          icon,
          color: isDark ? akWhiteColor : akTitleColor,
          size: akFontSize * 1.35,
        );
      }
    }

    final _cp = 9.0;
    EdgeInsetsGeometry buttonPadding = EdgeInsets.all(_cp);
    if (contentPadding != null) {
      buttonPadding = contentPadding!;
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.0),
        boxShadow: [
          BoxShadow(
            color: akPrimaryColor.withOpacity(.1),
            blurRadius: 3.0,
            spreadRadius: 1.0,
            offset: Offset(1.0, 2.0),
          )
        ],
      ),
      child: AkButton(
        borderRadius: 6.0,
        enableMargin: false,
        contentPadding: buttonPadding,
        elevation: 1.0,
        size: AkButtonSize.big,
        variant: isDark ? AkButtonVariant.primary : AkButtonVariant.white,
        child: buttonChild,
        onPressed: () {
          onTap?.call();
        },
      ),
    );
  }
}
