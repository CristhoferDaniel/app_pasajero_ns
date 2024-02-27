// To parse this JSON data, do
//
//     final vehiculoResponse = vehiculoResponseFromJson(jsonString);

import 'dart:convert';

VehiculoResponse vehiculoResponseFromJson(String str) =>
    VehiculoResponse.fromJson(json.decode(str));

String vehiculoResponseToJson(VehiculoResponse data) =>
    json.encode(data.toJson());

class VehiculoResponse {
  VehiculoResponse({
    required this.success,
    required this.data,
  });

  final bool success;
  final Vehiculo data;

  factory VehiculoResponse.fromJson(Map<String, dynamic> json) =>
      VehiculoResponse(
        success: json["success"],
        data: Vehiculo.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
      };
}

class Vehiculo {
  Vehiculo({
    required this.idVehiculo,
    required this.idConductor,
    required this.idMarca,
    required this.placa,
    required this.asientos,
    required this.maletas,
    required this.foto,
    required this.idModelo,
    required this.urlLicenciaConducir,
    required this.valLicenciaConducir,
    required this.urlSoat,
    required this.valSoat,
    required this.urlRevisionTecnica,
    required this.valRevisionTecnica,
    required this.urlResolucionTaxi,
    required this.valResolucionTaxi,
    required this.urlTarjetaCirculacion,
    required this.valTarjetaCirculacion,
    required this.observacion,
    this.idColor,
  });

  final int idVehiculo;
  final int idConductor;
  final int idMarca;
  final String placa;
  final int asientos;
  final int maletas;
  final String foto;
  final int idModelo;
  final String urlLicenciaConducir;
  final bool valLicenciaConducir;
  final String urlSoat;
  final bool valSoat;
  final String urlRevisionTecnica;
  final bool valRevisionTecnica;
  final String urlResolucionTaxi;
  final bool valResolucionTaxi;
  final String urlTarjetaCirculacion;
  final bool valTarjetaCirculacion;
  final String observacion;
  final int? idColor;

  factory Vehiculo.fromJson(Map<String, dynamic> json) => Vehiculo(
        idVehiculo: json["idVehiculo"],
        idConductor: json["idConductor"],
        idMarca: json["idMarca"],
        placa: json["placa"],
        asientos: json["asientos"],
        maletas: json["maletas"],
        foto: json["foto"],
        idModelo: json["idModelo"],
        urlLicenciaConducir: json["urlLicenciaConducir"],
        valLicenciaConducir: json["valLicenciaConducir"],
        urlSoat: json["urlSoat"],
        valSoat: json["valSoat"],
        urlRevisionTecnica: json["urlRevisionTecnica"],
        valRevisionTecnica: json["valRevisionTecnica"],
        urlResolucionTaxi: json["urlResolucionTaxi"],
        valResolucionTaxi: json["valResolucionTaxi"],
        urlTarjetaCirculacion: json["urlTarjetaCirculacion"],
        valTarjetaCirculacion: json["valTarjetaCirculacion"],
        observacion: json["observacion"],
        idColor: json["idColor"],
      );

  Map<String, dynamic> toJson() => {
        "idVehiculo": idVehiculo,
        "idConductor": idConductor,
        "idMarca": idMarca,
        "placa": placa,
        "asientos": asientos,
        "maletas": maletas,
        "foto": foto,
        "idModelo": idModelo,
        "urlLicenciaConducir": urlLicenciaConducir,
        "valLicenciaConducir": valLicenciaConducir,
        "urlSoat": urlSoat,
        "valSoat": valSoat,
        "urlRevisionTecnica": urlRevisionTecnica,
        "valRevisionTecnica": valRevisionTecnica,
        "urlResolucionTaxi": urlResolucionTaxi,
        "valResolucionTaxi": valResolucionTaxi,
        "urlTarjetaCirculacion": urlTarjetaCirculacion,
        "valTarjetaCirculacion": valTarjetaCirculacion,
        "observacion": observacion,
        "idColor": idColor,
      };
}
