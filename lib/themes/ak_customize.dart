part of 'ak_ui.dart';

// NOTA:
// Para visualizar todos los cambios debe hacer un Hot Restart
// de lo contrario, algunos colores, medidas y estilos
// NO se actualizarán correctamente.

double akRadiusDrawerContainer = akRadiusGeneral;
double akRadiusSnackbar = akRadiusGeneral;
double akMapPaddingBase = 12.0;

void customizeAkStyle() {
  akPrimaryColor = Color(0xFF282828);
  akSecondaryColor = Color(0xFFFF9900);
  akAccentColor = Color(0xFFF7CC46);

  akSuccessColor = Color(0xFF02C751);
  akErrorColor = Color(0xFFF94844);
  akInfoColor = Color(0xFF36B4E7);
  akWarningColor = Color(0xFFFEBC33);

  akDefaultFontFamily = 'Rubik';

  akFontSize = 15.0;

  if (Get.width >= 360.0) {
    akContentPadding = 18.0;
  } else {
    akContentPadding = 15.0;
  }

  // akScaffoldBackgroundColor = Color(0xFFf5f4f9);
  akScaffoldBackgroundColor = Colors.white;

  akTitleColor = akPrimaryColor;
  akTextColor = akTitleColor.withOpacity(.60);

  akAppbarBackgroundColor = akAccentColor;
  akAppbarTextColor = akTitleColor;
  akAppbarFontWeight = FontWeight.w400;
  akAppbarElevation = 0.0;

  // Changing default app flutter theme
  dfAppThemeLight = dfAppThemeLight.copyWith(
    appBarTheme: dfAppBarLight.copyWith(
      titleTextStyle: dfAppBarTitleStyle.copyWith(color: akPrimaryColor),
      iconTheme: dfAppBarIconTheme.copyWith(color: akPrimaryColor),
    ),
  );
}
