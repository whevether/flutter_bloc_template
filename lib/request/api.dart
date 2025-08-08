import 'package:flutter_bloc_template/app/app_constant.dart';

class Api {

  /// V3接口，无加密
  static String baseUrl = AppConstant.serverUrl;

  static const String version = "0.0.1";
  static String get timeStamp =>
      (DateTime.now().millisecondsSinceEpoch / 1000).toStringAsFixed(0);

  /// 默认的参数
  static Map<String, dynamic> getDefaultParameter({bool withUid = false}) {
    var map = <String, dynamic>{
      // "channel": "android",
      "version": version,
      "timestamp": timeStamp
    };
    return map;
  }
}