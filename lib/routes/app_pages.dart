import 'package:app_pasajero_ns/modules/acceso_gps/acceso_gps_page.dart';
import 'package:app_pasajero_ns/modules/cancelacion/cancelado/cancelacion_servicio_page.dart';
import 'package:app_pasajero_ns/modules/contacto/contacto_binding.dart';
import 'package:app_pasajero_ns/modules/contacto/contacto_page.dart';
import 'package:app_pasajero_ns/modules/cupones/cupones_page.dart';
import 'package:app_pasajero_ns/modules/faq/faq_binding.dart';
import 'package:app_pasajero_ns/modules/faq/faq_page.dart';
import 'package:app_pasajero_ns/modules/home/home_binding.dart';
import 'package:app_pasajero_ns/modules/home/home_page.dart';
import 'package:app_pasajero_ns/modules/intro/intro_page.dart';
import 'package:app_pasajero_ns/modules/login/countries/country_selection_page.dart';
import 'package:app_pasajero_ns/modules/login/enter_email/login_enter_email_page.dart';
import 'package:app_pasajero_ns/modules/login/enter_password/login_enter_password_page.dart';
import 'package:app_pasajero_ns/modules/login/extra_info/login_extra_info_page.dart';
import 'package:app_pasajero_ns/modules/login/login_page.dart';
import 'package:app_pasajero_ns/modules/login/reset_password/login_reset_password_page.dart';
import 'package:app_pasajero_ns/modules/metodo_pago/mi_billetera.dart';
import 'package:app_pasajero_ns/modules/mi_perfil/mi_perfil_page.dart';
import 'package:app_pasajero_ns/modules/mis_viajes/detalle/mis_viajes_detalle_page.dart';
import 'package:app_pasajero_ns/modules/mis_viajes/mis_viajes_page.dart';
import 'package:app_pasajero_ns/modules/misc/error/misc_error_page.dart';
import 'package:app_pasajero_ns/modules/perfil/datos/perfil_datos_page.dart';
import 'package:app_pasajero_ns/modules/perfil/email_details/perfil_email_details_page.dart';
import 'package:app_pasajero_ns/modules/perfil/foto/perfil_foto_page.dart';
import 'package:app_pasajero_ns/modules/perfil/inicio/perfil_inicio_page.dart';
import 'package:app_pasajero_ns/modules/permisos/permisos_binding.dart';
import 'package:app_pasajero_ns/modules/permisos/permisos_page.dart';
import 'package:app_pasajero_ns/modules/prueba/prueba_page.dart';
import 'package:app_pasajero_ns/modules/search_favorites/search_favorites_page.dart';
import 'package:app_pasajero_ns/modules/splash/splash_page.dart';
import 'package:app_pasajero_ns/modules/taxi/taxi_cupon/travel_cupon_page.dart';
import 'package:app_pasajero_ns/modules/taxi/taxi_finished/travel_finished_page.dart';
import 'package:app_pasajero_ns/modules/taxi/taxi_mapa/taxi_mapa_page.dart';
import 'package:app_pasajero_ns/modules/taxi/taxi_rating/taxi_rating_binding.dart';
import 'package:app_pasajero_ns/modules/taxi/taxi_rating/taxi_rating_page.dart';
import 'package:app_pasajero_ns/modules/taxi/taxi_reserva/taxi_reserva_page.dart';
import 'package:app_pasajero_ns/modules/taxi/taxi_travel/taxi_travel_page.dart';
import 'package:app_pasajero_ns/modules/terminos/terminos_condiciones_page.dart';
import 'package:app_pasajero_ns/modules/tour/tabs_wrapper/tour_tabs_wrapper.dart';
import 'package:flutter/material.dart' show Curves;
import 'package:get/get.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = AppRoutes.SPLASH;
  static const _transition = Transition.cupertino;

  static final routes = [
    GetPage(
      name: AppRoutes.SPLASH,
      page: () => SplashPage(),
      transition: _transition,
    ),

    GetPage(
        name: AppRoutes.PERMISOS,
        page: () => PermisosPage(),
        transition: _transition,
        binding: PermisosBinding()),

    GetPage(
      name: AppRoutes.INTRO,
      page: () => IntroPage(),
      transition: _transition,
    ),

    GetPage(
      name: AppRoutes.COUNTRY_SELECTION,
      page: () => CountrySelectionPage(),
      transition: _transition,
    ),

    GetPage(
      name: AppRoutes.LOGIN,
      page: () => LoginPage(),
      transition: _transition,
    ),
    GetPage(
      name: AppRoutes.LOGIN_ENTER_EMAIL,
      page: () => LoginEnterEmailPage(),
      transition: _transition,
    ),
    GetPage(
      name: AppRoutes.LOGIN_ENTER_PASSWORD,
      page: () => LoginEnterPasswordPage(),
      transition: _transition,
    ),
    GetPage(
      name: AppRoutes.LOGIN_RESET_PASSWORD,
      page: () => LoginResetPasswordPage(),
      transition: _transition,
    ),
    GetPage(
      name: AppRoutes.LOGIN_EXTRA_INFO,
      page: () => LoginExtraInfoPage(),
      transition: _transition,
    ),

    // MIS DATOS
    GetPage(
      name: AppRoutes.PERFIL_INICIO,
      page: () => PerfilInicioPage(),
      transition: _transition,
    ),
    GetPage(
      name: AppRoutes.PERFIL_DATOS,
      page: () => PerfilDatosPage(),
      transition: _transition,
    ),
    GetPage(
      name: AppRoutes.PERFIL_FOTO,
      page: () => PerfilFotoPage(),
      transition: _transition,
    ),
    GetPage(
      name: AppRoutes.PERFIL_EMAIL_DETAILS,
      page: () => PerfilEmailDetailsPage(),
      transition: _transition,
    ),

    GetPage(
      name: AppRoutes.HOME,
      page: () => HomePage(),
      transition: _transition,
      binding: HomeBinding(),
    ),

    GetPage(
      name: AppRoutes.MI_PERFIL,
      page: () => MiPerfilPage(),
      transition: _transition,
    ),

    GetPage(
      name: AppRoutes.ACCESO_GPS,
      page: () => AccesoGpsPage(),
      transition: _transition,
    ),
    GetPage(
      name: AppRoutes.TAXI_MAPA,
      page: () => TaxiMapaPage(),
      transition: _transition,
    ),

    GetPage(
      name: AppRoutes.TAXI_TRAVEL,
      page: () => TaxiTravelPage(),
      transition: _transition,
    ),
    GetPage(
      name: AppRoutes.TAXI_CUPON,
      page: () => TravelCuponPage(),
      transition: _transition,
    ),
    GetPage(
      name: AppRoutes.TAXI_FINISHED,
      page: () => TravelFinishedPage(),
      transition: _transition,
    ),
    GetPage(
      name: AppRoutes.TAXI_RATING,
      page: () => TaxiRatingPage(),
      transition: _transition,
      binding: TaxiRatingBinding(),
    ),
    GetPage(
      name: AppRoutes.TAXI_RESERVA,
      page: () => TaxiReservaPage(),
      fullscreenDialog: true,
      curve: Curves.easeInOut,
      transitionDuration: Duration(milliseconds: 700),
    ),

    // MIS VIAJES
    GetPage(
      name: AppRoutes.MIS_VIAJES,
      page: () => MisViajesPage(),
      transition: _transition,
    ),
    GetPage(
      name: AppRoutes.MIS_VIAJES_DETALLE,
      page: () => MisViajesDetallePage(),
      transition: _transition,
    ),

    // Servicio Turístico
    GetPage(
      name: AppRoutes.TOUR_TABS_WRAPPER,
      page: () => TourTabsWrapper(),
      transition: _transition,
    ),

    GetPage(
      name: AppRoutes.PRUEBA,
      page: () => PruebaPage(),
      transition: _transition,
    ),
    GetPage(
        name: AppRoutes.CONTACTO,
        page: () => ContactoPage(),
        binding: ContactoBinding()),

    GetPage(
      name: AppRoutes.SEARCH_FAVORITES,
      page: () => SearchFavoritesPage(),
      transition: _transition,
    ),

    GetPage(
      name: AppRoutes.TERMINOS_CONDICIONES,
      page: () => TerminosCondicionesPage(),
      transition: _transition,
    ),
    GetPage(
        name: AppRoutes.FAQ,
        page: () => FaqPage(),
        transition: _transition,
        binding: FaqBinding()),

    GetPage(
      name: AppRoutes.CUPONES,
      page: () => CuponesPage(),
      transition: _transition,
    ),

    GetPage(
      name: AppRoutes.MI_BILLETERA,
      page: () => Mi_Billetera(),
      transition: _transition,
    ),

    // MISC
    GetPage(
      name: AppRoutes.MISC_ERROR,
      page: () => MiscErrorPage(),
      transition: _transition,
    ),

    GetPage(
      name: AppRoutes.CANCELACION_SERVICIO,
      page: () => CancelacionRevisionPage(),
      transition: _transition,
    ),
  ];
}
