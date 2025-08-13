import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_template/app/app_constant.dart';
import 'package:flutter_bloc_template/app/log.dart';
import 'package:flutter_bloc_template/model/login_result_model.dart';
import 'package:flutter_bloc_template/router/app_router.dart';
import 'package:flutter_bloc_template/services/local_storage_service.dart';
import 'package:flutter_bloc_template/services/user_service.dart';

class CustomInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra["ts"] = DateTime.now().millisecondsSinceEpoch;
    String loginResult = LocalStorageService.instance.getValue(LocalStorageService.kToken, '');
    if (loginResult.isNotEmpty) {
      var token = LoginResultModel.fromJson(json.decode(loginResult));
      options.headers["Authorization"] = '${token.tokenType} ${token.token}';
    }
    // var local = AppSettingsService.instance.locale.value;
    // options.headers["Accept-Language"] = local != null ? "${local.languageCode}-${local.countryCode}" : ""; 
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    var time =
        DateTime.now().millisecondsSinceEpoch - err.requestOptions.extra["ts"];
    Log.e('''【HTTP请求错误】 耗时:${time}ms
Request Method：${err.requestOptions.method}
Response Code：${err.response?.statusCode}
Request URL：${err.requestOptions.uri}
Request Query：${err.requestOptions.queryParameters}
Request Data：${err.requestOptions.data}
Request Headers：${err.requestOptions.headers}
Response Headers：${err.response?.headers.map}
Response Data：${err.response?.data}''', err.stackTrace);
    if (err.response?.statusCode == AppConstant.notAuthCode || err.response?.statusCode == AppConstant.noPermissionCode) {
      var currentContext = AppRouter.instance.navigatorKey.currentContext;
      if (currentContext != null) {
        currentContext.read<UserBloc>().logout();
      }
    }
    super.onError(err, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    var time = DateTime.now().millisecondsSinceEpoch -
        response.requestOptions.extra["ts"];
    if (response.requestOptions.uri.toString().contains(".txt")) {
      Log.i(
        '''【HTTP请求响应】 耗时:${time}ms
Request Method：${response.requestOptions.method}
Request Code：${response.statusCode}
Request URL：${response.requestOptions.uri}''',
      );
      return super.onResponse(response, handler);
    }
    Log.i(
      '''【HTTP请求响应】 耗时:${time}ms
Request Method：${response.requestOptions.method}
Request Code：${response.statusCode}
Request URL：${response.requestOptions.uri}
Request Query：${response.requestOptions.queryParameters}
Request Data：${response.requestOptions.data}
Request Headers：${response.requestOptions.headers}
Response Headers：${response.headers.map}
Response Data：${response.data}''',
    );
    super.onResponse(response, handler);
  }
}