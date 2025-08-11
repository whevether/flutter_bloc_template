import 'dart:convert';

import 'package:flutter_bloc_template/model/base_model.dart';

class LoginResultModel {
  LoginResultModel({
    this.token,
    this.tokenType,
    this.refreshToken,
    this.userId,
  });

  factory LoginResultModel.fromJson(Map<String, dynamic> json) =>
      LoginResultModel(
        token: asT<String>(json['token']),
        tokenType: asT<String>(json['tokenType']),
        refreshToken: asT<String>(json['refreshToken']),
        userId: asT<String>(json['userId']),
      );
  String? token;
  String? tokenType;
  String? refreshToken;
  String? userId;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'token': token,
    'tokenType': tokenType,
    'refreshToken': refreshToken,
    'userId': userId,
  };
}
