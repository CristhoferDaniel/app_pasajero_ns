// To parse this JSON data, do
//
//     final preguntasFrecuentesPasajero = preguntasFrecuentesPasajeroFromJson(jsonString);

import 'dart:convert';

CuponResponse cuponResponseFromJson(String str) =>
    CuponResponse.fromJson(json.decode(str));

String cuponResponseToJson(CuponResponse data) => json.encode(data.toJson());

class CuponResponse {
  CuponResponse({
    required this.pageNumber,
    required this.pageSize,
    required this.numberOfElements,
    required this.totalElements,
    required this.content,
  });
  int pageNumber;
  int pageSize;
  int numberOfElements;
  int totalElements;
  List<Cupon> content;

  factory CuponResponse.fromJson(Map<String, dynamic> json) => CuponResponse(
        pageNumber: json["pageNumber"],
        pageSize: json["pageSize"],
        numberOfElements: json["numberOfElements"],
        totalElements: json["totalElements"],
        content:
            List<Cupon>.from(json["content"].map((x) => Cupon.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "numberOfElements": numberOfElements,
        "totalElements": totalElements,
        "content": List<dynamic>.from(content.map((x) => x.toJson())),
      };
}

class Cupon {
  Cupon(
      {required this.idCupon,
      required this.code,
      this.nombre,
      this.descripcion,
      this.fechaInicio,
      this.fechaFin,
      this.valorDesc,
      this.valorDescMax,
      this.cantCupones,
      this.cantCuponesUsados,
      this.cantCuponesLibres,
      this.enable,
      this.idTipoCupon});
  int idCupon;
  String code;
  String? nombre;
  String? descripcion;
  String? fechaInicio;
  String? fechaFin;
  int? valorDesc;
  int? valorDescMax;
  int? cantCupones;
  int? cantCuponesUsados;
  int? cantCuponesLibres;
  int? enable;
  int? idTipoCupon;
  factory Cupon.fromJson(Map<String, dynamic> json) => Cupon(
        idCupon: json["idCupon"],
        code: json["code"],
        nombre: json["nombre"],
        descripcion: json["descripcion"],
        fechaInicio: json["fechaInicio"],
        fechaFin: json["fechaFin"],
        valorDesc: json["valorDesc"],
        valorDescMax: json["valorDescMax"],
        cantCupones: json["cantCupones"],
        cantCuponesUsados: json["cantCuponesUsados"],
        cantCuponesLibres: json["cantCuponesLibres"],
        enable: json["enable"],
        idTipoCupon: json["idTipoCupon"],
      );

  Map<String, dynamic> toJson() => {
        "idCupon": idCupon,
        "code": code,
        "nombre": nombre,
        "descripcion": descripcion,
        "fechaInicio": fechaInicio,
        "fechaFin": fechaFin,
        "valorDesc": valorDesc,
        "valorDescMax": valorDescMax,
        "cantCupones": cantCupones,
        "cantCuponesUsados": cantCuponesUsados,
        "cantCuponesLibres": cantCuponesLibres,
        "enable": enable,
        "idTipoCupon": idTipoCupon,
      };
}
