import 'dart:convert';

class LoginRequest {
  LoginRequest({this.email, this.password, this.type = '1', this.token});

  String? email;
  String? password;
  String? token;
  String? type;

  factory LoginRequest.fromRawJson(String str) => LoginRequest.fromJson(
        json.decode(str),
      );

  String toRawJson() => json.encode(
        toJson(),
      );

  factory LoginRequest.fromJson(Map<String, dynamic> json) => LoginRequest(
        email: json["email"],
        password: json["password"],
        token: json["token"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
        "token": token,
        "type": type,
      };
}
