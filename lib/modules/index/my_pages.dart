import 'package:flutter/material.dart';
import 'package:flutter_bloc_template/app/base/base_state.dart';
import 'package:flutter_bloc_template/app/base/base_stateful_widget.dart';

class MyPages extends BaseStatefulWidget{
  const MyPages({super.key});

  @override
  State<MyPages> createState() => _MyPagesState();
}
class _MyPagesState extends BaseState<MyPages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('My Page'),
      ),
    );
  }
}