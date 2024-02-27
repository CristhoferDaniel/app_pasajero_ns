import 'package:app_pasajero_ns/modules/misc/error/misc_error_controller.dart';
import 'package:app_pasajero_ns/modules/taxi/taxi_mapa/taxi_mapa_controller.dart';
import 'package:app_pasajero_ns/routes/app_pages.dart';
import 'package:app_pasajero_ns/themes/ak_ui.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as lct;

enum TaxiReservaType {
  ida,
  idayvuelta,
}

class TaxiReservaController extends GetxController {
  late TaxiReservaController _self;
  late BuildContext _context;

  final lct.Location location = lct.Location.instance;

  final tipoReserva = (TaxiReservaType.ida).obs;

  final fechaIda = Rxn<DateTime>();

  final cantAdultos = 1.obs;
  final cantNinos = 0.obs;
  final cantBebes = 0.obs;
  final cantMaletasGrandes = 0.obs;
  final cantMaletasMedianas = 0.obs;
  final cantMochilas = 0.obs;

  final listVehiculos = <VehicleType>[];
  int? idVehiculoSelected;

  final loadingMyPosition = true.obs;

  @override
  void onInit() {
    super.onInit();
    _self = this;

    _init();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void setContext(BuildContext c) {
    this._context = c;
  }

  Future<void> _init() async {
    listVehiculos.add(VehicleType(1, 'Auto Sedan',
        'https://www.perumotor.com.pe/wp-content/uploads/2021/03/6-10.png'));
    listVehiculos.add(VehicleType(2, 'Grand Van',
        'https://569209-1965590-raikfcquaxqncofqfm.stackpathdns.com/wp-content/uploads/2021/02/showroom_header_modelo-h1-van.png',
        slots: 12));
    listVehiculos.add(VehicleType(3, 'Mini Van',
        'https://secure-developments.com/commonwealth/peru/gm_forms/assets/front/images/jellys/61002161e4d76.png',
        slots: 6));
    listVehiculos.add(VehicleType(4, '4x4 Cam',
        'https://www.toyotaperu.com.pe/sites/default/files/camioneta-4Runner-Toyota-4x4.png'));
    listVehiculos.add(VehicleType(5, 'Otro tipo',
        'https://4.bp.blogspot.com/-avVSmaE3ymA/WnSvQzXLeNI/AAAAAAAADy8/LUzK-IxcMpILYxnJeSimaz0j3VGenvppACLcBGAs/s1600/hilux%2Bcamioneta.png'));

    idVehiculoSelected = 1;

    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();

    if (isLocationEnabled) {
      _configPosition();
    } else {
      bool gpsEnabled = await location.requestService();
      if (gpsEnabled) {
        _configPosition();
      }
    }
  }

  // Mi ubicación
  late Position _myPosition;
  Position get myPosition => this._myPosition;

  void _configPosition() async {
    if (_self.isClosed) return;

    try {
      final lastPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      _myPosition = lastPosition;

      await Future.delayed(Duration(seconds: 1));
      loadingMyPosition.value = false;
    } catch (e) {
      if (_self.isClosed) return;
      // En este caso elimina la ruta actual y la reemplaza con la del error
      await Get.offNamed(AppRoutes.MISC_ERROR,
          arguments: MiscErrorArguments(
              content:
                  'Debes habilitar el servicio de ubicación para enviar alertas'));
    }
  }

  void onTipoReservaTap(TaxiReservaType tipo) {
    if (tipoReserva.value == tipo) return;
    tipoReserva.value = tipo;
  }

  Future<void> onFechaSelected() async {
    final date = await pickDate(_context, fechaIda.value ?? DateTime.now());

    if (date != null) {
      final time = await pickTime(_context, date);

      if (time != null) {
        fechaIda.value = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
      }
    }
  }

  // *****************************
  // *****************************
  // *****************************

  final origenName = RxnString();
  LatLng? origenCoords;
  final destinoName = RxnString();
  LatLng? destinoCoords;

  Future<void> onLugarSelected(BusquedaView tipoBusqueda) async {
    if (loadingMyPosition.value) return;

    Get.toNamed(AppRoutes.TAXI_MAPA);

    /* final resp = await Get.toNamed(
      AppRoutes.TAXI_SEARCH,
      arguments: TaxiSearchControllerParams(
        myPosition: myPosition,
        searchTo: tipoBusqueda,
      ),
    );

    if (resp is TaxiSearchResult) {
      final googleData = resp.data;
      final route = googleData.routes.first;
      final tramo = route.legs.first;

      origenName.value = tramo.startAddress;
      origenCoords = LatLng(tramo.startLocation.lat, tramo.startLocation.lng);
      destinoName.value = tramo.endAddress;
      destinoCoords = LatLng(tramo.endLocation.lat, tramo.endLocation.lng);
    } */
  }

  void setVehicleSelected(int id) {
    idVehiculoSelected = id;
    update(['gbListVehiculos']);
  }

  Future<DateTime?> pickDate(
      BuildContext context, DateTime initialDateTime) async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: initialDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      builder: (BuildContext context, Widget? child) {
        if (child == null) return SizedBox();

        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: akAccentColor,
              onPrimary: akTitleColor,
              surface: akAccentColor,
              onSurface: akTitleColor,
            ),
            dialogBackgroundColor: akScaffoldBackgroundColor,
          ),
          child: child,
        );
      },
    );
    return newDate;
  }

  Future<TimeOfDay?> pickTime(
      BuildContext context, DateTime initialDateTime) async {
    final newTime = await showTimePicker(
      context: context,
      initialTime:
          TimeOfDay(hour: initialDateTime.hour, minute: initialDateTime.minute),
      builder: (BuildContext context, Widget? child) {
        if (child == null) return SizedBox();

        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: akAccentColor,
              onPrimary: akTitleColor,
              surface: akScaffoldBackgroundColor,
              onSurface: akTitleColor,
            ),
          ),
          child: child,
        );
      },
    );
    return newTime;
  }
}

class VehicleType {
  final int id;
  final String model;
  final String photoUrl;
  final int slots;

  VehicleType(this.id, this.model, this.photoUrl, {this.slots = 8});
}
