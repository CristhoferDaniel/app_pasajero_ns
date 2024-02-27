// To parse this JSON data, do
//
//     final tipoDocumentoResponse = tipoDocumentoResponseFromJson(jsonString);

import 'dart:convert';

TipoDocumentoResponse tipoDocumentoResponseFromJson(String str) =>
    TipoDocumentoResponse.fromJson(json.decode(str));

String tipoDocumentoResponseToJson(TipoDocumentoResponse data) =>
    json.encode(data.toJson());

class TipoDocumentoResponse {
  TipoDocumentoResponse({
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
  List<TipoDocumento> content;

  factory TipoDocumentoResponse.fromJson(Map<String, dynamic> json) =>
      TipoDocumentoResponse(
        pageNumber: json["pageNumber"],
        pageSize: json["pageSize"],
        numberOfElements: json["numberOfElements"],
        totalElements: json["totalElements"],
        content: List<TipoDocumento>.from(
            json["content"].map((x) => TipoDocumento.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "numberOfElements": numberOfElements,
        "totalElements": totalElements,
        "content": List<dynamic>.from(content.map((x) => x.toJson())),
      };
}

class TipoDocumento {
  TipoDocumento({
    required this.idTipoDocumento,
    required this.nombre,
  });

  int idTipoDocumento;
  String nombre;

  factory TipoDocumento.fromJson(Map<String, dynamic> json) => TipoDocumento(
        idTipoDocumento: json["idTipoDocumento"],
        nombre: json["nombre"],
      );

  Map<String, dynamic> toJson() => {
        "idTipoDocumento": idTipoDocumento,
        "nombre": nombre,
      };
}
