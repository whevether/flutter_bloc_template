import 'dart:convert';

import 'package:flutter_bloc_template/model/base_model.dart';

class UserModel {
  String id;
  String username;
  String? avatar;
  int? age;
  int? sex;
  UserModel({
    required this.id,
    required this.username,
    this.avatar,
    this.age,
    this.sex,
  });
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: asT<String>(json['id'])!,
    username: asT<String>(json['username'])!,
    avatar: asT<String>(json['avatar']),
    age: asT<int>(json['age']),
    sex: asT<int>(json['sex']),
  );
  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'username': username,
    'avatar': avatar,
    'age': age,
    'sex': sex,
  };
}
