import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_template/modules/index/index_pages.dart';
import 'package:flutter_bloc_template/modules/login/login_pages.dart';
import 'package:flutter_bloc_template/modules/splash_screen.dart';
import 'package:flutter_bloc_template/router/router_path.dart';
import 'package:flutter_bloc_template/services/user_service.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  late final GoRouter _router;
  //获取当前router实例
  GoRouter get router => _router;
  // router单例
  static final instance = AppRouter._();
  // 路由列表
  AppRouter._() {
    _router = GoRouter(
      routes: _routes,
      observers: [FlutterSmartDialog.observer],
      initialLocation: RoutePath.kSplash,
    );
  }
  List<RouteBase> get _routes {
    return [
      GoRoute(
        name: 'splash',
        path: RoutePath.kSplash,
        pageBuilder: (context, state) {
          return _fadeTransitionPage(context: context, child: SplashScreen());
        },
      ),
      GoRoute(
        name: 'login',
        path: RoutePath.kUserLogin,
        pageBuilder: (context, state) {
          return _fadeTransitionPage(context: context, child: LoginPages());
        },
        redirect: (context, state) {
          var userState = context.read<UserBloc>().state;
          if (userState.loginResult?.token != null) {
            return RoutePath.kIndex;
          }
          return null;
        },
      ),
      GoRoute(
        name: 'index',
        path: RoutePath.kIndex,
        pageBuilder: (context, state) {
          return _fadeTransitionPage(context: context, child: IndexPages());
        },
        redirect: (context, state) {
          var userState = context.read<UserBloc>().state;
          if (userState.loginResult?.token == null) {
            return RoutePath.kUserLogin;
          }
          return null;
        },
      ),
    ];
  }

  // 页面动画
  Page<void> _fadeTransitionPage({
    required BuildContext context,
    required Widget child,
  }) {
    return CustomTransitionPage(
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }
}
