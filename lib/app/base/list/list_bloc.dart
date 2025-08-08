import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter_bloc_template/app/base/bloc/base_bloc.dart';
import 'package:flutter_bloc_template/app/base/list/list_event.dart';
import 'package:flutter_bloc_template/app/base/list/list_state.dart';
class ListBloc<T> extends BaseBloc<ListEvent<T>, ListState<T>> {
  ///当前页码
  late int pageNum;
  ///初始页码
  final int startPageNum;
  //传递query参数
  final Map<String, dynamic> params;
  //传递data参数
  final Map<String, dynamic>? data;
  //请求地址
  final String url;
  //请求方式
  final String method;
  ///分页一页数量
  final int pageSize;
  ///EasyRefresh控制器
  final EasyRefreshController controller = EasyRefreshController();

  ListBloc({
    required this.url,
    this.params = const <String, dynamic>{},
    this.data,
    this.pageSize = 15,
    this.method = 'GET',
    this.startPageNum = 1,
  }) : super(InitialState(<T>[])) {
    this.pageNum = startPageNum;
  }

  void init() {
    pageNum = startPageNum;
    _changeParams();
    add(InitEvent());
  }

  void refresh() {
    pageNum = startPageNum;
    _changeParams();
    add(RefreshEvent());
  }

  void loadMore() {
    pageNum++;
    _changeParams();
    add(LoadMoreEvent());
  }

  void loadMoreError() {
    pageNum--;
    _changeParams();
  }


  void updateState(List<T> list) {
    add(UpdateEvent(list));
  }
  //
  void _changeParams() {
    if (params.isNotEmpty) {
      params['page'] = pageNum;
      params['pageSize'] = pageSize;
    } else {
      params.addAll({
        'page': pageNum,
        'pageSize': pageSize,
      });
    }
  }

  @override
  Future<void> close() async {
    controller.dispose();
    await super.close();
  }
}
