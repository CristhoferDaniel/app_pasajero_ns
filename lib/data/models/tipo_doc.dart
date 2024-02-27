// To parse this JSON data, do
//
//     final listTipoDocResponse = listTipoDocResponseFromJson(jsonString);

import 'dart:convert';

ListTipoDocResponse listTipoDocResponseFromJson(String str) =>
    ListTipoDocResponse.fromJson(json.decode(str));

String listTipoDocResponseToJson(ListTipoDocResponse data) =>
    json.encode(data.toJson());

class ListTipoDocResponse {
  ListTipoDocResponse({
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
  final List<TipoDoc> content;

  factory ListTipoDocResponse.fromJson(Map<String, dynamic> json) =>
      ListTipoDocResponse(
        pageNumber: json["pageNumber"],
        pageSize: json["pageSize"],
        numberOfElements: json["numberOfElements"],
        totalElements: json["totalElements"],
        content:
            List<TipoDoc>.from(json["content"].map((x) => TipoDoc.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "numberOfElements": numberOfElements,
        "totalElements": totalElements,
        "content": List<dynamic>.from(content.map((x) => x.toJson())),
      };
}

class TipoDoc {
  TipoDoc({
    required this.idTipoDocumento,
    required this.nombre,
    required this.enable,
  });

  final int idTipoDocumento;
  final String nombre;
  final int enable;

  factory TipoDoc.fromJson(Map<String, dynamic> json) => TipoDoc(
        idTipoDocumento: json["idTipoDocumento"],
        nombre: json["nombre"],
        enable: json["enable"],
      );

  Map<String, dynamic> toJson() => {
        "idTipoDocumento": idTipoDocumento,
        "nombre": nombre,
        "enable": enable,
      };
}
