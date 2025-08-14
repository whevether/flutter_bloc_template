import 'dart:io';

import 'package:flutter_bloc_template/app/app_constant.dart';
import 'package:flutter_bloc_template/app/utils.dart';
import 'package:flutter_bloc_template/model/login_result_model.dart';
import 'package:flutter_bloc_template/model/user_model.dart';
import 'package:flutter_bloc_template/model/version_model.dart';
import 'package:flutter_bloc_template/request/http_client.dart';

/// 通用的请求
class CommonRequest {
  // 检查更新
  Future<VersionModel?> checkUpdate() async {
    String version = Utils.packageInfo.version;
    int osType = Platform.isAndroid ? 1 : 0;
    var result = await HttpClient.instance.getJson(
      "/api/asf/appSetting/getAppSetting",
      checkCode: true,
      queryParameters: {'versionNo': version, 'osType': osType},
    );
    if (result[AppConstant.resultKey] == null) {
      return null;
    }
    return VersionModel.fromJson(result[AppConstant.resultKey]);
  }

  //用户登录
  Future<LoginResultModel?> login(Map<String, dynamic> data) async {
    var result = await HttpClient.instance.postJson(
      "/api/asf/authorise/login",
      data: data,
      checkCode: true,
    );
    if (result[AppConstant.resultKey] == null) {
      return null;
    }
    return LoginResultModel.fromJson(result[AppConstant.resultKey]);
  }

  //获取用户信息
  Future<UserModel?> getUserInfo() async {
    var result = await HttpClient.instance.getJson(
      "/api/asf/account/accountinfo",
      checkCode: true,
    );
    if (result[AppConstant.resultKey] == null) {
      return null;
    }
    return UserModel.fromJson(result[AppConstant.resultKey]);
  }
}
