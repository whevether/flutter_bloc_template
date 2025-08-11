import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_template/app/base/base_state.dart';
import 'package:flutter_bloc_template/app/base/base_stateful_widget.dart';
import 'package:flutter_bloc_template/services/user_service.dart';

class LoginPages extends BaseStatefulWidget{
  const LoginPages({super.key});

  @override
  State<LoginPages> createState() => _LoginPagesState();
}
class _LoginPagesState extends BaseState<LoginPages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Center(
        child: ElevatedButton(onPressed: (){
          // 触发登录事件
          context.read<UserBloc>().login({'loginType': 'account','username': 'admin', 'password': 'admin','tenancyId': '1'}, '/api/asf/authorise/login');
        }, child: const Text('登录'),),
      ),
    );
  }
}
