import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc_template/app/base/base_state.dart';
import 'package:flutter_bloc_template/app/base/base_stateful_widget.dart';
import 'package:flutter_bloc_template/router/router_path.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends BaseStatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends BaseState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    unawaited(
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          super.context.go(RoutePath.kIndex);
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.go(RoutePath.kIndex),
          child: const Text('Go to the Details screen'),
        ),
      ),
    );
  }
}
