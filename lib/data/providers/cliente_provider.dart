import 'package:app_pasajero_ns/data/models/cliente.dart';
import 'package:app_pasajero_ns/utils/utils.dart';
import 'package:get/instance_manager.dart';

import '../models/buscar_documento.dart';

class ClienteProvider {
  final DioClient _dioClient = Get.find<DioClient>();

  final String _endpoint = '/cliente';
  final String _endpointDni = '/busquedadocumento/dni';
  Future<ClienteCreateResponse> create(ClienteDto dto) async {
    final params = ClienteCreateOrUpdateParams(
      idCliente: dto.idCliente,
      nombres: dto.nombres,
      apellidos: dto.apellidos,
      numeroDocumento: dto.numeroDocumento,
      idTipoDocumento: dto.idTipoDocumento,
      uid: dto.uid,
      celular: dto.celular,
      fechaValidacionCelular: dto.fechaValidacionCelular,
      correo: dto.correo,
      enable: dto.enable,
      fcm: dto.fcm,
      foto: dto.foto,
    );

    final resp = await _dioClient.post('$_endpoint', data: params.toJson());
    return ClienteCreateResponse.fromJson(resp);
  }

  Future<ClienteCreateResponse> update(int idCliente, ClienteDto dto) async {
    final params = ClienteCreateOrUpdateParams(
      idCliente: dto.idCliente,
      nombres: dto.nombres,
      apellidos: dto.apellidos,
      numeroDocumento: dto.numeroDocumento,
      idTipoDocumento: dto.idTipoDocumento,
      uid: dto.uid,
      celular: dto.celular,
      fechaValidacionCelular: dto.fechaValidacionCelular,
      correo: dto.correo,
      enable: dto.enable,
      fcm: dto.fcm,
      foto: dto.foto,
    );

    final resp =
        await _dioClient.put('$_endpoint?id=$idCliente', data: params.toJson());
    return ClienteCreateResponse.fromJson(resp);
  }

  Future<ClienteCreateResponse> searchByUid(String uid) async {
    final resp = await _dioClient.get(
      '$_endpoint/uid',
      queryParameters: {'uid': uid},
    );
    return ClienteCreateResponse.fromJson(resp);
  }

  Future<ClienteListResponse> searchByPhoneNumber(String phone) async {
    final resp = await _dioClient.get(
      '$_endpoint/celular',
      queryParameters: {
        'phone': phone,
        'page': 1,
        'limit': 100,
      },
    );
    return ClienteListResponse.fromJson(resp);
  }
  
  Future<ClienteCreateResponse> updateFcmToken(
      int idCliente, String fcmToken) async {
    final resp = await _dioClient.put(
      '$_endpoint/fcm',
      queryParameters: {'id': idCliente, 'fcm': fcmToken},
    );
    return ClienteCreateResponse.fromJson(resp);
  }
  Future<DocumentoListResponse>findDocument(String dni) async {
    final resp = await _dioClient.get(
      '$_endpointDni',
      queryParameters: {
        'numero': dni,
      },
    );
    return DocumentoListResponse.fromJson(resp);
  }
}
