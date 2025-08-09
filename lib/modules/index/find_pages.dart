import 'package:flutter/material.dart';
import 'package:flutter_bloc_template/app/base/base_state.dart';
import 'package:flutter_bloc_template/app/base/base_stateful_widget.dart';

class FindPages extends BaseStatefulWidget{
  const FindPages({super.key});

  @override
  State<FindPages> createState() => _FindPagesState();
}
class _FindPagesState extends BaseState<FindPages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Find Page'),
      ),
    );
  }
}