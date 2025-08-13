import 'package:flutter/material.dart';
import 'package:flutter_bloc_template/app/base/base_state.dart';
import 'package:flutter_bloc_template/app/base/base_stateful_widget.dart';
import 'package:flutter_bloc_template/app/base/list/list_bloc.dart';
import 'package:flutter_bloc_template/widget/common_refresh_widget.dart';

class HomePages extends BaseStatefulWidget{
  const HomePages({super.key});

  @override
  State<HomePages> createState() => _HomePagesState();
}
class _HomePagesState extends BaseState<HomePages> {
  late ListBloc<Map<String,dynamic>> _listBloc;
  @override
  void initState() {
    super.initState();
    _listBloc = ListBloc<Map<String,dynamic>>(url: '/api/asf/audio/getloglist',startPageNum: 1,params: {'logType': 1});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CommonRefreshWidget<Map<String,dynamic>>(
        bloc: _listBloc,
        child: (context, list) {
          return ListView.builder(
            itemCount: list.length,
            padding: all(16),
            itemBuilder: (_, index) {
              return Card(
                child: ListTile(
                  title: Text(list[index]["accountName"] ?? '',style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                  subtitle: Align(
                    alignment: Alignment.centerRight,
                    child: Text(list[index]["id"] ?? '',style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}