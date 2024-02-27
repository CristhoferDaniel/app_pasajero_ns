import 'dart:convert';

class LoginParams {
  LoginParams({
    required this.idToken,
    required this.typeOperator
  });

  final String idToken;
  final String typeOperator;

  factory LoginParams.fromJson(Map<String, dynamic> json) =>
      LoginParams(
        idToken: json["idToken"],
        typeOperator: json["typeOperator"],
      );

  Map<String, dynamic> toJson() => {
        "idToken": idToken,
        "typeOperator": typeOperator
      };
}

class LoginResponse {
  LoginResponse({
    required this.token
  });

  String token;

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      LoginResponse(
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
      };
}

// To parse this JSON data, do
//

LoginDto LoginDtoFromJson(String str) =>
    LoginDto.fromJson(json.decode(str));

String LoginDtoToJson(LoginDto data) => json.encode(data.toJson());

class LoginDto {
  LoginDto({
    required this.idToken,
    required this.typeOperator,
  });

  late final String idToken;
  late final String typeOperator;

  LoginDto copyWith({
    String? idToken,
    String? typeOperator
  }) =>
      LoginDto(
        idToken: idToken ?? this.idToken,
        typeOperator: typeOperator ?? this.typeOperator
      );

  factory LoginDto.fromJson(Map<String, dynamic> json) => LoginDto(
        idToken: json["idToken"],
        typeOperator: json["typeOperator"],
      );

  Map<String, dynamic> toJson() => {
        "idToken": idToken,
        "typeOperator": typeOperator
      };
}
