// To parse this JSON data, do
//
//     final conceptoSimulacionResponse = conceptoSimulacionResponseFromJson(jsonString);

import 'dart:convert';

ConceptoSimulacionResponse conceptoSimulacionResponseFromJson(String str) =>
    ConceptoSimulacionResponse.fromJson(json.decode(str));

String conceptoSimulacionResponseToJson(ConceptoSimulacionResponse data) =>
    json.encode(data.toJson());

class ConceptoSimulacionResponse {
  ConceptoSimulacionResponse({
    required this.success,
    required this.data,
  });

  bool success;
  SimulacionResponseDto data;

  factory ConceptoSimulacionResponse.fromJson(Map<String, dynamic> json) =>
      ConceptoSimulacionResponse(
        success: json["success"],
        data: SimulacionResponseDto.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
      };
}

class SimulacionResponseDto {
  SimulacionResponseDto({
    required this.precioCalculado,
  });

  String precioCalculado;

  factory SimulacionResponseDto.fromJson(Map<String, dynamic> json) =>
      SimulacionResponseDto(
        precioCalculado: json["precioCalculado"],
      );

  Map<String, dynamic> toJson() => {
        "precioCalculado": precioCalculado,
      };
}

// To parse this JSON data, do
//
//     final conceptoSimulacionCliente = conceptoSimulacionClienteFromJson(jsonString);

ConceptoSimulacionCliente conceptoSimulacionClienteFromJson(String str) =>
    ConceptoSimulacionCliente.fromJson(json.decode(str));

String conceptoSimulacionClienteToJson(ConceptoSimulacionCliente data) =>
    json.encode(data.toJson());

class ConceptoSimulacionCliente {
  ConceptoSimulacionCliente({
    required this.success,
    required this.data,
  });

  final bool success;
  final CSCData data;

  factory ConceptoSimulacionCliente.fromJson(Map<String, dynamic> json) =>
      ConceptoSimulacionCliente(
        success: json["success"],
        data: CSCData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
      };
}

class CSCData {
  CSCData({
    required this.data,
  });

  final List<SCTarifa> data;

  factory CSCData.fromJson(Map<String, dynamic> json) => CSCData(
        data:
            List<SCTarifa>.from(json["data"].map((x) => SCTarifa.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class SCTarifa {
  SCTarifa({
    required this.idTipoVehiculo,
    required this.tipoVehiculo,
    required this.precioCalculado,
  });

  final int idTipoVehiculo;
  final String tipoVehiculo;
  final String precioCalculado;

  factory SCTarifa.fromJson(Map<String, dynamic> json) => SCTarifa(
        idTipoVehiculo: json["idTipoVehiculo"],
        tipoVehiculo: json["tipoVehiculo"],
        precioCalculado: json["precioCalculado"],
      );

  Map<String, dynamic> toJson() => {
        "idTipoVehiculo": idTipoVehiculo,
        "tipoVehiculo": tipoVehiculo,
        "precioCalculado": precioCalculado,
      };
}
