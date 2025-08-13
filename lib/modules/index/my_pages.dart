import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_template/app/base/base_state.dart';
import 'package:flutter_bloc_template/app/base/base_stateful_widget.dart';
import 'package:flutter_bloc_template/services/user_service.dart';

class MyPages extends BaseStatefulWidget{
  const MyPages({super.key});

  @override
  State<MyPages> createState() => _MyPagesState();
}
class _MyPagesState extends BaseState<MyPages> {
  @override
  Widget build(BuildContext context) {
    var state = context.read<UserBloc>().state;
    return Scaffold(
      body: Center(
        child: Text('id: ${state.user?.id} ,用户名: ${state.user?.username}'),
      ),
    );
  }
}