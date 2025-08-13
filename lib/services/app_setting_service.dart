import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_template/app/app_constant.dart';
import 'package:flutter_bloc_template/app/dialog_utils.dart';
import 'package:flutter_bloc_template/app/log.dart';
import 'package:flutter_bloc_template/services/local_storage_service.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

// App设置状态
class AppSettingState {
  //主题
  final ThemeMode? themeMode;
  //语言
  final Locale? locale;
  //是否第一次运行
  final bool? firstRun;
  // 生物验证
  final LocalAuthentication auth = LocalAuthentication();
  // 是否使用生物验证锁
  final bool? localAuth;
  //构造函数
  AppSettingState({this.themeMode, this.locale, this.firstRun, this.localAuth});
  //设置主题和语言
  AppSettingState copyWith({
    ThemeMode? themeMode,
    Locale? locale,
    bool? firstRun,
    bool? localAuth,
  }) {
    return AppSettingState(
      themeMode: themeMode,
      locale: locale,
      firstRun: firstRun,
      localAuth: localAuth,
    );
  }
}

class AppSettingService extends Cubit<AppSettingState> {
  AppSettingService() : super(AppSettingState()) {
    _init();
  }
  //重缓存读取并初始化状态
  void _init() {
    ThemeMode themeMode =
        ThemeMode.values[LocalStorageService.instance.getValue(
          LocalStorageService.kThemeMode,
          0,
        )];
    Locale locale =
        AppConstant.mapLocale[LocalStorageService.instance.getValue(
          LocalStorageService.kLanguage,
          2,
        )]!;
    bool firstRun = LocalStorageService.instance.getValue(
      LocalStorageService.kFirstRun,
      true,
    );
    bool localAuth = LocalStorageService.instance.getValue(
      LocalStorageService.kLocalAuth,
      false,
    );
    emit(state.copyWith(
      themeMode: themeMode,
      locale: locale,
      firstRun: firstRun,
      localAuth: localAuth,
    ));
  }

  //设置主题
  void setTheme(ThemeMode themeMode) {
    if (state.themeMode == themeMode) return;
    unawaited(
      LocalStorageService.instance.setValue(
        LocalStorageService.kThemeMode,
        themeMode.index,
      ),
    );
    emit(state.copyWith(themeMode: themeMode));
  }

  //设置语言
  void setLocale(int locale) {
    if (state.locale == AppConstant.mapLocale[locale]) return;
    unawaited(
      LocalStorageService.instance.setValue(
        LocalStorageService.kLanguage,
        locale,
      ),
    );
    emit(state.copyWith(locale: AppConstant.mapLocale[locale]));
  }

  // 普通验证
  Future<bool> _authenticate() async {
    try {
      final bool didAuthenticate = await state.auth.authenticate(
        localizedReason: '请验证以支付',
      );
      return didAuthenticate;
    } on PlatformException catch (e) {
      if (e.code == auth_error.notAvailable) {
        Log.d('未启用生物验证,请前往设置开启,${e.code}');
        return false;
        // Add handling of no hardware here.
      } else if (e.code == auth_error.notEnrolled) {
        Log.d('未注册生物验证,${e.code}');
        return false;
        // ...
      } else {
        // ...
        Log.d('$e');
        return false;
      }
    }
  }

  //只能通过生物识别验证 这个使用之后就无法使用密码了
  Future<bool> _authenticateWithBiometrics() async {
    try {
      final bool didAuthenticate = await state.auth.authenticate(
        localizedReason: '请验证以支付',
        options: const AuthenticationOptions(biometricOnly: true),
      );
      return didAuthenticate;
    } on PlatformException catch (e) {
      if (e.code == auth_error.notAvailable) {
        Log.d('未启用生物验证,请前往设置开启,${e.code}');
        return false;
        // Add handling of no hardware here.
      } else if (e.code == auth_error.notEnrolled) {
        Log.d('未注册生物验证,${e.code}');
        return false;
        // ...
      } else {
        // ...
        Log.d('$e');
        return false;
      }
    }
  }

