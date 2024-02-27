// To parse this JSON data, do
//
//     final sosservicioCreateUpdateParams = sosservicioCreateUpdateParamsFromJson(jsonString);

import 'dart:convert';

SosservicioCreateUpdateParams sosservicioCreateUpdateParamsFromJson(
        String str) =>
    SosservicioCreateUpdateParams.fromJson(json.decode(str));

String sosservicioCreateUpdateParamsToJson(
        SosservicioCreateUpdateParams data) =>
    json.encode(data.toJson());

class SosservicioCreateUpdateParams {
  SosservicioCreateUpdateParams({
    required this.idSosServicio,
    required this.fechaHora,
    required this.motivo,
    required this.enable,
    required this.idServicio,
    required this.tipoPersona,
    required this.estado,
    required this.cordLat,
    required this.cordLon,
  });

  final int idSosServicio;
  final DateTime fechaHora;
  final String motivo;
  final int enable;
  final int idServicio;
  final String tipoPersona;
  final int estado;
  final double cordLat;
  final double cordLon;

  factory SosservicioCreateUpdateParams.fromJson(Map<String, dynamic> json) =>
      SosservicioCreateUpdateParams(
        idSosServicio: json["idSosServicio"],
        fechaHora: DateTime.parse(json["fechaHora"]),
        motivo: json["motivo"],
        enable: json["enable"],
        idServicio: json["idServicio"],
        tipoPersona: json["tipoPersona"],
        estado: json["estado"],
        cordLat: json["cordLat"],
        cordLon: json["cordLon"],
      );

  Map<String, dynamic> toJson() => {
        "idSosServicio": idSosServicio,
        "fechaHora": fechaHora.toIso8601String(),
        "motivo": motivo,
        "enable": enable,
        "idServicio": idServicio,
        "tipoPersona": tipoPersona,
        "estado": estado,
        "cordLat": cordLat,
        "cordLon": cordLon,
      };
}

// To parse this JSON data, do
//
//     final sosservicioCreateResponse = sosservicioCreateResponseFromJson(jsonString);

SosservicioCreateResponse sosservicioCreateResponseFromJson(String str) =>
    SosservicioCreateResponse.fromJson(json.decode(str));

String sosservicioCreateResponseToJson(SosservicioCreateResponse data) =>
    json.encode(data.toJson());

class SosservicioCreateResponse {
  SosservicioCreateResponse({
    required this.success,
    required this.data,
  });

  final bool success;
  final SosservicioDto data;

  factory SosservicioCreateResponse.fromJson(Map<String, dynamic> json) =>
      SosservicioCreateResponse(
        success: json["success"],
        data: SosservicioDto.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
      };
}

class SosservicioDto {
  SosservicioDto(
      {required this.idSosServicio,
      required this.fechaHora,
      required this.motivo,
      required this.enable,
      required this.idServicio,
      required this.tipoPersona,
      required this.estado,
      required this.cordLat,
      required this.cordLon});

  final int idSosServicio;
  final DateTime fechaHora;
  final String motivo;
  final int enable;
  final int idServicio;
  final String tipoPersona;
  final int estado;
  final double cordLat;
  final double cordLon;

  factory SosservicioDto.fromJson(Map<String, dynamic> json) => SosservicioDto(
        idSosServicio: json["idSosServicio"],
        fechaHora: DateTime.parse(json["fechaHora"]),
        motivo: json["motivo"],
        enable: json["enable"],
        idServicio: json["idServicio"],
        tipoPersona: json["tipoPersona"],
        estado: json["estado"],
        cordLat: json["cordLat"],
        cordLon: json["cordLon"],
      );

  Map<String, dynamic> toJson() => {
        "idSosServicio": idSosServicio,
        "fechaHora": fechaHora.toIso8601String(),
        "motivo": motivo,
        "enable": enable,
        "idServicio": idServicio,
        "tipoPersona": tipoPersona,
        "estado": estado,
        "cordLat": cordLat,
        "cordLon": cordLon,
      };
}
