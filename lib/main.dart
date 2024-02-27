import 'package:app_pasajero_ns/data/services/push_notifications_service.dart';
import 'package:app_pasajero_ns/instance_binding.dart';
import 'package:app_pasajero_ns/routes/app_pages.dart';
import 'package:app_pasajero_ns/themes/ak_ui.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Color(0xFFF7CC46),
      statusBarIconBrightness: Brightness.dark));
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp();
  await PushNotificationsService.initializeApp();
  await GetStorage.init();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    // Context
    PushNotificationsService.messagesStream.listen((message) {
      print('My App: $message');
    });
  }

  @override
  Widget build(BuildContext context) {
    customizeAkStyle();
    return GetMaterialApp(
      initialBinding: InstanceBinding(),
      title: 'TaxiGuaa',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('es', ''),
      ],
      theme: dfAppThemeLight,
      darkTheme: dfAppThemeDark,
      debugShowCheckedModeBanner: true,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }
}