  //不带对话框的身份验证
  Future<bool> _authenticateWithoutDialogs() async {
    try {
      final bool didAuthenticate = await state.auth.authenticate(
        localizedReason: '请验证以支付',
        options: const AuthenticationOptions(useErrorDialogs: false),
      );
      return didAuthenticate;
      // #docregion NoErrorDialogs
    } on PlatformException catch (e) {
      if (e.code == auth_error.notAvailable) {
        Log.d('未启用生物验证,请前往设置开启,${e.code}');
        return false;
        // Add handling of no hardware here.
      } else if (e.code == auth_error.notEnrolled) {
        Log.d('未注册生物验证,${e.code}');
        return false;
        // ...
      } else {
        // ...
        Log.d('$e');
        return false;
      }
    }
  }

  //通过返回错误进行身份验证
  Future<bool> _authenticateWithErrorHandling() async {
    try {
      final bool didAuthenticate = await state.auth.authenticate(
        localizedReason: '请验证以支付',
        options: const AuthenticationOptions(useErrorDialogs: false),
      );
      return didAuthenticate;
    } on PlatformException catch (e) {
      if (e.code == auth_error.notEnrolled) {
        Log.d('未注册生物验证,${e.code}');
        return false;
      } else if (e.code == auth_error.lockedOut ||
          e.code == auth_error.permanentlyLockedOut) {
        Log.d('已锁定,永久锁定,${e.code}');
        return false;
        // ...
      } else {
        // ...
        Log.d('$e');
        return false;
      }
    }
  }

  /* localizedReason在生物验证或人脸验证失败之后输入密码显示在密码下面 */
  //检查是否支持生物识别/人脸识别
  Future<bool> _checkSupport() async {
    // #docregion CanCheck
    final bool canAuthenticateWithBiometrics =
        await state.auth.canCheckBiometrics;
    final bool canAuthenticate =
        canAuthenticateWithBiometrics || await state.auth.isDeviceSupported();
    // #enddocregion CanCheck

    return canAuthenticate;
  }

  //开启本地生物验证锁
  Future<bool> _onOpenLocalAuth() async {
    bool isSupport = await _checkSupport();
    if (isSupport) {
      bool isSuccess = await _authenticate();
      //  bool isSuccess =  await localAuth.authenticateWithBiometrics();
      if (!isSuccess) {
        SmartDialog.showToast('认证失败');
        return false;
      } else {
        return true;
      }
    } else {
      SmartDialog.showToast('不支持的设备');
      return false;
    }
  }

  //生物验证/人脸识别
  void onOpenFaceId(bool e, {int? authType = 0}) async {
    if (state.localAuth == e) return;
    final Map<int, Future<bool>> mapAuth = {
      0: _onOpenLocalAuth(),
      1: _authenticateWithBiometrics(),
      2: _authenticateWithoutDialogs(),
      3: _authenticateWithErrorHandling(),
    };
    if (e) {
      bool result = await DialogUtils.showAlertDialog(
        '为了你的账号安全，我们需要进行生物特征安全设置',
        title: '安全设置',
      );
      if (!result) {
        return;
      }
      bool isSuccess = await mapAuth[authType]!;
      if (!isSuccess) {
        return;
      }
      await LocalStorageService.instance.setValue(
        LocalStorageService.kLocalAuth,
        e,
      );
      emit(state.copyWith(localAuth: e));
    } else {
      bool isSuccess = await mapAuth[authType]!;
      if (!isSuccess) {
        return;
      }
      await LocalStorageService.instance.setValue(
        LocalStorageService.kLocalAuth,
        e,
      );
      emit(state.copyWith(localAuth: e));
    }
  }

  //首次运行
  void showFirstRun() async {
    if (state.firstRun == true) {
      await LocalStorageService.instance.setValue(
        LocalStorageService.kFirstRun,
        false,
      );
      emit(state.copyWith(firstRun: false));
      DialogUtils.checkUpdate();
    } else {
      await LocalStorageService.instance.setValue(
        LocalStorageService.kFirstRun,
        true,
      );
      emit(state.copyWith(firstRun: true));
      DialogUtils.checkUpdate();
    }
  }
}
