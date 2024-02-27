// To parse this JSON data, do
//
//     final googleDrivingResponse = googleDrivingResponseFromJson(jsonString);

// GoogleDrivingResponse googleDrivingResponseFromJson(String str) => GoogleDrivingResponse.fromJson(json.decode(str));

// String googleDrivingResponseToJson(GoogleDrivingResponse data) => json.encode(data.toJson());

class GoogleDrivingResponse {
  GoogleDrivingResponse({
    required this.geocodedWaypoints,
    required this.routes,
    required this.status,
  });

  final List<GeocodedWaypoint> geocodedWaypoints;
  final List<Route> routes;
  final String status;

  factory GoogleDrivingResponse.fromJson(Map<String, dynamic> json) =>
      GoogleDrivingResponse(
        geocodedWaypoints: List<GeocodedWaypoint>.from(
            json["geocoded_waypoints"]
                .map((x) => GeocodedWaypoint.fromJson(x))),
        routes: List<Route>.from(json["routes"].map((x) => Route.fromJson(x))),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "geocoded_waypoints":
            List<dynamic>.from(geocodedWaypoints.map((x) => x.toJson())),
        "routes": List<dynamic>.from(routes.map((x) => x.toJson())),
        "status": status,
      };
}

class GeocodedWaypoint {
  GeocodedWaypoint({
    required this.geocoderStatus,
    required this.placeId,
    required this.types,
  });

  final String geocoderStatus;
  final String placeId;
  final List<String> types;

  factory GeocodedWaypoint.fromJson(Map<String, dynamic> json) =>
      GeocodedWaypoint(
        geocoderStatus: json["geocoder_status"],
        placeId: json["place_id"],
        types: List<String>.from(json["types"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "geocoder_status": geocoderStatus,
        "place_id": placeId,
        "types": List<dynamic>.from(types.map((x) => x)),
      };
}

class Route {
  Route({
    required this.bounds,
    required this.copyrights,
    required this.legs,
    required this.overviewPolyline,
    required this.summary,
    required this.warnings,
    required this.waypointOrder,
  });

  final Bounds bounds;
  final String copyrights;
  final List<Leg> legs;
  final OverviewPolyline overviewPolyline;
  final String summary;
  final List<dynamic> warnings;
  final List<dynamic> waypointOrder;

  factory Route.fromJson(Map<String, dynamic> json) => Route(
        bounds: Bounds.fromJson(json["bounds"]),
        copyrights: json["copyrights"],
        legs: List<Leg>.from(json["legs"].map((x) => Leg.fromJson(x))),
        overviewPolyline: OverviewPolyline.fromJson(json["overview_polyline"]),
        summary: json["summary"],
        warnings: List<dynamic>.from(json["warnings"].map((x) => x)),
        waypointOrder: List<dynamic>.from(json["waypoint_order"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "bounds": bounds.toJson(),
        "copyrights": copyrights,
        "legs": List<dynamic>.from(legs.map((x) => x.toJson())),
        "overview_polyline": overviewPolyline.toJson(),
        "summary": summary,
        "warnings": List<dynamic>.from(warnings.map((x) => x)),
        "waypoint_order": List<dynamic>.from(waypointOrder.map((x) => x)),
      };
}

class Bounds {
  Bounds({
    required this.northeast,
    required this.southwest,
  });

  final GoogleLatLng northeast;
  final GoogleLatLng southwest;

  factory Bounds.fromJson(Map<String, dynamic> json) => Bounds(
        northeast: GoogleLatLng.fromJson(json["northeast"]),
        southwest: GoogleLatLng.fromJson(json["southwest"]),
      );

  Map<String, dynamic> toJson() => {
        "northeast": northeast.toJson(),
        "southwest": southwest.toJson(),
      };
}

class GoogleLatLng {
  GoogleLatLng({
    required this.lat,
    required this.lng,
  });

  final double lat;
  final double lng;

  factory GoogleLatLng.fromJson(Map<String, dynamic> json) => GoogleLatLng(
        lat: json["lat"].toDouble(),
        lng: json["lng"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "lat": lat,
        "lng": lng,
      };
}

class Leg {
  Leg({
    required this.distance,
    required this.duration,
    required this.endAddress,
    required this.endLocation,
    required this.startAddress,
    required this.startLocation,
    required this.trafficSpeedEntry,
    required this.viaWaypoint,
  });

  final Distance distance;
  final Distance duration;
  final String endAddress;
  final GoogleLatLng endLocation;
  final String startAddress;
  final GoogleLatLng startLocation;
  final List<dynamic> trafficSpeedEntry;
  final List<dynamic> viaWaypoint;

  factory Leg.fromJson(Map<String, dynamic> json) => Leg(
        distance: Distance.fromJson(json["distance"]),
        duration: Distance.fromJson(json["duration"]),
        endAddress: json["end_address"],
        endLocation: GoogleLatLng.fromJson(json["end_location"]),
        startAddress: json["start_address"],
        startLocation: GoogleLatLng.fromJson(json["start_location"]),
        trafficSpeedEntry:
            List<dynamic>.from(json["traffic_speed_entry"].map((x) => x)),
        viaWaypoint: List<dynamic>.from(json["via_waypoint"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "distance": distance.toJson(),
        "duration": duration.toJson(),
        "end_address": endAddress,
        "end_location": endLocation.toJson(),
        "start_address": startAddress,
        "start_location": startLocation.toJson(),
        "traffic_speed_entry":
            List<dynamic>.from(trafficSpeedEntry.map((x) => x)),
        "via_waypoint": List<dynamic>.from(viaWaypoint.map((x) => x)),
      };
}

class Distance {
  Distance({
    required this.text,
    required this.value,
  });

  final String text;
  final int value;

  factory Distance.fromJson(Map<String, dynamic> json) => Distance(
        text: json["text"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "value": value,
      };
}

class OverviewPolyline {
  OverviewPolyline({
    required this.points,
  });

  final String points;

  factory OverviewPolyline.fromJson(Map<String, dynamic> json) =>
      OverviewPolyline(
        points: json["points"],
      );

  Map<String, dynamic> toJson() => {
        "points": points,
      };
}
