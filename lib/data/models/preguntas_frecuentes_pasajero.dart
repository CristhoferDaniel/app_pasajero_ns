// To parse this JSON data, do
//
//     final preguntasFrecuentesPasajero = preguntasFrecuentesPasajeroFromJson(jsonString);

import 'dart:convert';

List<PreguntasFrecuentesPasajero> preguntasFrecuentesPasajeroFromJson(
        String str) =>
    List<PreguntasFrecuentesPasajero>.from(
        json.decode(str).map((x) => PreguntasFrecuentesPasajero.fromJson(x)));

String preguntasFrecuentesPasajeroToJson(
        List<PreguntasFrecuentesPasajero> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PreguntasFrecuentesPasajero {
  PreguntasFrecuentesPasajero({
    required this.idPreguntasFrecuentes,
    required this.pregunta,
    required this.respuesta,
    required this.enable,
    required this.codeCategoria,
  });

  int idPreguntasFrecuentes;
  String pregunta;
  String respuesta;
  int enable;
  String codeCategoria;

  factory PreguntasFrecuentesPasajero.fromJson(Map<String, dynamic> json) =>
      PreguntasFrecuentesPasajero(
        idPreguntasFrecuentes: json["idPreguntasFrecuentes"],
        pregunta: json["pregunta"],
        respuesta: json["respuesta"],
        enable: json["enable"],
        codeCategoria: json["codeCategoria"],
      );

  Map<String, dynamic> toJson() => {
        "idPreguntasFrecuentes": idPreguntasFrecuentes,
        "pregunta": pregunta,
        "respuesta": respuesta,
        "enable": enable,
        "codeCategoria": codeCategoria,
      };
}
