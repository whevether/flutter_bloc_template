import 'package:flutter/material.dart';
import 'package:flutter_bloc_template/app/base/base_state.dart';
import 'package:flutter_bloc_template/app/base/base_stateful_widget.dart';

class HomePages extends BaseStatefulWidget{
  const HomePages({super.key});

  @override
  State<HomePages> createState() => _HomePagesState();
}
class _HomePagesState extends BaseState<HomePages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Home Page'),
      ),
    );
  }
}