import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_template/app/app_style.dart';
import 'package:flutter_bloc_template/app/log.dart';
import 'package:flutter_bloc_template/app/utils.dart';
import 'package:flutter_bloc_template/i18n/localization_intl.dart';
import 'package:flutter_bloc_template/router/app_router.dart';
import 'package:flutter_bloc_template/router/router_path.dart';
import 'package:flutter_bloc_template/services/app_setting_service.dart';
import 'package:flutter_bloc_template/services/local_storage_service.dart';
import 'package:flutter_bloc_template/services/user_service.dart';
import 'package:flutter_bloc_template/widget/status/app_loadding_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';

Future<void> main() async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await Hive.initFlutter();
      //设置状态栏为透明
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
      );
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
      await initServices();
      runApp(MyApp());
    },
    (error, stackTrace) {
      //全局异常
      Log.e(error.toString(), stackTrace);
    },
  );
}

Future initServices() async {
  //包信息
  Utils.packageInfo = await PackageInfo.fromPlatform();
  //本地存储
  Log.d("Init LocalStorage Service");
  await LocalStorageService.instance.init();
}

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => PointerDeviceKind.values.toSet();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MultiBlocProvider(
        providers: [
          // 应用设置服务
          BlocProvider<AppSettingService>(
            create: (BuildContext context) => AppSettingService(),
          ),
          // 用户状态管理
          BlocProvider<UserBloc>(
              create: (BuildContext context) =>
                  UserBloc(UserState(user: null, loginResult: null))),
        ],
        child: BlocListener<UserBloc, UserState>(
          listenWhen: (previous, current) {
            // 当之前的登录信息不等于当前的登录信息时候才处理状态监听, （只有主动触发bloc事件才会触发不相同,例如登录，登出，触发401,403 http状态码）
            return previous.loginResult != current.loginResult;
          },
          listener: (BuildContext b, UserState s) {
            // 用户登录状态变化监听
            if (s.loginResult == null) {
              Log.d("User logged out");
              AppRouter.instance.router.go(RoutePath.kUserLogin);
            } else if (s.loginResult != null) {
              Log.d("User logged in: ${s.loginResult?.token}");
              AppRouter.instance.router.go(RoutePath.kIndex);
            }
          },
          child: BlocBuilder<AppSettingService, AppSettingState>(
            buildWhen: (previous, current) =>
                previous.themeMode != current.themeMode ||
                previous.locale != current.locale ||
                previous.firstRun != current.firstRun ||
                previous.localAuth != current.localAuth,
            builder: (BuildContext context, AppSettingState state) {
              return MaterialApp.router(
                title: 'Flutter BLoc Template',
                scrollBehavior: AppScrollBehavior(),
                themeMode: state.themeMode,
                theme: AppStyle.lightTheme,
                darkTheme: AppStyle.darkTheme,
                localizationsDelegates: const [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  LanguageLocalizationsDelegate(),
                ],
                routeInformationProvider:
                    AppRouter.instance.router.routeInformationProvider,
                routeInformationParser:
                    AppRouter.instance.router.routeInformationParser,
                routerDelegate: AppRouter.instance.router.routerDelegate,
                locale: state.locale,
                supportedLocales: const [
                  Locale("zh", "CN"),
                  Locale("en", "US"),
                  Locale("zh", "HK"),
                  Locale("vi", "VN"),
                  Locale("th", "TH"),
                  Locale("in", "ID"),
                  Locale("hi", "IN"),
                  Locale("en", "PH"),
                  Locale("ms", "MY"),
                ],
                debugShowCheckedModeBanner: false,
                // navigatorObservers: [FlutterSmartDialog.observer],
                builder: FlutterSmartDialog.init(
                  loadingBuilder: ((msg) => AppLoaddingWidget(msg: msg)),
                  //字体大小不跟随系统变化
                  builder: (context, child) => MediaQuery(
                    data: MediaQuery.of(
                      context,
                    ).copyWith(textScaler: const TextScaler.linear(1.0)),
                    child: child!,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
