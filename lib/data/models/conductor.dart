// To parse this JSON data, do
//
//     final conductorDto = conductorDtoFromJson(jsonString);

import 'dart:convert';

import 'package:app_pasajero_ns/data/models/vehiculo.dart';

ConductorDto conductorDtoFromJson(String str) =>
    ConductorDto.fromJson(json.decode(str));
String conductorDtoToJson(ConductorDto data) => json.encode(data.toJson());

class ConductorCreateOrUpdateParams {
  ConductorCreateOrUpdateParams({
    required this.idConductor,
    required this.nombres,
    required this.apellidos,
    required this.numeroDocumento,
    required this.idTipoDocumento,
    required this.uid,
    required this.celular,
    required this.fechaValidacionCelular,
    required this.correo,
    required this.idBanco,
    required this.foto,
    required this.numeroCuenta,
    required this.numeroCuentaInterbancaria,
    required this.licencia,
    required this.idEstadoConductor,
    required this.fcm,
    required this.enable,
    required this.fechaRegistro,
  });

  final int idConductor;
  final String? nombres;
  final String? apellidos;
  final String numeroDocumento;
  final int idTipoDocumento;
  final String? uid;
  final String? celular;
  final DateTime fechaValidacionCelular;
  final String? correo;
  final int? idBanco;
  final String? foto;
  final String? numeroCuenta;
  final String? numeroCuentaInterbancaria;
  final String? licencia;
  final int idEstadoConductor;
  final String? fcm;
  final int enable;
  final DateTime fechaRegistro;

  factory ConductorCreateOrUpdateParams.fromJson(Map<String, dynamic> json) =>
      ConductorCreateOrUpdateParams(
        idConductor: json["idConductor"],
        nombres: json["nombres"],
        apellidos: json["apellidos"],
        numeroDocumento: json["numeroDocumento"],
        idTipoDocumento: json["idTipoDocumento"],
        uid: json["uid"],
        celular: json["celular"],
        fechaValidacionCelular: DateTime.parse(json["fechaValidacionCelular"]),
        correo: json["correo"],
        idBanco: json["idBanco"],
        foto: json["foto"],
        numeroCuenta: json["numeroCuenta"],
        numeroCuentaInterbancaria: json["numeroCuentaInterbancaria"],
        licencia: json["licencia"],
        idEstadoConductor: json["idEstadoConductor"],
        fcm: json["fcm"],
        enable: json["enable"],
        fechaRegistro: DateTime.parse(json["fechaRegistro"]),
      );

  Map<String, dynamic> toJson() => {
        "idConductor": idConductor,
        "nombres": nombres,
        "apellidos": apellidos,
        "numeroDocumento": numeroDocumento,
        "idTipoDocumento": idTipoDocumento,
        "uid": uid,
        "celular": celular,
        "fechaValidacionCelular": fechaValidacionCelular.toIso8601String(),
        "correo": correo,
        "idBanco": idBanco,
        "foto": foto,
        "numeroCuenta": numeroCuenta,
        "numeroCuentaInterbancaria": numeroCuentaInterbancaria,
        "licencia": licencia,
        "idEstadoConductor": idEstadoConductor,
        "fcm": fcm,
        "enable": enable,
        "fechaRegistro": fechaRegistro.toIso8601String(),
      };
}

ConductorCreateResponse conductorCreateResponseFromJson(String str) =>
    ConductorCreateResponse.fromJson(json.decode(str));
String conductorCreateResponseToJson(ConductorCreateResponse data) =>
    json.encode(data.toJson());

class ConductorCreateResponse {
  ConductorCreateResponse({
    required this.success,
    required this.data,
  });

  bool success;
  ConductorDto data;

  factory ConductorCreateResponse.fromJson(Map<String, dynamic> json) =>
      ConductorCreateResponse(
        success: json["success"],
        data: ConductorDto.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
      };
}

// To parse this JSON data, do
//
//     final conductorDto = conductorDtoFromJson(jsonString);

class ConductorDto {
  ConductorDto({
    required this.idConductor,
    this.nombres,
    this.apellidos,
    required this.numeroDocumento,
    required this.idTipoDocumento,
    required this.uid,
    this.celular,
    required this.fechaValidacionCelular,
    this.correo,
    this.idBanco,
    this.foto,
    this.numeroCuenta,
    this.numeroCuentaInterbancaria,
    required this.enable,
    this.licencia,
    required this.idEstadoConductor,
    this.fcm,
    this.vehiculos,
    required this.fechaRegistro,
  });

  final int idConductor;
  final String? nombres;
  final String? apellidos;
  final String numeroDocumento;
  final int idTipoDocumento;
  final String uid;
  final String? celular;
  final DateTime fechaValidacionCelular;
  final String? correo;
  final int? idBanco;
  final String? foto;
  final String? numeroCuenta;
  final String? numeroCuentaInterbancaria;
  final int enable;
  final String? licencia;
  final int idEstadoConductor;
  final String? fcm;
  final List<Vehiculo>? vehiculos;
  final DateTime fechaRegistro;

