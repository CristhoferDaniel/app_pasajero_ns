part of '../../ak_ui.dart';

final dfAppLight = ThemeData.light();

final dfAppBarTitleStyle = TextStyle(
  fontSize: akFontSize + 2.0,
  color: Colors.white,
);

final dfAppBarIconTheme = IconThemeData(
  color: Colors.white,
);

final dfAppBarLight = AppBarTheme(
  systemOverlayStyle: SystemUiOverlayStyle.dark,
  color: akAppbarBackgroundColor,
  centerTitle: true,
  elevation: akAppbarElevation,
  titleTextStyle: dfAppBarTitleStyle,
  iconTheme: dfAppBarIconTheme,
);

final _lightSettings = ThemeData(
    scaffoldBackgroundColor: akScaffoldBackgroundColor,
    primaryColor: akPrimaryColor,
    colorScheme: dfAppLight.colorScheme.copyWith(
      onSecondary: akAccentColor,
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: akPrimaryColor,
      selectionColor: akPrimaryColor,
      selectionHandleColor: akPrimaryColor,
    ),
    fontFamily: akDefaultFontFamily,
    appBarTheme: dfAppBarLight,
    primaryIconTheme: IconThemeData(color: akAppbarTextColor),
    primaryTextTheme: TextTheme(
      headline6: TextStyle(
          color: akAppbarTextColor,
          fontWeight: akAppbarFontWeight,
          fontSize: akFontSize + 3.0), // Appbar
    ),
    textTheme: TextTheme(
        bodyText2: TextStyle(
            // height: 0.85,
            color: akTextColor,
            fontSize: akFontSize)));

ThemeData dfAppThemeLight = _lightSettings;

ThemeData dfAppThemeDark = _lightSettings;
