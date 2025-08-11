import 'package:flutter/material.dart';
import 'package:flutter_bloc_template/app/base/base_state.dart';
import 'package:flutter_bloc_template/app/base/base_stateful_widget.dart';
import 'package:flutter_bloc_template/app/base/list/list_bloc.dart';

class HomePages extends BaseStatefulWidget{
  const HomePages({super.key});

  @override
  State<HomePages> createState() => _HomePagesState();
}
class _HomePagesState extends BaseState<HomePages> {
  late ListBloc<Map<String,String>> _listBloc;
  @override
  void initState() {
    super.initState();
    _listBloc = ListBloc<Map<String,String>>(url: '/api/testList',startPageNum: 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Home Page'),
      ),
    );
  }
}