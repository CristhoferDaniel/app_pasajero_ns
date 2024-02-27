// To parse this JSON data, do
//
//     final favorito = favoritoFromJson(jsonString);

import 'dart:convert';

List<Favorito> favoritoFromJson(String str) =>
    List<Favorito>.from(json.decode(str).map((x) => Favorito.fromJson(x)));

String favoritoToJson(List<Favorito> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Favorito {
  Favorito({
    this.name,
    this.rating,
    this.description,
    this.portadaImg,
    this.logoImg,
  });

  String? name;
  double? rating;
  String? description;
  String? portadaImg;
  String? logoImg;

  factory Favorito.fromJson(Map<String, dynamic> json) => Favorito(
        name: json["name"],
        rating: json["rating"],
        description: json["description"],
        portadaImg: json["portada_img"],
        logoImg: json["logo_img"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "rating": rating,
        "description": description,
        "portada_img": portadaImg,
        "logo_img": logoImg,
      };
}
