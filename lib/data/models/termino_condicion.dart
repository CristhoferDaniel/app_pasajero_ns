// To parse this JSON data, do
//
//     final terminoCondicion = terminoCondicionFromJson(jsonString);

import 'dart:convert';

List<TerminoCondicion> terminoCondicionFromJson(String str) =>
    List<TerminoCondicion>.from(
        json.decode(str).map((x) => TerminoCondicion.fromJson(x)));

String terminoCondicionToJson(List<TerminoCondicion> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TerminoCondicion {
  TerminoCondicion({
    required this.idTerminosCondiciones,
    required this.contenido,
    required this.codeCategoria,
    required this.enable,
  });

  final int idTerminosCondiciones;
  final String contenido;
  final String codeCategoria;
  final int enable;

  factory TerminoCondicion.fromJson(Map<String, dynamic> json) =>
      TerminoCondicion(
        idTerminosCondiciones: json["idTerminosCondiciones"],
        contenido: json["contenido"],
        codeCategoria: json["codeCategoria"],
        enable: json["enable"],
      );

  Map<String, dynamic> toJson() => {
        "idTerminosCondiciones": idTerminosCondiciones,
        "contenido": contenido,
        "codeCategoria": codeCategoria,
        "enable": enable,
      };
}
