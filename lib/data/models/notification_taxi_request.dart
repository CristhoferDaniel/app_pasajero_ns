// To parse this JSON data, do
//
//     final notificationTaxiRequest = notificationTaxiRequestFromJson(jsonString);

import 'dart:convert';

NotificationTaxiRequest notificationTaxiRequestFromJson(String str) =>
    NotificationTaxiRequest.fromJson(json.decode(str));

String notificationTaxiRequestToJson(NotificationTaxiRequest data) =>
    json.encode(data.toJson());

class NotificationTaxiRequest {
  NotificationTaxiRequest({
    required this.hash,
    required this.type,
    required this.idServicio,
    required this.idSolicitud,
    required this.origenName,
    required this.destinoName,
    required this.origenCoords,
    required this.destinoCoords,
    required this.uidClient,
  });

  int hash;
  String type;
  int idServicio;
  int idSolicitud;
  String origenName;
  String destinoName;
  String origenCoords;
  String destinoCoords;
  String uidClient;

  factory NotificationTaxiRequest.fromJson(Map<String, dynamic> json) =>
      NotificationTaxiRequest(
        hash: int.parse(json["hash"]),
        type: json["type"],
        idServicio: int.parse(json["idServicio"]),
        idSolicitud: int.parse(json["idSolicitud"]),
        origenName: json["origenName"],
        destinoName: json["destinoName"],
        origenCoords: json["origenCoords"],
        destinoCoords: json["destinoCoords"],
        uidClient: json["uidClient"],
      );

  Map<String, dynamic> toJson() => {
        "hash": hash,
        "type": type,
        "idServicio": idServicio,
        "idSolicitud": idSolicitud,
        "origenName": origenName,
        "destinoName": destinoName,
        "origenCoords": origenCoords,
        "destinoCoords": destinoCoords,
        "uidClient": uidClient,
      };
}
