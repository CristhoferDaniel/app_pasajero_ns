// To parse this JSON data, do
//
//     final categoriaSitePaginatedResponse = categoriaSitePaginatedResponseFromJson(jsonString);

import 'dart:convert';

CategoriaSitePaginatedResponse categoriaSitePaginatedResponseFromJson(
        String str) =>
    CategoriaSitePaginatedResponse.fromJson(json.decode(str));

String categoriaSitePaginatedResponseToJson(
        CategoriaSitePaginatedResponse data) =>
    json.encode(data.toJson());

class CategoriaSitePaginatedResponse {
  CategoriaSitePaginatedResponse({
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
  List<CategoriaSite> content;

  factory CategoriaSitePaginatedResponse.fromJson(Map<String, dynamic> json) =>
      CategoriaSitePaginatedResponse(
        pageNumber: json["pageNumber"],
        pageSize: json["pageSize"],
        numberOfElements: json["numberOfElements"],
        totalElements: json["totalElements"],
        content: List<CategoriaSite>.from(
            json["content"].map((x) => CategoriaSite.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "numberOfElements": numberOfElements,
        "totalElements": totalElements,
        "content": List<dynamic>.from(content.map((x) => x.toJson())),
      };
}

class CategoriaSite {
  CategoriaSite({
    required this.idCategoria,
    this.nombre,
    this.enable,
  });

  int idCategoria;
  String? nombre;
  int? enable;

  factory CategoriaSite.fromJson(Map<String, dynamic> json) => CategoriaSite(
        idCategoria: json["idCategoria"],
        nombre: json["nombre"],
        enable: json["enable"],
      );

  Map<String, dynamic> toJson() => {
        "idCategoria": idCategoria,
        "nombre": nombre,
        "enable": enable,
      };
}
