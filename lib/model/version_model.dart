import 'dart:convert';

import 'package:flutter_bloc_template/model/base_model.dart';

class VersionModel {
  VersionModel({
    this.wrapName,
    required this.osType,
    required this.versionNo,
    required this.versionName,
    required this.content,
    required this.downUrl,
    this.wrapSize,
    required this.updateStatus,
    required this.updateType,
    required this.createTime,
  });

  factory VersionModel.fromJson(Map<String, dynamic> json) => VersionModel(
    wrapName: asT<String>(json['wrapName']),
    osType: asT<int>(json['osType'])!,
    versionNo: asT<String>(json['versionNo'])!,
    versionName: asT<String>(json['versionName'])!,
    content: asT<String>(json['content'])!,
    downUrl: asT<String>(json['downUrl'])!,
    wrapSize: asT<double>(json['wrapSize']),
    updateStatus: asT<int>(json['updateStatus'])!,
    updateType: asT<int>(json['updateType'])!,
    createTime: asT<int>(json['createTime'])!,
  );
  String? wrapName;
  int osType;
  String versionNo;
  String versionName;
  String content;
  String downUrl;
  double? wrapSize;
  int updateStatus;
  int updateType;
  int createTime;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'wrapName': wrapName,
    'osType': osType,
    'versionNo': versionNo,
    'versionName': versionName,
    'content': content,
    'downUrl': downUrl,
    'wrapSize': wrapSize,
    'updateStatus': updateStatus,
    'updateType': updateType,
    'createTime': createTime,
  };
}
