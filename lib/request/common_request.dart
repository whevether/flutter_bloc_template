import 'dart:io';

import 'package:flutter_bloc_template/app/app_constant.dart';
import 'package:flutter_bloc_template/app/utils.dart';
import 'package:flutter_bloc_template/model/version_model.dart';
import 'package:flutter_bloc_template/request/http_client.dart';

/// 通用的请求
class CommonRequest {
  Future<VersionModel?> checkUpdate() async {
    String version = Utils.packageInfo.version;
    int osType = Platform.isAndroid ? 1 : 0;
    var result = await HttpClient.instance.getJson(
      "/api/asf/appSetting/getAppSetting",
      checkCode: true,
      queryParameters: {'versionNo': version,'osType': osType},
    );
    if (result[AppConstant.resultKey] == null) {
      return null;
    }
    return VersionModel.fromJson(result[AppConstant.resultKey]);
  }
}