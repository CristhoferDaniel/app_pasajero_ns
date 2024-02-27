// To parse this JSON data, do
//
//     final paramsCancelacionesSolicitudes = paramsCancelacionesSolicitudesFromJson(jsonString);

import 'dart:convert';

ParamsCancelacionesSolicitudes paramsCancelacionesSolicitudesFromJson(
        String str) =>
    ParamsCancelacionesSolicitudes.fromJson(json.decode(str));

String paramsCancelacionesSolicitudesToJson(
        ParamsCancelacionesSolicitudes data) =>
    json.encode(data.toJson());

class ParamsCancelacionesSolicitudes {
  ParamsCancelacionesSolicitudes({
    required this.idCancelacionesSolicitudesCli,
    required this.idCliente,
    required this.idSolicitud,
    required this.fecha,
  });

  final int idCancelacionesSolicitudesCli;
  final int idCliente;
  final int idSolicitud;
  final DateTime fecha;

  factory ParamsCancelacionesSolicitudes.fromJson(Map<String, dynamic> json) =>
      ParamsCancelacionesSolicitudes(
        idCancelacionesSolicitudesCli: json["idCancelacionesSolicitudesCli"],
        idCliente: json["idCliente"],
        idSolicitud: json["idSolicitud"],
        fecha: DateTime.parse(json["fecha"]),
      );

  Map<String, dynamic> toJson() => {
        "idCancelacionesSolicitudesCli": idCancelacionesSolicitudesCli,
        "idCliente": idCliente,
        "idSolicitud": idSolicitud,
        "fecha": fecha.toIso8601String(),
      };
}

// To parse this JSON data, do
//
//     final responseCancelacionesSolicitudes = responseCancelacionesSolicitudesFromJson(jsonString);

ResponseCancelacionesSolicitudes responseCancelacionesSolicitudesFromJson(
        String str) =>
    ResponseCancelacionesSolicitudes.fromJson(json.decode(str));

String responseCancelacionesSolicitudesToJson(
        ResponseCancelacionesSolicitudes data) =>
    json.encode(data.toJson());

class ResponseCancelacionesSolicitudes {
  ResponseCancelacionesSolicitudes({
    required this.success,
    required this.data,
  });

  final bool success;
  final Data data;

  factory ResponseCancelacionesSolicitudes.fromJson(
          Map<String, dynamic> json) =>
      ResponseCancelacionesSolicitudes(
        success: json["success"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.idCancelacionesSolicitudesCli,
    required this.idCliente,
    required this.idSolicitud,
    required this.fecha,
  });

  final int idCancelacionesSolicitudesCli;
  final int idCliente;
  final int idSolicitud;
  final DateTime fecha;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        idCancelacionesSolicitudesCli: json["idCancelacionesSolicitudesCli"],
        idCliente: json["idCliente"],
        idSolicitud: json["idSolicitud"],
        fecha: DateTime.parse(json["fecha"]),
      );

  Map<String, dynamic> toJson() => {
        "idCancelacionesSolicitudesCli": idCancelacionesSolicitudesCli,
        "idCliente": idCliente,
        "idSolicitud": idSolicitud,
        "fecha": fecha.toIso8601String(),
      };
}
