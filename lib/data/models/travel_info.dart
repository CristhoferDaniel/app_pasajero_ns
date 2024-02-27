// To parse this JSON data, do
//
//     final travelInfo = travelInfoFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

TravelInfo travelInfoFromJson(String str) =>
    TravelInfo.fromJson(json.decode(str));

String travelInfoToJson(TravelInfo data) => json.encode(data.toJson());

class TravelInfo {
  TravelInfo(
      {required this.hash,
      required this.uidClient,
      required this.idSolicitud,
      required this.idServicio,
      required this.status,
      this.uidDriver,
      this.idConductor,
      this.fcmClientToken,
      required this.codeValidated,
      this.estimatedDistance = 0,
      this.startDate,
      this.finishDate,
      required this.rejectedBy,
      required this.code,
      required this.costo,
      required this.idCupon,
      required this.descuento,
      required this.total});

  int hash;
  bool codeValidated;
  int estimatedDistance;
  String? fcmClientToken;
  DateTime? finishDate;
  int? idConductor;
  int idServicio;
  int idSolicitud;
  // falta secureCode o PIN
  DateTime? startDate;
  TravelStatus status;
  String uidClient;
  String? uidDriver;
  List<String> rejectedBy;
  int code;
  double costo;
  int idCupon;
  double descuento;
  double total;

  factory TravelInfo.fromJson(Map<String, dynamic> json) {
    String jst = json["status"] ?? 'unknown';

    return TravelInfo(
        hash: json["hash"],
        codeValidated: json["codeValidated"],
        estimatedDistance:
            json["estimatedDistance"] != null ? json['estimatedDistance'] : 0,
        fcmClientToken: json["fcmClientToken"],
        finishDate: json["finishDate"] != null
            ? (json['finishDate'] as Timestamp).toDate()
            : null,
        idConductor: json["idConductor"],
        idServicio: json["idServicio"],
        idSolicitud: json["idSolicitud"],
        // falta secureCode o PIN
        startDate: json["startDate"] != null
            ? (json['startDate'] as Timestamp).toDate()
            : null,
        status: statusValues.map[jst] ?? TravelStatus.UNKNOWN,
        uidClient: json["uidClient"],
        uidDriver: json["uidDriver"],
        rejectedBy: List<String>.from(json["rejectedBy"].map((x) => x)),
        code: json["code"],
        costo: json["costo"],
        idCupon: json["idCupon"],
        descuento: json["descuento"],
        total: json["total"]);
  }

  Map<String, dynamic> toJson() => {
        "hash": hash,
        "codeValidated": codeValidated,
        "estimatedDistance": estimatedDistance,
        "fcmClientToken": fcmClientToken,
        "finishDate":
            finishDate != null ? Timestamp.fromDate(finishDate!) : null,
        "idConductor": idConductor,
        "idServicio": idServicio,
        "idSolicitud": idSolicitud,
        "startDate": startDate != null ? Timestamp.fromDate(startDate!) : null,
        "status": statusValues.reverse?[status] ?? 'unknown',
        "uidClient": uidClient,
        "uidDriver": uidDriver,
        "rejectedBy": List<dynamic>.from(rejectedBy.map((x) => x)),
        "code": code,
        "costo": costo,
        "idCupon": idCupon,
        "descuento": descuento,
        "total": total
      };
}

enum TravelStatus {
  UNKNOWN,
  CREATED,
  CANCELED,
  ACCEPTED,
  REJECTED,
  ARRIVED,
  STARTED,
  FINISHED
}

final statusValues = EnumValues({
  "unknown": TravelStatus.UNKNOWN,
  "created": TravelStatus.CREATED, // Cuando el pasajero creó la solicitud
  "canceled": TravelStatus.CANCELED, // Cuando el pasajero canceló la solicitud
  "accepted": TravelStatus.ACCEPTED, // Cuando el conductor aceptó el viaje
  "rejected": TravelStatus.REJECTED, // Cuando el conductor rechazó el viaje
  "arrived": TravelStatus.ARRIVED, // Cuando el conductor avisa que llegó
  "started": TravelStatus.STARTED, // Cuando el conductor inicia el viaje
  "finished": TravelStatus.FINISHED,
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String>? get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
