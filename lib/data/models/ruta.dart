// To parse this JSON data, do
//
//     final rutaResponse = rutaResponseFromJson(jsonString);

import 'dart:convert';

RutaResponse rutaResponseFromJson(String str) =>
    RutaResponse.fromJson(json.decode(str));

String rutaResponseToJson(RutaResponse data) => json.encode(data.toJson());

class RutaResponse {
  RutaResponse({
    required this.success,
    this.data,
  });

  bool success;
  Ruta? data;

  factory RutaResponse.fromJson(Map<String, dynamic> json) => RutaResponse(
        success: json["success"],
        data: json["data"] == null ? null : Ruta.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data?.toJson(),
      };
}

class Ruta {
  Ruta({
    required this.idRuta,
    this.nombreOrigen,
    this.nombreDestino,
    this.distancia,
    this.duracion,
    this.polyline,
    this.coordenadaOrigen,
    this.coordenadaDestino,
  });

  int idRuta;
  String? nombreOrigen;
  String? nombreDestino;
  int? distancia;
  int? duracion;
  String? polyline;
  String? coordenadaOrigen;
  String? coordenadaDestino;

  factory Ruta.fromJson(Map<String, dynamic> json) => Ruta(
        idRuta: json["idRuta"],
        nombreOrigen: json["nombreOrigen"],
        nombreDestino: json["nombreDestino"],
        distancia: json["distancia"],
        duracion: json["duracion"],
        polyline: json["polyline"],
        coordenadaOrigen: json["coordenadaOrigen"],
        coordenadaDestino: json["coordenadaDestino"],
      );

  Map<String, dynamic> toJson() => {
        "idRuta": idRuta,
        "nombreOrigen": nombreOrigen,
        "nombreDestino": nombreDestino,
        "distancia": distancia,
        "duracion": duracion,
        "polyline": polyline,
        "coordenadaOrigen": coordenadaOrigen,
        "coordenadaDestino": coordenadaDestino,
      };
}
