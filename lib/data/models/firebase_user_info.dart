// To parse this JSON data, do
//
//     final firebaseUserInfo = firebaseUserInfoFromJson(jsonString);

import 'dart:convert';

FirebaseUserInfo firebaseUserInfoFromJson(String str) =>
    FirebaseUserInfo.fromJson(json.decode(str));

String firebaseUserInfoToJson(FirebaseUserInfo data) =>
    json.encode(data.toJson());

class FirebaseUserInfo {
  FirebaseUserInfo({
    required this.uid,
    this.email,
    required this.emailVerified,
    required this.metadata,
    photoURL,
    phoneNumber,
    required this.providerData,
  });

  String uid;
  String? email;
  bool emailVerified;
  String? photoURL;
  String? phoneNumber;
  Metadata metadata;

  List<ProviderData> providerData;

  factory FirebaseUserInfo.fromJson(Map<String, dynamic> json) =>
      FirebaseUserInfo(
        uid: json["uid"],
        email: json["email"],
        emailVerified: json["emailVerified"],
        photoURL: json["photoURL"],
        phoneNumber: json["phoneNumber"],
        metadata: Metadata.fromJson(json["metadata"]),
        providerData: List<ProviderData>.from(
            json["providerData"].map((x) => ProviderData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "email": email,
        "emailVerified": emailVerified,
        "photoURL": photoURL,
        "phoneNumber": phoneNumber,
        "metadata": metadata.toJson(),
        "providerData": List<dynamic>.from(providerData.map((x) => x.toJson())),
      };
}

class Metadata {
  Metadata({
    this.lastSignInTime,
    required this.creationTime,
  });

  String? lastSignInTime;
  String creationTime;

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
        lastSignInTime: json["lastSignInTime"],
        creationTime: json["creationTime"],
      );

  Map<String, dynamic> toJson() => {
        "lastSignInTime": lastSignInTime,
        "creationTime": creationTime,
      };
}

class ProviderData {
  ProviderData({
    required this.uid,
    this.email,
    required this.providerId,
    this.phoneNumber,
  });

  String uid;
  String? email;
  ProviderId providerId;
  String? phoneNumber;

  factory ProviderData.fromJson(Map<String, dynamic> json) {
    String jpi = json["providerId"] ?? 'other';

    return ProviderData(
      uid: json["uid"],
      email: json["email"],
      providerId: providerIdValues.map[jpi] ?? ProviderId.OTHER,
      phoneNumber: json["phoneNumber"],
    );
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "email": email,
        "providerId": providerIdValues.reverse?[providerId] ?? 'other',
        "phoneNumber": phoneNumber,
      };
}

enum ProviderId { OTHER, FACEBOOK_COM, GOOGLE_COM, PASSWORD, PHONE }

final providerIdValues = EnumValues({
  "other": ProviderId.OTHER,
  "facebook.com": ProviderId.FACEBOOK_COM,
  "google.com": ProviderId.GOOGLE_COM,
  "password": ProviderId.PASSWORD,
  "phone": ProviderId.PHONE,
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
