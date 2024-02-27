import 'package:app_pasajero_ns/data/models/conductor.dart';
import 'package:app_pasajero_ns/utils/utils.dart';
import 'package:get/instance_manager.dart';

class ConductorProvider {
  final DioClient _dioClient = Get.find<DioClient>();

  final String _endpoint = '/conductor';

  Future<ConductorCreateResponse> create(ConductorDto dto) async {
    final params = ConductorCreateOrUpdateParams(
      idConductor: dto.idConductor,
      nombres: dto.nombres,
      apellidos: dto.apellidos,
      numeroDocumento: dto.numeroDocumento,
      idTipoDocumento: dto.idTipoDocumento,
      uid: dto.uid,
      celular: dto.celular,
      fechaValidacionCelular: dto.fechaValidacionCelular,
      correo: dto.correo,
      idBanco: dto.idBanco,
      foto: dto.foto,
      numeroCuenta: dto.numeroCuenta,
      numeroCuentaInterbancaria: dto.numeroCuentaInterbancaria,
      licencia: dto.licencia,
      idEstadoConductor: dto.idEstadoConductor, // 1-Desconectado
      fcm: dto.fcm,
      enable: dto.enable,
      fechaRegistro: dto.fechaRegistro,
    );

    final resp = await _dioClient.post('$_endpoint', data: params.toJson());
    return ConductorCreateResponse.fromJson(resp);
  }

  Future<ConductorCreateResponse> update(
      int idConductor, ConductorDto dto) async {
    final params = ConductorCreateOrUpdateParams(
      idConductor: dto.idConductor,
      nombres: dto.nombres,
      apellidos: dto.apellidos,
      numeroDocumento: dto.numeroDocumento,
      idTipoDocumento: dto.idTipoDocumento,
      uid: dto.uid,
      celular: dto.celular,
      fechaValidacionCelular: dto.fechaValidacionCelular,
      correo: dto.correo,
      idBanco: dto.idBanco,
      foto: dto.foto,
      numeroCuenta: dto.numeroCuenta,
      numeroCuentaInterbancaria: dto.numeroCuentaInterbancaria,
      licencia: dto.licencia,
      idEstadoConductor: dto.idEstadoConductor, // 1-Desconectado
      fcm: dto.fcm,
      enable: dto.enable,
      fechaRegistro: dto.fechaRegistro,
    );

    final resp = await _dioClient.put('$_endpoint?id=$idConductor',
        data: params.toJson());
    return ConductorCreateResponse.fromJson(resp);
  }

  Future<ConductorCreateResponse> getById(int idConductor) async {
    final resp = await _dioClient.get(
      '$_endpoint/id',
      queryParameters: {'id': idConductor},
    );
    return ConductorCreateResponse.fromJson(resp);
  }

  Future<ConductorCreateResponse> searchByUid(String uid) async {
    final resp = await _dioClient.get(
      '$_endpoint/uid',
      queryParameters: {'uid': uid},
    );
    return ConductorCreateResponse.fromJson(resp);
  }

  Future<ConductorListResponse> searchByPhoneNumber(String phone) async {
    final resp = await _dioClient.get(
      '$_endpoint/celular',
      queryParameters: {
        'phone': phone,
        'page': 1,
        'limit': 100,
      },
    );
    return ConductorListResponse.fromJson(resp);
  }

  Future<String?> getFcmTokenByUid(String uid) async {
    final resp = await _dioClient.get(
      '$_endpoint/uid',
      queryParameters: {'uid': uid},
    );
    final data = resp['data'];
    if (data['fcm'] != null && data['fcm'].toString().isNotEmpty) {
      return data['fcm'].toString();
    } else {
      return null;
    }
  }

  Future<ConductorCreateResponse> updateFcmToken(
      int idConductor, String fcmToken) async {
    final resp = await _dioClient.put(
      '$_endpoint/fcm',
      queryParameters: {'id': idConductor, 'fcm': fcmToken},
    );
    return ConductorCreateResponse.fromJson(resp);
  }
}