  ConductorDto copyWith({
    int? idConductor,
    String? nombres,
    String? apellidos,
    String? numeroDocumento,
    int? idTipoDocumento,
    String? uid,
    String? celular,
    DateTime? fechaValidacionCelular,
    String? correo,
    int? idBanco,
    String? foto,
    String? numeroCuenta,
    String? numeroCuentaInterbancaria,
    int? enable,
    String? licencia,
    int? idEstadoConductor,
    String? fcm,
    List<Vehiculo>? vehiculos,
    DateTime? fechaRegistro,
  }) =>
      ConductorDto(
        idConductor: idConductor ?? this.idConductor,
        nombres: nombres ?? this.nombres,
        apellidos: apellidos ?? this.apellidos,
        numeroDocumento: numeroDocumento ?? this.numeroDocumento,
        idTipoDocumento: idTipoDocumento ?? this.idTipoDocumento,
        uid: uid ?? this.uid,
        celular: celular ?? this.celular,
        fechaValidacionCelular:
            fechaValidacionCelular ?? this.fechaValidacionCelular,
        correo: correo ?? this.correo,
        idBanco: idBanco ?? this.idBanco,
        foto: foto ?? this.foto,
        numeroCuenta: numeroCuenta ?? this.numeroCuenta,
        numeroCuentaInterbancaria:
            numeroCuentaInterbancaria ?? this.numeroCuentaInterbancaria,
        enable: enable ?? this.enable,
        licencia: licencia ?? this.licencia,
        idEstadoConductor: idEstadoConductor ?? this.idEstadoConductor,
        fcm: fcm ?? this.fcm,
        // Tener cuidado, siempre mantener los vehículos que se obtuvieron
        // al iniciar la aplicación
        vehiculos: vehiculos ?? this.vehiculos,
        fechaRegistro: fechaRegistro ?? this.fechaRegistro,
      );

  factory ConductorDto.fromJson(Map<String, dynamic> json) => ConductorDto(
        idConductor: json["idConductor"],
        nombres: json["nombres"],
        apellidos: json["apellidos"],
        numeroDocumento: json["numeroDocumento"],
        idTipoDocumento: json["idTipoDocumento"],
        uid: json["uid"],
        celular: json["celular"],
        fechaValidacionCelular: DateTime.parse(json["fechaValidacionCelular"]),
        correo: json["correo"],
        idBanco: json["idBanco"],
        foto: json["foto"],
        numeroCuenta: json["numeroCuenta"],
        numeroCuentaInterbancaria: json["numeroCuentaInterbancaria"],
        enable: json["enable"],
        licencia: json["licencia"],
        idEstadoConductor: json["idEstadoConductor"],
        fcm: json["fcm"],
        vehiculos: json["vehiculos"] == null
            ? null
            : List<Vehiculo>.from(
                json["vehiculos"].map((x) => Vehiculo.fromJson(x))),
        fechaRegistro: DateTime.parse(json["fechaRegistro"]),
      );

  Map<String, dynamic> toJson() => {
        "idConductor": idConductor,
        "nombres": nombres,
        "apellidos": apellidos,
        "numeroDocumento": numeroDocumento,
        "idTipoDocumento": idTipoDocumento,
        "uid": uid,
        "celular": celular,
        "fechaValidacionCelular": fechaValidacionCelular.toIso8601String(),
        "correo": correo,
        "idBanco": idBanco,
        "foto": foto,
        "numeroCuenta": numeroCuenta,
        "numeroCuentaInterbancaria": numeroCuentaInterbancaria,
        "enable": enable,
        "licencia": licencia,
        "idEstadoConductor": idEstadoConductor,
        "fcm": fcm,
        "vehiculos": vehiculos == null
            ? null
            : List<dynamic>.from(vehiculos!.map((x) => x.toJson())),
        "fechaRegistro": fechaRegistro.toIso8601String(),
      };
}

// To parse this JSON data, do
//
//     final conductorListResponse = conductorListResponseFromJson(jsonString);

ConductorListResponse conductorListResponseFromJson(String str) =>
    ConductorListResponse.fromJson(json.decode(str));

String conductorListResponseToJson(ConductorListResponse data) =>
    json.encode(data.toJson());

class ConductorListResponse {
  ConductorListResponse({
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
  final List<ConductorDto> content;

  factory ConductorListResponse.fromJson(Map<String, dynamic> json) =>
      ConductorListResponse(
        pageNumber: json["pageNumber"],
        pageSize: json["pageSize"],
        numberOfElements: json["numberOfElements"],
        totalElements: json["totalElements"],
        content: List<ConductorDto>.from(
            json["content"].map((x) => ConductorDto.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "numberOfElements": numberOfElements,
        "totalElements": totalElements,
        "content": List<dynamic>.from(content.map((x) => x.toJson())),
      };
}
