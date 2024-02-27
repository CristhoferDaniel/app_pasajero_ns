// To parse this JSON data, do
//
//     final googlePlaceResponse = googlePlaceResponseFromJson(jsonString);

class GooglePlaceResponse {
  GooglePlaceResponse({
    this.result,
    required this.status,
  });

  final Result? result;
  final String status;

  factory GooglePlaceResponse.fromJson(Map<String, dynamic> json) =>
      GooglePlaceResponse(
        result: json["result"] == null ? null : Result.fromJson(json["result"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "result": result?.toJson(),
        "status": status,
      };
}

class Result {
  Result({
    required this.geometry,
    required this.name,
  });

  final Geometry geometry;
  final String name;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        geometry: Geometry.fromJson(json["geometry"]),
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "geometry": geometry.toJson(),
        "name": name,
      };
}

class Geometry {
  Geometry({
    required this.location,
  });

  final Location location;

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        location: Location.fromJson(json["location"]),
      );

  Map<String, dynamic> toJson() => {
        "location": location.toJson(),
      };
}

class Location {
  Location({
    required this.lat,
    required this.lng,
  });

  final double lat;
  final double lng;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        lat: json["lat"].toDouble(),
        lng: json["lng"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "lat": lat,
        "lng": lng,
      };
}
