import 'package:dio/dio.dart';
import 'package:flutter_bloc_template/app/app_constant.dart';
import 'package:flutter_bloc_template/app/app_error.dart';
import 'package:flutter_bloc_template/request/api.dart';
import 'package:flutter_bloc_template/request/custom_interceptor.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class HttpClient {
  static HttpClient? _httpUtil;

  static HttpClient get instance {
    _httpUtil ??= HttpClient();
    return _httpUtil!;
  }

  late Dio dio;
  HttpClient() {
    dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        sendTimeout: const Duration(seconds: 20),
      ),
    );
    dio.interceptors.add(CustomInterceptor());
  }

  /// Get请求
  /// * [path] 请求链接
  /// * [queryParameters] 请求参数
  /// * [cancel] 任务取消Token
  /// * [responseType] 返回的类型
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancel,
    ResponseType responseType = ResponseType.json,
    bool checkCode = false,
  }) async {
    Map<String, dynamic> header = {
      "operationID": Api.timeStamp,
      "version": Api.version,
      "timestamp": Api.timeStamp,
    };

    try {
      var result = await dio.get(
        Api.baseUrl + path,
        queryParameters: queryParameters,
        options: Options(responseType: responseType, headers: header),
        cancelToken: cancel,
      );
      if (checkCode && result.data is Map) {
        var data = result.data as Map;
        if (data[AppConstant.statusKey] == AppConstant.defaultCode ||
            data[AppConstant.statusKey] == AppConstant.successCode) {
          return result.data;
        } else {
          await SmartDialog.showToast(result.data[AppConstant.messageKey]);
          return throw AppError(
            result.data[AppConstant.messageKey].toString(),
            code:
                int.tryParse(result.data[AppConstant.statusKey].toString()) ??
                -1,
          );
        }
      }
      return result.data;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        rethrow;
      }
      String msg = e.response?.data[AppConstant.messageKey] ?? e.message;
      if (e.type == DioExceptionType.badResponse) {
        if (e.response?.statusCode != AppConstant.notAuthCode &&
            e.response?.statusCode != AppConstant.noPermissionCode) {
          await SmartDialog.showToast(msg);
        }
        return throw AppError(msg,code: -1);
      }
      await SmartDialog.showToast(msg);
      return throw AppError(msg,code: -1);
    }
  }

  /// Get 请求,返回JSON
  /// * [path] 请求链接
  /// * [queryParameters] 请求参数
  /// * [cancel] 任务取消Token
  Future<dynamic> getJson(
    String path, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancel,
    bool checkCode = false,
  }) async {
    return await get(
      path,
      queryParameters: queryParameters,
      cancel: cancel,
      responseType: ResponseType.json,
      checkCode: checkCode,
    );
  }

  /// Get 请求,返回Text
  /// * [path] 请求链接
  /// * [queryParameters] 请求参数
  /// * [cancel] 任务取消Token
  Future<dynamic> getText(
    String path, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancel,
  }) async {
    return await get(
      path,
      queryParameters: queryParameters,
      cancel: cancel,
      responseType: ResponseType.plain,
    );
  }

  /// Get 请求,返回byte
  /// * [path] 请求链接
  /// * [queryParameters] 请求参数
  /// * [cancel] 任务取消Token
  Future<dynamic> getBytes(
    String path, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancel,
  }) async {
    return await get(
      path,
      queryParameters: queryParameters,
      cancel: cancel,
      responseType: ResponseType.bytes,
    );
  }

  /// Post请求，返回Map
  /// * [path] 请求链接
  /// * [data] 发送数据
  /// * [queryParameters] 请求参数
  /// * [cancel] 任务取消Token
  Future<dynamic> postJson(
    String path, {
    Map<String, dynamic>? queryParameters,
    Object? data,
    CancelToken? cancel,
    bool formUrlEncoded = false,
    bool checkCode = false,
  }) async {
    Map<String, dynamic> header = {
      "operationID": Api.timeStamp,
      "version": Api.version,
      "timestamp": Api.timeStamp,
    };
    try {
      var result = await dio.post(
        Api.baseUrl + path,
        queryParameters: queryParameters,
        data: data,
        options: Options(
          responseType: ResponseType.json,
          headers: header,
          contentType: formUrlEncoded
              ? Headers.formUrlEncodedContentType
              : null,
        ),
        cancelToken: cancel,
      );
      if (checkCode && result.data is Map) {
        var data = result.data as Map;
        if (data[AppConstant.statusKey] == AppConstant.defaultCode ||
            data[AppConstant.statusKey] == AppConstant.successCode) {
          return result.data;
        } else {
          await SmartDialog.showToast(result.data[AppConstant.messageKey]);
          return throw AppError(
            result.data[AppConstant.messageKey].toString(),
            code:
                int.tryParse(result.data[AppConstant.statusKey].toString()) ??
                -1,
          );
        }
      }
      return result.data;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        rethrow;
      }
      String msg = e.response?.data[AppConstant.messageKey] ?? e.message;
      if (e.type == DioExceptionType.badResponse) {
        if (e.response?.statusCode != AppConstant.notAuthCode &&
            e.response?.statusCode != AppConstant.noPermissionCode) {
          await SmartDialog.showToast(msg);
        }
        return throw AppError(msg,code: -1);
      }
      await SmartDialog.showToast(msg);
      return throw AppError(msg,code: -1);
    }
  }
}
