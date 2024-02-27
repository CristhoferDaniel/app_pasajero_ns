// To parse this JSON data, do
//
//     final firebaseLocations = firebaseLocationsFromJson(jsonString);
/* 
import 'dart:convert';

FirebaseLocations firebaseLocationsFromJson(String str) =>
    FirebaseLocations.fromJson(json.decode(str));

String firebaseLocationsToJson(FirebaseLocations data) =>
    json.encode(data.toJson());

class FirebaseLocations {
  FirebaseLocations({
    required this.fcmToken,
    required this.status,
  });

  String fcmToken;
  String status;

  factory FirebaseLocations.fromJson(Map<String, dynamic> json) =>
      FirebaseLocations(
        fcmToken: json["fcmToken"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "fcmToken": fcmToken,
        "status": status,
      };
}
*/