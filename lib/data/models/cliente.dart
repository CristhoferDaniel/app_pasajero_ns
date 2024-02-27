// To parse this JSON data, do
//
//     final clienteCreate = clienteCreateFromJson(jsonString);

import 'dart:convert';

/* ClienteCreate clienteCreateFromJson(String str) =>
    ClienteCreate.fromJson(json.decode(str));

String clienteCreateToJson(ClienteCreate data) => json.encode(data.toJson());

class ClienteCreate {
  ClienteCreate({
    required this.idCliente,
    required this.nombres,
    required this.apellidos,
    required this.numeroDocumento,
    required this.idTipoDocumento,
    required this.uid,
    required this.celular,
    required this.correo,
    this.enable = 1,
    this.fcm,
  });

  int idCliente;
  String nombres;
  String apellidos;
  String numeroDocumento;
  int idTipoDocumento;
  String uid;
  String celular;
  String correo;
  int? enable;
  String? fcm;

  factory ClienteCreate.fromJson(Map<String, dynamic> json) => ClienteCreate(
        idCliente: json["idCliente"],
        nombres: json["nombres"],
        apellidos: json["apellidos"],
        numeroDocumento: json["numeroDocumento"],
        idTipoDocumento: json["idTipoDocumento"],
        uid: json["uid"],
        celular: json["celular"],
        correo: json["correo"],
        enable: json["enable"],
        fcm: json["fcm"],
      );

  Map<String, dynamic> toJson() => {
        "idCliente": idCliente,
        "nombres": nombres,
        "apellidos": apellidos,
        "numeroDocumento": numeroDocumento,
        "idTipoDocumento": idTipoDocumento,
        "uid": uid,
        "celular": celular,
        "correo": correo,
        "enable": enable,
        "fcm": fcm,
      };
}



ClientePorNumeroResponse clientePorNumeroResponseFromJson(String str) =>
    ClientePorNumeroResponse.fromJson(json.decode(str));

String clientePorNumeroResponseToJson(ClientePorNumeroResponse data) =>
    json.encode(data.toJson());

class ClientePorNumeroResponse {
  ClientePorNumeroResponse({
    required this.success,
    this.data = const [],
  });

  bool success;
  List<ClienteCreate> data;

  factory ClientePorNumeroResponse.fromJson(Map<String, dynamic> json) =>
      ClientePorNumeroResponse(
        success: json["success"],
        data: List<ClienteCreate>.from(
            json["data"].map((x) => ClienteCreate.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}  */

/* class ClientePorUidResponse {
  ClientePorUidResponse({
    required this.success,
    this.data,
  });

  bool success;
  ClienteCreate? data;

  factory ClientePorUidResponse.fromJson(Map<String, dynamic> json) =>
      ClientePorUidResponse(
        success: json["success"],
        data: ClienteCreate.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data?.toJson(),
      };
} */
final defaultImageUrl =
    'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png';

class ClienteCreateOrUpdateParams {
  ClienteCreateOrUpdateParams({
    required this.idCliente,
    required this.nombres,
    required this.apellidos,
    required this.numeroDocumento,
    required this.idTipoDocumento,
    required this.uid,
    required this.celular,
    required this.fechaValidacionCelular,
    required this.correo,
    required this.enable,
    required this.fcm,
    required this.foto,
  });

  final int idCliente;
  final String nombres;
  final String apellidos;
  final String numeroDocumento;
  final int idTipoDocumento;
  final String uid;
  final String celular;
  final DateTime fechaValidacionCelular;
  final String correo;
  final int? enable;
  final String? fcm;
  final String? foto;

  factory ClienteCreateOrUpdateParams.fromJson(Map<String, dynamic> json) =>
      ClienteCreateOrUpdateParams(
        idCliente: json["idCliente"],
        nombres: json["nombres"],
        apellidos: json["apellidos"],
        numeroDocumento: json["numeroDocumento"],
        idTipoDocumento: json["idTipoDocumento"],
        uid: json["uid"],
        celular: json["celular"],
        fechaValidacionCelular: DateTime.parse(json["fechaValidacionCelular"]),
        correo: json["correo"],
        enable: json["enable"],
        fcm: json["fcm"],
        foto: json["foto"],
      );

  Map<String, dynamic> toJson() => {
        "idCliente": idCliente,
        "nombres": nombres,
        "apellidos": apellidos,
        "numeroDocumento": numeroDocumento,
        "idTipoDocumento": idTipoDocumento,
        "uid": uid,
        "celular": celular,
        "fechaValidacionCelular": fechaValidacionCelular.toIso8601String(),
        "correo": correo,
        "enable": enable,
        "fcm": fcm,
        "foto": foto ?? defaultImageUrl,
      };
}

