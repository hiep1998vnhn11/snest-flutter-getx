import 'dart:convert';

class LoginResponse {
  LoginResponse({
    required this.token,
  });

  String token;

  factory LoginResponse.fromRawJson(String str) =>
      LoginResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        token: json["access_token"],
      );

  Map<String, dynamic> toJson() => {
        "access_token": token,
      };
}