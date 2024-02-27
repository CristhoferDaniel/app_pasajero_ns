part of 'widgets.dart';

class AppDrawer extends StatelessWidget {
  AppDrawer({Key? key, required this.drawerKey}) : super(key: key);

  final GlobalKey<ScaffoldState> drawerKey;

  final _appX = Get.find<AppPrefsController>();
  final _authX = Get.find<AuthController>();
  final _mapaX = Get.find<HomeController>();

  final drawerTextColor = akTitleColor;
  final drawerBgColor = akScaffoldBackgroundColor;
  final factorPadding = 1.25;

  @override
  Widget build(BuildContext context) {
    final bgColorWave =
        _appX.type == AppType.passenger ? akAccentColor : akPrimaryColor;

    return Obx(() => IgnorePointer(
          ignoring: !_mapaX.enableMenuAction.value,
          child: Theme(
              data: Theme.of(context).copyWith(
                canvasColor: Colors.transparent,
              ),
              child: Drawer(
                child: LayoutBuilder(
                  builder: (_, constraints) {
                    return ClipRRect(
                      borderRadius: BorderRadius.horizontal(
                          right: Radius.circular(akRadiusDrawerContainer)),
                      child: Container(
                        margin: EdgeInsets.all(0),
                        padding: EdgeInsets.symmetric(vertical: 0),
                        decoration: BoxDecoration(
                          color: drawerBgColor,
                        ),
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                right: 0,
                                top: 0,
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                        width: double.infinity,
                                        color: bgColorWave,
                                        height: Get.height,
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      color: bgColorWave,
                                      height: Get.width * 0.22,
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                left: 0,
                                right: 0,
                                top: 0,
                                child: Container(
                                  width: double.infinity,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: (Get.width * 0.22 - 2.0)),
                                    child: AspectRatio(
                                      aspectRatio: 4 / 1,
                                      child: CustomPaint(
                                          painter: CurvePainter(
                                        color: bgColorWave,
                                      )),
                                    ),
                                  ),
                                ),
                              ),
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                    minHeight: constraints.maxHeight),
                                child: IntrinsicHeight(
                                  child: SafeArea(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: <Widget>[
                                        SizedBox(height: Get.width * 0.03),
                                        _closeIcon(),
                                        SizedBox(height: Get.width * 0.12),
                                        _buildAvatar(),
                                        SizedBox(height: Get.width * 0.08),
                                        _buildItems(),
                                        Expanded(child: SizedBox()),
                                        _buildFooter(),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )),
        ));
  }

  Widget _closeIcon() {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: akContentPadding * (factorPadding * 0.35)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(300.0),
            child: Material(
              type: MaterialType.transparency,
              child: IconButton(
                onPressed: () {
                  if (drawerKey.currentState?.isDrawerOpen ?? false) Get.back();
                },
                icon: SvgPicture.asset(
                  'assets/icons/close.svg',
                  width: akFontSize - 2.0,
                  color: _appX.type == AppType.passenger
                      ? akPrimaryColor.withOpacity(0.5)
                      : akWhiteColor.withOpacity(0.2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: akContentPadding * factorPadding),
      child: Row(
        children: [
          PhotoUser(
            avatarUrl: _authX.backendUser?.foto ?? '',
            photoVersion: _authX.userPhotoVersion,
            size: Get.width * 0.12,
          ),
          SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AkText(
                  Helpers.nameFormatCase(
                    Helpers.getShortName(
                            false, _authX.backendUser?.nombres ?? '') +
                        ' ' +
                        Helpers.getShortName(
                            true, _authX.backendUser?.apellidos ?? ''),
                  ),
                  style: TextStyle(
                    fontSize: akFontSize + 3.0,
                    fontWeight: FontWeight.w500,
                    color: drawerTextColor,
                  ),
                ),
                SizedBox(height: 5.0),
                AkText(
                  'Bienvenido',
                  style: TextStyle(
                    fontSize: akFontSize - 3.0,
                    color: drawerTextColor.withOpacity(0.4),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildItems() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTile(
          'Mis datos',
          () => Get.toNamed(AppRoutes.PERFIL_DATOS),
          'user',
        ),
        _buildTile(
          'Mis viajes',
          () => Get.toNamed(AppRoutes.MIS_VIAJES),
          'user',
        ),
        _buildTile(
          'Mis favoritos',
          () => Get.toNamed(AppRoutes.SEARCH_FAVORITES),
          'user',
        ),
        _buildTile(
          'Cupones',
          () => Get.toNamed(AppRoutes.CUPONES),
          'user',
        ),
        _buildTile(
          'Mi Billetera',
          () => Get.toNamed(AppRoutes.MI_BILLETERA),
          'user',
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        _buildTile(
          'Términos',
          () => Get.toNamed(AppRoutes.TERMINOS_CONDICIONES,
              arguments: TerminosCondicionesControllerArguments(
                  showActionButtons: false)),
          'requirement',
        ),
        _buildTile(
          'Preguntas frecuentes',
          () => Get.toNamed(AppRoutes.FAQ,
              arguments: TerminosCondicionesControllerArguments(
                  showActionButtons: false)),
          'requirement',
        ),
        _buildTile(
          'Cerrar sesión',
          () {
            _authX.logout();
          },
          'logout',
        ),
      ],
    );
  }

  Widget _buildTile(String text, void Function()? onTap, String svgName) {
    final _borderRadius = 15.0;

    final bgColorItem = Helpers.darken(drawerBgColor, 0.04);
    final bgColorItemSplash = Helpers.darken(drawerBgColor, 0.05);

    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      padding: EdgeInsets.symmetric(
          horizontal: (akContentPadding * factorPadding) - 5.0),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          highlightColor: bgColorItem,
          splashColor: bgColorItemSplash,
          borderRadius: BorderRadius.circular(_borderRadius),
          onTap: () async {
            // EnableMenuAction evitar el twice call
            _mapaX.enableMenuAction.value = false;
            Get.back();
            // await Helpers.sleep(150);
            onTap?.call();
            _mapaX.enableMenuAction.value = true;
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 15.0,
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/$svgName.svg',
                  width: akFontSize + 4.0,
                  color: drawerTextColor.withOpacity(0.75),
                ),
                SizedBox(width: 20.0),
                Expanded(
                  child: AkText(
                    text,
                    style: TextStyle(
                      color: drawerTextColor,
                      fontSize: akFontSize + 2.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