class ClienteCreateResponse {
  ClienteCreateResponse({
    required this.success,
    required this.data,
  });

  bool success;
  ClienteDto data;

  factory ClienteCreateResponse.fromJson(Map<String, dynamic> json) =>
      ClienteCreateResponse(
        success: json["success"],
        data: ClienteDto.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
      };
}

// To parse this JSON data, do
//

ClienteDto clienteDtoFromJson(String str) =>
    ClienteDto.fromJson(json.decode(str));

String clienteDtoToJson(ClienteDto data) => json.encode(data.toJson());

class ClienteDto {
  ClienteDto({
    required this.idCliente,
    required this.nombres,
    required this.apellidos,
    required this.numeroDocumento,
    required this.idTipoDocumento,
    required this.uid,
    required this.celular,
    required this.fechaValidacionCelular,
    required this.correo,
    this.enable = 1,
    this.fcm,
    this.foto,
  });

  final int idCliente;
  final String nombres;
  final String apellidos;
  final String numeroDocumento;
  final int idTipoDocumento;
  final String uid;
  final String celular;
  final DateTime fechaValidacionCelular;
  final String correo;
  final int? enable;
  final String? fcm;
  final String? foto;

  ClienteDto copyWith({
    int? idCliente,
    String? nombres,
    String? apellidos,
    String? numeroDocumento,
    int? idTipoDocumento,
    String? uid,
    String? celular,
    DateTime? fechaValidacionCelular,
    String? correo,
    int? enable,
    String? fcm,
    String? foto,
  }) =>
      ClienteDto(
        idCliente: idCliente ?? this.idCliente,
        nombres: nombres ?? this.nombres,
        apellidos: apellidos ?? this.apellidos,
        numeroDocumento: numeroDocumento ?? this.numeroDocumento,
        idTipoDocumento: idTipoDocumento ?? this.idTipoDocumento,
        uid: uid ?? this.uid,
        celular: celular ?? this.celular,
        fechaValidacionCelular:
            fechaValidacionCelular ?? this.fechaValidacionCelular,
        correo: correo ?? this.correo,
        enable: enable ?? this.enable,
        fcm: fcm ?? this.fcm,
        foto: foto ?? this.foto,
      );

  factory ClienteDto.fromJson(Map<String, dynamic> json) => ClienteDto(
        idCliente: json["idCliente"],
        nombres: json["nombres"],
        apellidos: json["apellidos"],
        numeroDocumento: json["numeroDocumento"],
        idTipoDocumento: json["idTipoDocumento"],
        uid: json["uid"],
        celular: json["celular"],
        fechaValidacionCelular: DateTime.parse(json["fechaValidacionCelular"]),
        correo: json["correo"],
        enable: json["enable"],
        fcm: json["fcm"],
        foto: json["foto"] ?? defaultImageUrl,
      );

  Map<String, dynamic> toJson() => {
        "idCliente": idCliente,
        "nombres": nombres,
        "apellidos": apellidos,
        "numeroDocumento": numeroDocumento,
        "idTipoDocumento": idTipoDocumento,
        "uid": uid,
        "celular": celular,
        "fechaValidacionCelular": fechaValidacionCelular.toIso8601String(),
        "correo": correo,
        "enable": enable,
        "fcm": fcm,
        "foto": foto ?? defaultImageUrl,
      };
}

// To parse this JSON data, do
//
//     final clienteListResponse = clienteListResponseFromJson(jsonString);

ClienteListResponse clienteListResponseFromJson(String str) =>
    ClienteListResponse.fromJson(json.decode(str));

String clienteListResponseToJson(ClienteListResponse data) =>
    json.encode(data.toJson());

class ClienteListResponse {
  ClienteListResponse({
    required this.pageNumber,
    required this.pageSize,
    required this.numberOfElements,
    required this.totalElements,
    required this.content,
  });

  final int pageNumber;
  final int pageSize;
  final int numberOfElements;
  final int totalElements;
  final List<ClienteDto> content;

  factory ClienteListResponse.fromJson(Map<String, dynamic> json) =>
      ClienteListResponse(
        pageNumber: json["pageNumber"],
        pageSize: json["pageSize"],
        numberOfElements: json["numberOfElements"],
        totalElements: json["totalElements"],
        content: List<ClienteDto>.from(
            json["content"].map((x) => ClienteDto.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "numberOfElements": numberOfElements,
        "totalElements": totalElements,
        "content": List<dynamic>.from(content.map((x) => x.toJson())),
      };
}
