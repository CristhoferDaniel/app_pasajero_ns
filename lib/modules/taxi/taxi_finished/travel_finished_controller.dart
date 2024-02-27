import 'dart:async';

import 'package:app_pasajero_ns/data/models/travel_info.dart';
import 'package:app_pasajero_ns/data/providers/concepto_provider.dart';
import 'package:app_pasajero_ns/data/providers/servicio_provider.dart';
import 'package:app_pasajero_ns/data/providers/travel_info_provider.dart';
import 'package:app_pasajero_ns/modules/auth/auth_controller.dart';
import 'package:app_pasajero_ns/modules/misc/error/misc_error_controller.dart';
import 'package:app_pasajero_ns/routes/app_pages.dart';
import 'package:app_pasajero_ns/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class TaxiFinishedController extends GetxController {
  late TaxiFinishedController _self;
  String detalleTotal = '';

  final AuthController _authX = Get.find<AuthController>();
  final _travelInfoProvider = TravelInfoProvider();
  final _servicioProvider = ServicioProvider();
  final _conceptoProvider = ConceptoProvider();

  String totalDistancia = '';
  String totalTiempo = '';

  // String total = '';

  bool loadingData = false;

  final finishingTravel = false.obs;

  final gbInfo = 'gbInfo';

  final idCupon = 0.obs;
  final descuento = "".obs;

  @override
  void onInit() {
    super.onInit();
    _self = this;
    _init();
  }

  void _init() async {
    detalleTotal =
        'El total final del viaje es de S/. $total, la tarifa incluye todos los cargos.\nEl valor toal del cupón de descuento de S/ 8.00 se te depositará por separado.';

    _getTravelData();
  }

  Future<void> _getTravelData() async {
    bool isOk = false;
    String? errorMsg;
    try {
      loadingData = true;
      // update(['gbPayBar', 'gbContent', 'gbBottom']);
      final tvl = await _travelInfoProvider.getByUidClient(_authX.getUser!.uid);

      if (tvl != null) {
        if (tvl.startDate != null && tvl.finishDate != null) {
          // // esto fue agregado a ultimo momento
          // final duration = tvl.finishDate!.difference(tvl.startDate!).inSeconds;
          // final distance = tvl.estimatedDistance;

          // var servicio =
          //     (await _servicioProvider.getById(tvl.idServicio)) //  + 4500))
          //         .data;

          // final resp = await _conceptoProvider.simulacionTaxi(
          //     metros: distance,
          //     segundos: duration,
          //     idTipoVehiculo: servicio!.idTipoVehiculo);
          // if (resp.success) {
          //   final data = resp.data;
          //   final calculado = data.precioCalculado;
          //   total.value = calculado;
          //   totalDistancia = distance.toString();
          //   totalTiempo = duration.toString() + 'min'; // dESHCARCODEAR MIN
          //   isOk = true;
          // }
          // fin

          _beginTravelListener(
              idSolicitud: tvl.idSolicitud, idServicio: tvl.idServicio);

          // total = '9.99';
          isOk = true;
        }
      } else {
        throw BusinessException('No se encontró la información del viaje.');
      }
    } on ApiException catch (e) {
      errorMsg = e.message;
      Helpers.logger.e(e.message);
    } on BusinessException catch (e) {
      errorMsg = e.message;
      Helpers.logger.e(e.message);
    } catch (e) {
      errorMsg = 'Ocurrió un error inesperado.';
      Helpers.logger.e(e.toString());
    }

    if (_self.isClosed) return;
    if (errorMsg != null) {
      final ers = await Get.toNamed(AppRoutes.MISC_ERROR,
          arguments: MiscErrorArguments(content: errorMsg));
      if (ers == MiscErrorResult.retry) {
        await Helpers.sleep(1500);
        _getTravelData();
      } else {
        loadingData = false;
        print(
            'Cancelar... que hacer????'); // TODO: QUE HACER CUANDO EL ERROR NO SE PUEDE SOLUCIONAR
      }
    } else {
      loadingData = false;
      print(
          'DATA CORRECTA.... QUE HACER???'); // TODO: QUE HACER CUANDO EL ERROR NO SE PUEDE SOLUCIONAR

      if (isOk) {
        update([gbInfo]);
      }
    }
  }

  Future<void> onFinishBtnTap() async {
    /* finishingTravel.value = true;
    await Helpers.sleep(1500);
    finishingTravel.value = false;
    _goToRating();
    return; */

    if (finishingTravel.value) return;
    finishingTravel.value = true;
    try {
    //await tryCatch(
      //code: () async {
        await _travelInfoProvider.update(
            _authX.getUser!, {'status': 'created'}, _authX.getUser!.uid);
        _goToRating();
      //},
    //);
    } catch (e) {
      Get.offAllNamed(AppRoutes.HOME);
    }
    finishingTravel.value = false;
  }

  void _goToRating() {
    Get.toNamed(AppRoutes.TAXI_RATING);
  }

  void goToCupon() {
    Get.toNamed(AppRoutes.TAXI_CUPON);
  }

  StreamSubscription<DocumentSnapshot>? _travelStatusSub;
  final total = "".obs;

  void _beginTravelListener(
      {required int idSolicitud, required int idServicio}) async {
    _travelStatusSub?.cancel();
    Stream<DocumentSnapshot> stream =
        _travelInfoProvider.getByIdStreamWithMetaChanges(_authX.getUser!.uid);
    _travelStatusSub = stream.listen((DocumentSnapshot document) {
      TravelInfo travelInfo =
          TravelInfo.fromJson(document.data() as Map<String, dynamic>);

      // total = travelInfo.costo.toString();

      idCupon.value = travelInfo.idCupon;
      descuento.value = travelInfo.descuento.toString();
      total.value =
          (travelInfo.total - travelInfo.descuento).toStringAsFixed(2);

      // if (idCupon.value > 0) {
      //   ttotal.value =
      //       (double.parse(ttotal.value) - double.parse(descuento.value))
      //           .toStringAsFixed(2);
      // }
    });
  }
}
