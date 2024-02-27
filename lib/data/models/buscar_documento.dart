// To parse this JSON data, do
//
//     final clienteCreate = clienteCreateFromJson(jsonString);

import 'dart:convert';


// To parse this JSON data, do
//

DocumentoDto DocumentoDtoFromJson(String str) =>
    DocumentoDto.fromJson(json.decode(str));

String DocumentoDtoToJson(DocumentoDto data) => json.encode(data.toJson());

class DocumentoDto {
  DocumentoDto({
    required this.dni,
    required this.nombres,
    required this.apellidoPaterno,
    required this.apellidoMaterno,
    required this.codVerifica,
  });

  late final String dni;
  final String nombres;
  final String apellidoPaterno;
  final String apellidoMaterno;
  final String codVerifica;

  DocumentoDto copyWith({
    String? dni,
    String? nombres,
    String? apellidoPaterno,
    String? apellidoMaterno,
    String? codVerifica,
  }) =>
      DocumentoDto(
        dni: dni ?? this.dni,
        nombres: nombres ?? this.nombres,
        apellidoPaterno: apellidoPaterno ?? this.apellidoPaterno,
        apellidoMaterno: apellidoMaterno ?? this.apellidoMaterno,
        codVerifica: codVerifica ?? this.codVerifica,
      );

  factory DocumentoDto.fromJson(Map<String, dynamic> json) => DocumentoDto(
        dni: json["dni"],
        nombres: json["nombres"],
        apellidoPaterno: json["apellidoPaterno"],
        apellidoMaterno: json["apellidoMaterno"],
        codVerifica: json["codVerifica"],
      );

  Map<String, dynamic> toJson() => {
        "dni": dni,
        "nombres": nombres,
        "apellidoPaterno": apellidoPaterno,
        "apellidoMaterno": apellidoMaterno,
        "codVerifica": codVerifica,
      };
}

// To parse this JSON data, do
//
//     final DocumentoListResponse = DocumentoListResponseFromJson(jsonString);

DocumentoListResponse DocumentoListResponseFromJson(String str) =>
    DocumentoListResponse.fromJson(json.decode(str));

String DocumentoListResponseToJson(DocumentoListResponse data) =>
    json.encode(data.toJson());

class DocumentoListResponse {
  DocumentoListResponse({
    required this.success,
    required this.data,
  });

  bool success;
  final List<DocumentoDto> data;

  factory DocumentoListResponse.fromJson(Map<String, dynamic> json) =>
      DocumentoListResponse(
        success: json["success"],
        data: List<DocumentoDto>.from(
            json["data"].map((x) => DocumentoDto.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}
