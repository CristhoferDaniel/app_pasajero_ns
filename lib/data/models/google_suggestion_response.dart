// To parse this JSON data, do
//
//     final googleSuggestionResponse = googleSuggestionResponseFromJson(jsonString);

class GoogleSuggestionResponse {
  GoogleSuggestionResponse({
    required this.predictions,
    required this.status,
  });

  final List<Prediction> predictions;
  final String status;

  factory GoogleSuggestionResponse.fromJson(Map<String, dynamic> json) =>
      GoogleSuggestionResponse(
        predictions: List<Prediction>.from(
            json["predictions"].map((x) => Prediction.fromJson(x))),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "predictions": List<dynamic>.from(predictions.map((x) => x.toJson())),
        "status": status,
      };
}

class Prediction {
  Prediction({
    required this.description,
    required this.placeId,
    required this.structuredFormatting,
    required this.types,
    this.isFavorite,
  });

  final String description;
  final String placeId;
  final StructuredFormatting structuredFormatting;
  final List<String> types;
  final bool? isFavorite;

  Prediction copyWith({
    String? description,
    String? placeId,
    StructuredFormatting? structuredFormatting,
    List<String>? types,
    bool? isFavorite,
  }) =>
      Prediction(
        description: description ?? this.description,
        placeId: placeId ?? this.placeId,
        structuredFormatting: structuredFormatting ?? this.structuredFormatting,
        types: types ?? this.types,
        isFavorite: isFavorite ?? this.isFavorite,
      );

  factory Prediction.fromJson(Map<String, dynamic> json) => Prediction(
        description: json["description"],
        placeId: json["place_id"],
        structuredFormatting:
            StructuredFormatting.fromJson(json["structured_formatting"]),
        types: List<String>.from(json["types"].map((x) => x)),
        isFavorite: json["isFavorite"],
      );

  Map<String, dynamic> toJson() => {
        "description": description,
        "place_id": placeId,
        "structured_formatting": structuredFormatting.toJson(),
        "types": List<dynamic>.from(types.map((x) => x)),
        "isFavorite": isFavorite,
      };
}

class StructuredFormatting {
  StructuredFormatting({
    required this.mainText,
    required this.mainTextMatchedSubstrings,
    required this.secondaryText,
  });

  final String mainText;
  final List<MainTextMatchedSubstring> mainTextMatchedSubstrings;
  final String secondaryText;

  factory StructuredFormatting.fromJson(Map<String, dynamic> json) =>
      StructuredFormatting(
        mainText: json["main_text"],
        mainTextMatchedSubstrings: List<MainTextMatchedSubstring>.from(
            json["main_text_matched_substrings"]
                .map((x) => MainTextMatchedSubstring.fromJson(x))),
        secondaryText: json["secondary_text"],
      );

  Map<String, dynamic> toJson() => {
        "main_text": mainText,
        "main_text_matched_substrings": List<dynamic>.from(
            mainTextMatchedSubstrings.map((x) => x.toJson())),
        "secondary_text": secondaryText,
      };
}

class MainTextMatchedSubstring {
  MainTextMatchedSubstring({
    required this.length,
    required this.offset,
  });

  final int length;
  final int offset;

  factory MainTextMatchedSubstring.fromJson(Map<String, dynamic> json) =>
      MainTextMatchedSubstring(
        length: json["length"],
        offset: json["offset"],
      );

  Map<String, dynamic> toJson() => {
        "length": length,
        "offset": offset,
      };
}
