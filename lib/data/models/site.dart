// To parse this JSON data, do
//
//     final sitePaginatedResponse = sitePaginatedResponseFromJson(jsonString);

import 'dart:convert';

SitePaginatedResponse sitePaginatedResponseFromJson(String str) =>
    SitePaginatedResponse.fromJson(json.decode(str));

String sitePaginatedResponseToJson(SitePaginatedResponse data) =>
    json.encode(data.toJson());

class SitePaginatedResponse {
  SitePaginatedResponse({
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
  List<Site> content;

  factory SitePaginatedResponse.fromJson(Map<String, dynamic> json) =>
      SitePaginatedResponse(
        pageNumber: json["pageNumber"],
        pageSize: json["pageSize"],
        numberOfElements: json["numberOfElements"],
        totalElements: json["totalElements"],
        content: List<Site>.from(json["content"].map((x) => Site.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "numberOfElements": numberOfElements,
        "totalElements": totalElements,
        "content": List<dynamic>.from(content.map((x) => x.toJson())),
      };
}

class Site {
  Site({
    required this.idSite,
    this.nombre,
    this.direccion,
    this.foto,
    this.valoracion,
    this.contacto,
    this.rangoPrecio,
    this.idPoint,
    this.idCategoria,
    this.point,
    this.categoria,
  });

  int idSite;
  String? nombre;
  String? direccion;
  String? foto;
  int? valoracion;
  String? contacto;
  String? rangoPrecio;
  int? idPoint;
  int? idCategoria;
  Point? point;
  Categoria? categoria;

  factory Site.fromJson(Map<String, dynamic> json) => Site(
        idSite: json["idSite"],
        nombre: json["nombre"],
        direccion: json["direccion"],
        foto: json["foto"],
        valoracion: json["valoracion"],
        contacto: json["contacto"],
        rangoPrecio: json["rangoPrecio"],
        idPoint: json["idPoint"],
        idCategoria: json["idCategoria"],
        point: Point.fromJson(json["point"]),
        categoria: Categoria.fromJson(json["categoria"]),
      );

  Map<String, dynamic> toJson() => {
        "idSite": idSite,
        "nombre": nombre,
        "direccion": direccion,
        "foto": foto,
        "valoracion": valoracion,
        "contacto": contacto,
        "rangoPrecio": rangoPrecio,
        "idPoint": idPoint,
        "idCategoria": idCategoria,
        "point": point?.toJson(),
        "categoria": categoria?.toJson(),
      };
}

class Categoria {
  Categoria({
    required this.idCategoria,
    this.nombre,
    this.enable,
  });

  int idCategoria;
  String? nombre;
  int? enable;

  factory Categoria.fromJson(Map<String, dynamic> json) => Categoria(
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

class Point {
  Point({
    required this.idPoint,
    this.name,
    this.location,
  });

  int idPoint;
  String? name;
  String? location;

  factory Point.fromJson(Map<String, dynamic> json) => Point(
        idPoint: json["idPoint"],
        name: json["name"],
        location: json["location"],
      );

  Map<String, dynamic> toJson() => {
        "idPoint": idPoint,
        "name": name,
        "location": location,
      };
}
