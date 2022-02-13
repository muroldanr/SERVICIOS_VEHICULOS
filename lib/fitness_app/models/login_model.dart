import 'dart:convert';

class LoginRequestModel {
  String? username;
  String? password;

  LoginRequestModel({this.username, this.password});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'username': username,
      'password': password,
    };

    return map;
  }
}

LoginResponseModel loginResponseFromJson(String str) =>
    LoginResponseModel.fromJson(json.decode(str));

class LoginResponseModel {
  final String? authToken;
  final String? refreshToken;
  final String? refreshTokenExpiry;

  LoginResponseModel(
      {this.authToken, this.refreshToken, this.refreshTokenExpiry});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      authToken: json['AuthToken'],
      refreshToken: json['RefreshToken'],
      refreshTokenExpiry: json['RefreshTokenExpiry'],
    );
  }
}

/*
  class LoginResponsetModel {}

class LoginResponseModel {
  final String token;
  final String error;

  LoginResponseModel({this.token, this.error});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      token: json["token"] != null ? json["token"] : "",
      error: json["error"] != null ? json["error"] : "",
    );
  }
}
   */
