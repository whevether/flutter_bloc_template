import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_template/app/base/base_state.dart';
import 'package:flutter_bloc_template/app/base/base_stateful_widget.dart';
import 'package:flutter_bloc_template/app/log.dart';
import 'package:flutter_bloc_template/router/router_path.dart';
import 'package:flutter_bloc_template/services/user_service.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends BaseStatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends BaseState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    //
    Future.delayed(const Duration(seconds: 2), () {
      if(mounted){
        var state = super.context.read<UserBloc>().state;
        if (state.loginResult == null) {
              Log.d("User logged out");
              super.context.go(RoutePath.kUserLogin);
            } else if(state.loginResult?.token != null) {
              Log.d("User logged in: ${state.loginResult?.token}");
              super.context.go(RoutePath.kIndex);
            }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              'assets/images/splashbackground.png',
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).height,
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            child: LottieBuilder.asset(
              'assets/lotties/splash_v3.json',
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).height,
              repeat: true,
            ),
          ),
          Positioned(
            top: 100,
            left: 0,
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo_bg.png',
                    width: 80,
                    height: 80,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'wchat 遇见美好的你',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
