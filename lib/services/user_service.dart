import 'dart:convert';
import 'package:flutter_bloc_template/app/base/bloc/base_bloc.dart';
import 'package:flutter_bloc_template/app/base/bloc/base_event.dart';
import 'package:flutter_bloc_template/model/login_result_model.dart';
import 'package:flutter_bloc_template/model/user_model.dart';
import 'package:flutter_bloc_template/request/common_request.dart';
import 'package:flutter_bloc_template/services/local_storage_service.dart';

// 用户状态
class UserState {
  final UserModel? user;
  final LoginResultModel? loginResult;
  final bool isSplashFinished;
  UserState({this.user, this.loginResult,this.isSplashFinished = false});
}

//用户事件
abstract class UserEvent extends BaseEvent<UserBloc, UserState> {}

//用户登录事件
class UserLoginEvent extends UserEvent {
  final Map<String, dynamic> data;
  UserLoginEvent(this.data);
  @override
  Future<UserState> on(UserBloc bloc, UserState currentState) async {
    //返回用户信息
    CommonRequest request = CommonRequest();
    var result = await request.login(data);
    if (result == null) {
      bloc.loadError(Exception("Login failed"));
      return UserState(user: currentState.user, loginResult: null,isSplashFinished: true);
    }
    LocalStorageService.instance.setValue(
      LocalStorageService.kToken,
      result.toString(),
    );
    if (currentState.user == null) {
      //获取用户信息
      var userResult = await request.getUserInfo();
      if (userResult == null) {
        return UserState(user: null, loginResult: result,isSplashFinished: true);
      }
      return UserState(user: userResult, loginResult: result,isSplashFinished: true);
    }
    return UserState(user: currentState.user, loginResult: result,isSplashFinished: true);
  }
}

//用户登出事件
class UserLogoutEvent extends UserEvent {
  @override
  Future<UserState> on(UserBloc bloc, UserState currentState) async {
    LocalStorageService.instance.removeValue(LocalStorageService.kToken);
    //清除用户信息
    return UserState(user: null, loginResult: null,isSplashFinished: true);
  }
}

//从缓存初始化登录数据
class InitLoginResultEvent extends UserEvent {
  @override
  Future<UserState> on(UserBloc bloc, UserState currentState) async {
    //从缓存获取登录结果
    var loginResult = LocalStorageService.instance.getValue(
      LocalStorageService.kToken,
      '',
    );
    CommonRequest request = CommonRequest();
    if (loginResult.isNotEmpty) {
      if (currentState.user == null) {
        //获取用户信息
        var result = await request.getUserInfo();
        if (result == null) {
          return UserState(user: null, loginResult: LoginResultModel.fromJson(json.decode(loginResult)),isSplashFinished: false);
        }
        return UserState(
          user: result,
          loginResult: LoginResultModel.fromJson(json.decode(loginResult)),
          isSplashFinished: false
        );
      } else {
        return UserState(
          user: currentState.user,
          loginResult: LoginResultModel.fromJson(json.decode(loginResult)),
          isSplashFinished: false
        );
      }
    }
    return UserState(user: currentState.user, loginResult: null,isSplashFinished: false);
  }
}
// 完成启动页事件
class FinishSplashEvent extends UserEvent {
  @override
  Future<UserState> on(UserBloc bloc, UserState currentState) async {
    // 保持现有的用户信息和登录状态，仅修改 isSplashFinished
    return UserState(
      user: currentState.user,
      loginResult: currentState.loginResult,
      isSplashFinished: true,
    );
  }
}
//用户Bloc
class UserBloc extends BaseBloc<UserEvent, UserState> {
  UserBloc(super.initialState) {
    initLoginResult();
  }
  //登录
  Future<void> login(Map<String, dynamic> data) async {
    add(UserLoginEvent(data));
  }

  //登出
  Future<void> logout() async {
    add(UserLogoutEvent());
  }

  //初始化登录结果
  Future<void> initLoginResult() async {
    add(InitLoginResultEvent());
  }
  // 标记 Splash 已完成
  Future<void> finishSplash() async {
    add(FinishSplashEvent());
  }
}
