import 'package:app_pasajero_ns/data/models/cupon.dart';
import 'package:app_pasajero_ns/data/providers/cupon_provider.dart';
import 'package:app_pasajero_ns/data/providers/travel_info_provider.dart';
import 'package:app_pasajero_ns/modules/auth/auth_controller.dart';
import 'package:app_pasajero_ns/utils/utils.dart';
import 'package:app_pasajero_ns/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaxiCuponController extends GetxController {
  late TaxiCuponController _self;
  String detalleTotal = '';

  final AuthController _authX = Get.find<AuthController>();
  final _travelInfoProvider = TravelInfoProvider();
  final finishingTravel = false.obs;
  final _cuponProvider = CuponProvider();
  final formKey = GlobalKey<FormState>();

  String code = '';

  @override
  void onInit() {
    super.onInit();
    _self = this;
  }

  Future<void> onClickValidateCupon() async {
    final tvl = await _travelInfoProvider.getByUidClient(_authX.getUser!.uid);
    Helpers.logger.i("VIAJE");
    if(tvl == null){
      AppSnackbar().error(message: "El cupón solo es valido antes de que el conductor finalice el viaje");
      return;
    }
    Helpers.logger.i(tvl.toJson().toString());
    final resp = await _cuponProvider.validateCupon(this.code);
    if (resp.content.length > 0) {
      Cupon datosCupon = resp.content[0];
      double descuento =0.00;
      if(datosCupon.idTipoCupon == 1){
        descuento = (tvl.costo * double.parse(datosCupon.valorDesc.toString()))/100; 
      }else if(datosCupon.idTipoCupon == 2){
        descuento = double.parse(datosCupon.valorDesc.toString()); 
      }
      Map<String, dynamic> data = {
        'idCupon': datosCupon.idCupon,
        'descuento': descuento,
      };
      Helpers.logger.i(descuento);

      await _travelInfoProvider.update(
          _authX.getUser!, data, _authX.getUser!.uid);
      Get.back();
    }else{
      AppSnackbar().error(message: "Cupón inválido");
    }
  }
}
