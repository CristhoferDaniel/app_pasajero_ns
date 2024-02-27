part of 'widgets.dart';

class SliverContainer<T extends GetxController> extends StatelessWidget {
  const SliverContainer({
    Key? key,
    this.title,
    this.subtitle,
    this.onBack,
    this.scrollController,
    required this.gbAppbarId,
    this.expandedHeight = 130.0,
    required this.children,
    this.type = AppType.driver,
  }) : super(key: key);

  final String? title;
  final String? subtitle;
  final VoidCallback? onBack;
  final ScrollController? scrollController;
  final String gbAppbarId;
  final double expandedHeight;
  final List<Widget> children;

  // Only for TaxiGua;
  final AppType? type;

  bool get isSliverAppBarExpanded {
    if (scrollController != null) {
      return scrollController!.hasClients &&
          scrollController!.offset > expandedHeight - kToolbarHeight - 40.0;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final dfTitleStyle = TextStyle(
      color: akTitleColor,
      fontSize: akFontSize + 2.0,
      fontWeight: FontWeight.w500,
    );

    return CustomScrollView(
      controller: scrollController,
      physics: BouncingScrollPhysics(),
      slivers: <Widget>[
        GetBuilder<T>(
          id: gbAppbarId,
          builder: (_) => SliverAppBar(
            elevation: 2.0,
            pinned: true,
            shadowColor: Helpers.lighten(akScaffoldBackgroundColor, 0.0),
            expandedHeight: expandedHeight,
            backgroundColor: type == AppType.passenger
                ? akAccentColor
                : akScaffoldBackgroundColor,
            leading: IconButton(
              icon: SvgPicture.asset(
                'assets/icons/back.svg',
                width: akFontSize + 3.0,
                color: akTitleColor,
              ),
              onPressed: () {
                onBack?.call();
              },
            ),
            title: isSliverAppBarExpanded
                ? FadeInUp(
                    duration: Duration(milliseconds: 300),
                    from: 10,
                    child: AkText(
                      title ?? '',
                      style: dfTitleStyle.copyWith(fontSize: akFontSize + 3.0),
                    ),
                  )
                : null,
            flexibleSpace: isSliverAppBarExpanded
                ? null
                : FlexibleSpaceBar(
                    background: type == AppType.passenger
                        ? WaveSliverBg(
                            toolbarHeight: expandedHeight,
                          )
                        : null,
                    titlePadding: EdgeInsetsDirectional.only(
                        start: akContentPadding, bottom: akContentPadding),
                    centerTitle: false,
                    // title: Text('Mis datos', textScaleFactor: 1),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Flexible(
                          child: FadeInDown(
                            delay: Duration(milliseconds: 100),
                            duration: Duration(milliseconds: 100),
                            from: 10,
                            child: AkText(
                              title ?? '',
                              style: dfTitleStyle,
                            ),
                          ),
                        ),
                        SizedBox(height: 5.0),
                        FadeIn(
                          delay: Duration(milliseconds: 100),
                          duration: Duration(milliseconds: 100),
                          child: AkText(
                            subtitle ?? '',
                            style: TextStyle(
                              color: type == AppType.passenger
                                  ? akTitleColor
                                  : akTextColor,
                              fontWeight: FontWeight.normal,
                              fontSize: akFontSize - 5.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
        ...children,
      ],
    );
  }
}

class WaveSliverBg extends StatelessWidget {
  final double toolbarHeight;

  const WaveSliverBg({Key? key, required this.toolbarHeight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorWave = Helpers.lighten(akAccentColor);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          color: akAccentColor,
          height: Get.height,
          width: double.infinity,
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: Get.height,
                color: colorWave,
              ),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: toolbarHeight + 5.0,
                  ),
                  Positioned(
                    top: -2,
                    left: 0,
                    right: 0,
                    child: Container(
                      width: double.infinity,
                      child: AspectRatio(
                        aspectRatio: 4 / 1,
                        child: CustomPaint(
                          painter: CurvePainter2(
                            color: colorWave,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
