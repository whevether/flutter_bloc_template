import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc_template/app/env.dart';

class AppConstant {
  //视频缓存路径
  static const String videoCache = 'videoCache';
  //语音缓存路径
  static const String audioCache = 'audioCache';
   //图片缓存路径
  static const String imageCache = 'imageCache';
   //头像缓存路径
  static const String avatarCache = 'avatarCache';
  //api地址
  static String serverUrl = '${Env.apiBaseUrl}:${Env.httpPort}';
  //成功状态码
  static const int successCode = 1;
  //默认状态码
  static const int defaultCode = 0;
  //无权限状态码
  static const int noPermissionCode = 403;
  //未授权状态码
  static const int notAuthCode = 401;
  //状态码key
  static const String statusKey = 'code';
  //消息key
  static const String messageKey = 'msg';
  //结果key
  static const String resultKey = 'data';
  //总分页
  static const String totalCountKey = 'totalCount';
  ///
  static String get tenantID => '18';
   //支持多语言
  static Map<int, Locale?> mapLocale = {
    0: Locale("en", "US"),
    1: Locale("zh", "HK"),
    2: Locale("zh", "CN"),
    3: Locale("vi", "VN"),
    4: Locale("id", "ID"),
    5: Locale("hi", "IN"),
    6: Locale("en", "PH"),
    7: Locale("th", "TH"),
    8: Locale("ms", "MY")
  };
}
