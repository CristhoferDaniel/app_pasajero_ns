import 'package:app_pasajero_ns/modules/taxi/taxi_mapa/taxi_mapa_controller.dart';
import 'package:app_pasajero_ns/themes/ak_ui.dart';
import 'package:app_pasajero_ns/utils/utils.dart';
import 'package:app_pasajero_ns/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum TaxiReservaType {
  ida,
  idayvuelta,
}

class LayerReservaCtlr extends GetxController {
  //final _keyX = Get.find<KeyboardController>();
  final taxiMapaX = Get.find<TaxiMapaController>();
  late BuildContext _context;

  final paddingBottomForm = (0.0).obs;

  @override
  void onInit() {
    super.onInit();

    // _init();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void setContext(BuildContext c) {
    this._context = c;
  }

  /*Future<void> _init() async {
    ever<double>(_keyX.keyboardHeight, (kheight) {
      paddingBottomForm.value = kheight;
    });
  }*/

  void onTipoReservaTap(TaxiReservaType tipo) {
    if (taxiMapaX.tipoReserva.value == tipo) return;
    taxiMapaX.tipoReserva.value = tipo;
    taxiMapaX.fechaVuelta.value = null;
  }

  Future<void> onFechaSelected({bool ida = true}) async {
    Get.focusScope?.unfocus();
    if (!ida && taxiMapaX.fechaIda.value == null) {
      AppSnackbar().warning(message: 'Primero selecciona la Fecha de ida.');
      return;
    }

    final date = await pickDate(
        _context,
        ida
            ? (taxiMapaX.fechaIda.value ?? DateTime.now())
            : (taxiMapaX.fechaVuelta.value ?? DateTime.now()));

    if (date != null) {
      final time = await pickTime(_context, date);

      if (time != null) {
        final _dateSelected = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
        if (ida) {
          print('_dateSelected: ${_dateSelected.toIso8601String()} ');
          print('datenowlslsfd: ${DateTime.now().toIso8601String()} ');
          print(_dateSelected.isAfter(DateTime.now()));
          if (!(_dateSelected.isAfter(DateTime.now()))) {
            AppSnackbar().warning(
                message:
                    'Debe seleccionar una fecha y hora posterior a la actual.');
            return;
          }

          taxiMapaX.fechaIda.value = _dateSelected;
          taxiMapaX.fechaVuelta.value = null;
        } else {
          // Valida que la fecha de vuelta sea posterior a la de ida
          if (!(_dateSelected.isAfter(taxiMapaX.fechaIda.value!))) {
            AppSnackbar().warning(
                message:
                    'La fecha de regreso debe ser posterior a la fecha de ida.');
            return;
          }

          taxiMapaX.fechaVuelta.value = _dateSelected;
        }
      }
    }
  }

  void onContinueButtonTap() {
    Get.focusScope?.unfocus();
    if (taxiMapaX.fechaIda.value == null) {
      AppSnackbar().warning(message: 'Debes seleccionar la fecha de ida.');
      return;
    }

    if (taxiMapaX.tipoReserva.value == TaxiReservaType.idayvuelta) {
      if (taxiMapaX.fechaVuelta.value == null) {
        AppSnackbar()
            .warning(message: 'Debes seleccionar la fecha de regreso.');
        return;
      }
    }

    taxiMapaX.cambiarModoVista(ModoVista.searchaddress);
  }

  // *****************************
  // ****** DATE FUNCTIONS *******
  // *****************************

  Future<DateTime?> pickDate(BuildContext context, DateTime initialDateTime,
      {DateTime? firstDate, DateTime? lastDate}) async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: initialDateTime,
      firstDate: firstDate ?? DateTime.now(),
      lastDate: lastDate ?? DateTime.now().add(Duration(days: 365)),
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
