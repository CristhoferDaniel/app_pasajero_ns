// To parse this JSON data, do
//
//     final solicitudPasajeroCreate = solicitudPasajeroCreateFromJson(jsonString);

import 'dart:convert';

SolicitudPasajeroCreate solicitudPasajeroCreateFromJson(String str) =>
    SolicitudPasajeroCreate.fromJson(json.decode(str));

String solicitudPasajeroCreateToJson(SolicitudPasajeroCreate data) =>
    json.encode(data.toJson());

class SolicitudPasajeroCreate {
  SolicitudPasajeroCreate({
    required this.idCliente,
    this.totalFinal = 0,
    this.total = 0,
    this.cupon = 0,
    this.descuento = 0,
    this.distancia = 0,
    required this.coordenadaDestino,
    required this.coordenadaOrigen,
    required this.nombreDestino,
    required this.nombreOrigen,
    required this.polyline,
    this.duracion = 0,
    this.cantPasajeros = 1,
    required this.idTipoServicio,
  });

  int idCliente;
  double totalFinal;
  double total;
  int cupon;
  int descuento;
  int distancia;
  String coordenadaDestino;
  String coordenadaOrigen;
  String nombreDestino;
  String nombreOrigen;
  String polyline;
  int duracion;
  int cantPasajeros;
  int idTipoServicio;

  factory SolicitudPasajeroCreate.fromJson(Map<String, dynamic> json) =>
      SolicitudPasajeroCreate(
        idCliente: json["idCliente"],
        totalFinal:
            json["totalFinal"] == null ? null : json["totalFinal"].toDouble(),
        total: json["total"] == null ? null : json["total"].toDouble(),
        cupon: json["cupon"],
        descuento: json["descuento"],
        distancia: json["distancia"],
        coordenadaDestino: json["coordenadaDestino"],
        coordenadaOrigen: json["coordenadaOrigen"],
        nombreDestino: json["nombreDestino"],
        nombreOrigen: json["nombreOrigen"],
        polyline: json["polyline"],
        duracion: json["duracion"],
        cantPasajeros: json["cantPasajeros"],
        idTipoServicio: json["idTipoServicio"],
      );

  Map<String, dynamic> toJson() => {
        "idCliente": idCliente,
        "totalFinal": totalFinal,
        "total": total,
        "cupon": cupon,
        "descuento": descuento,
        "distancia": distancia,
        "coordenadaDestino": coordenadaDestino,
        "coordenadaOrigen": coordenadaOrigen,
        "nombreDestino": nombreDestino,
        "nombreOrigen": nombreOrigen,
        "polyline": polyline,
        "duracion": duracion,
        "cantPasajeros": cantPasajeros,
        "idTipoServicio": idTipoServicio,
      };
}

SolicitudPasajeroResponse solicitudPasajeroResponseFromJson(String str) =>
    SolicitudPasajeroResponse.fromJson(json.decode(str));

String solicitudPasajeroResponseToJson(SolicitudPasajeroResponse data) =>
    json.encode(data.toJson());

class SolicitudPasajeroResponse {
  SolicitudPasajeroResponse({
    required this.idSolicitud,
    required this.idServicio,
  });

  int idSolicitud;
  int idServicio;

  factory SolicitudPasajeroResponse.fromJson(Map<String, dynamic> json) =>
      SolicitudPasajeroResponse(
        idSolicitud: json["idSolicitud"],
        idServicio: json["idServicio"],
      );

  Map<String, dynamic> toJson() => {
        "idSolicitud": idSolicitud,
        "idServicio": idServicio,
      };
}
