// To parse this JSON data, do
//
//     final repositorioResponse = repositorioResponseFromJson(jsonString);

import 'dart:convert';

RepositorioResponse repositorioResponseFromJson(String str) =>
    RepositorioResponse.fromJson(json.decode(str));

String repositorioResponseToJson(RepositorioResponse data) =>
    json.encode(data.toJson());

class RepositorioResponse {
  RepositorioResponse({
    required this.url,
  });

  final String url;

  factory RepositorioResponse.fromJson(Map<String, dynamic> json) =>
      RepositorioResponse(
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
      };
}
