import 'dart:convert';

import 'package:flutter_bloc_template/model/base_model.dart';

class UserModel {
  String userId;
  String userName;
  String avatarUrl;
  int age;
  int sex;
  UserModel({
    required this.userId,
    required this.userName,
    required this.avatarUrl,
    required this.age,
    required this.sex,
  });
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    userId: asT<String>(json['userId'])!,
    userName: asT<String>(json['userName'])!,
    avatarUrl: asT<String>(json['avatarUrl'])!,
    age: asT<int>(json['age'])!,
    sex: asT<int>(json['sex'])!,
  );
  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'userId': userId,
    'userName': userName,
    'avatarUrl': avatarUrl,
    'age': age,
    'sex': sex,
  };
}
