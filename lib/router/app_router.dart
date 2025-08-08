import 'package:flutter/material.dart';
import 'package:flutter_bloc_template/modules/splash_screen.dart';
import 'package:flutter_bloc_template/router/router_path.dart';
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
      )
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