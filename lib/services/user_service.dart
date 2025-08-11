import 'dart:convert';

import 'package:flutter_bloc_template/app/base/bloc/base_bloc.dart';
import 'package:flutter_bloc_template/app/base/bloc/base_event.dart';
import 'package:flutter_bloc_template/model/login_result_model.dart';
import 'package:flutter_bloc_template/model/user_model.dart';
import 'package:flutter_bloc_template/request/http_client.dart';
// import 'package:flutter_bloc_template/router/app_router.dart';
// import 'package:flutter_bloc_template/router/router_path.dart';
import 'package:flutter_bloc_template/services/local_storage_service.dart';

// 用户状态
class UserState {
  final UserModel? user;
  final LoginResultModel? loginResult;
  UserState({this.user, this.loginResult});
}

//用户事件
abstract class UserEvent extends BaseEvent<UserBloc, UserState> {}

//用户登录事件
class UserLoginEvent extends UserEvent {
  final Map<String, dynamic> data;
  final String url;
  UserLoginEvent(this.data, this.url);
  @override
  Future<UserState> on(UserBloc bloc, UserState currentState) async {
    //返回用户信息
    var result =
        await HttpClient.instance.postJson(url, data: data, checkCode: true)
            as Map<String, dynamic>?;
    if (result == null) {
      bloc.loadError(Exception("Login failed"));
      return UserState(user: currentState.user, loginResult: null);
    }
    LoginResultModel loginResult = LoginResultModel.fromJson(result['result']);
    LocalStorageService.instance.setValue(
      LocalStorageService.kToken,
      loginResult.toString(),
    );
    // AppRouter.instance.router.go(RoutePath.kIndex);
    return UserState(user: currentState.user, loginResult: loginResult);
  }
}

//用户登出事件
class UserLogoutEvent extends UserEvent {
  @override
  Future<UserState> on(UserBloc bloc, UserState currentState) async {
    LocalStorageService.instance.removeValue(LocalStorageService.kToken);
    //清除用户信息
    return UserState(user: null, loginResult: null);
  }
}

//用户信息事件
class UserInfoEvent extends UserEvent {
  final Map<String, dynamic> data;
  final String url;
  UserInfoEvent(this.data, this.url);
  @override
  Future<UserState> on(UserBloc bloc, UserState currentState) async {
    //获取用户信息
    var result =
        await HttpClient.instance.get(url, queryParameters: data,checkCode: true)
            as Map<String, dynamic>?;
    if (result == null) {
      return UserState(user: null, loginResult: currentState.loginResult);
    }
    UserModel userModel = UserModel.fromJson(result['result']);
    return UserState(user: userModel, loginResult: currentState.loginResult);
  }
}
//从缓存初始化登录数据
class InitLoginResultEvent extends UserEvent {
  @override
  Future<UserState> on(UserBloc bloc, UserState currentState) async {
    //从缓存获取登录结果
    var loginResult = LocalStorageService.instance.getValue(LocalStorageService.kToken,'');
    if (loginResult.isNotEmpty) {
      return UserState(
        user: currentState.user,
        loginResult: LoginResultModel.fromJson(json.decode(loginResult)),
      );
    }
    return UserState(user: currentState.user, loginResult: null);
  }
}
//用户Bloc
class UserBloc extends BaseBloc<UserEvent, UserState> {
  UserBloc(super.initialState){
    initLoginResult();
  }
  //登录
  Future<void> login(Map<String, dynamic> data, String url) async {
    add(UserLoginEvent(data, url));
  }

  //登出
  Future<void> logout() async {
    add(UserLogoutEvent());
  }

  //获取用户信息
  Future<void> getUserInfo(Map<String, dynamic> data, String url) async {
    add(UserInfoEvent(data, url));
  }
  //初始化登录结果
  Future<void> initLoginResult() async {
    add(InitLoginResultEvent());
  }
}
