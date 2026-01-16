import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_template/modules/index/index_pages.dart';
import 'package:flutter_bloc_template/modules/login/login_pages.dart';
import 'package:flutter_bloc_template/modules/splash_screen.dart';
import 'package:flutter_bloc_template/router/router_path.dart';
import 'package:flutter_bloc_template/services/user_service.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:go_router/go_router.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<UserState> stream) {
    _subscription = stream
        .distinct((prev, next) => prev.loginResult != next.loginResult)
        .listen(
          (UserState _) => notifyListeners(),
        );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

class AppRouter {
  static final instance = AppRouter._();
  AppRouter._();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  // 关键：定义一个变量来持有 router
  GoRouter? _router;

  // 提供一个获取方法，如果未初始化则报错或通过 context 初始化
  GoRouter getRouter(BuildContext context) {
    // 如果已经初始化，直接返回
    if (_router != null) return _router!;

    final userBloc = context.read<UserBloc>();

    _router = GoRouter(
      initialLocation: RoutePath.kSplash,
      navigatorKey: navigatorKey,
      observers: [FlutterSmartDialog.observer],
      // 核心：将 context 中的 userBloc 转换为 Listenable
      refreshListenable: GoRouterRefreshStream(userBloc.stream),

      redirect: (context, state) {
        final user = userBloc.state;
        final bool isLoggedIn = user.loginResult != null;
        final String location = state.matchedLocation;
        // 如果 Splash 没播完，强制留在 Splash
        if (!user.isSplashFinished) {
          return RoutePath.kSplash;
        }
        if (!isLoggedIn) {
          // 未登录且不在登录页 -> 去登录
          return (location != RoutePath.kUserLogin)
              ? RoutePath.kUserLogin
              : null;
        } else {
          // 已登录且在登录/启动页 -> 去首页
          if (location == RoutePath.kUserLogin ||
              location == RoutePath.kSplash) {
            return RoutePath.kIndex;
          }
        }

        return null;
      },
      routes: _routes,
    );

    return _router!;
  }

  // ... 保持 _routes 和 _fadeTransitionPage 不变 ...
  List<RouteBase> get _routes => [
        GoRoute(
          name: 'splash',
          path: RoutePath.kSplash,
          pageBuilder: (context, state) => _fadeTransitionPage(
              context: context, child: const SplashScreen()),
        ),
        GoRoute(
          name: 'login',
          path: RoutePath.kUserLogin,
          pageBuilder: (context, state) =>
              _fadeTransitionPage(context: context, child: LoginPages()),
        ),
        GoRoute(
          name: 'index',
          path: RoutePath.kIndex,
          pageBuilder: (context, state) =>
              _fadeTransitionPage(context: context, child: IndexPages()),
        ),
      ];

  Page<void> _fadeTransitionPage(
      {required BuildContext context, required Widget child}) {
    return CustomTransitionPage(
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }
}
