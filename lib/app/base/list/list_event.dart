import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter_bloc_template/app/app_constant.dart';
import 'package:flutter_bloc_template/app/base/bloc/base_event.dart';
import 'package:flutter_bloc_template/app/base/list/list_bloc.dart';
import 'package:flutter_bloc_template/app/base/list/list_state.dart';
import 'package:flutter_bloc_template/request/http_client.dart';

abstract class ListEvent<T> extends BaseEvent<ListBloc<T>, ListState<T>> {}

// 初始化事件
class InitEvent<T> extends ListEvent<T> {
  @override
  Future<ListState<T>> on(ListBloc<T> bloc, ListState<T> currentState) async {
    // 初始化加载状态
    bloc.loading();
    Map<String, dynamic>? bean;
    // 请求返回数据
    if (bloc.method == 'GET') {
      bean = await HttpClient.instance.getJson(
        bloc.url,
        queryParameters: bloc.params,
        checkCode: true,
      ) as Map<String, dynamic>?;
    } else if (bloc.method == 'POST') {
      bean = await HttpClient.instance.postJson(
        bloc.url,
        queryParameters: bloc.params,
        data: bloc.data,
        checkCode: true,
      ) as Map<String, dynamic>?;
    }
    // 检查状态码是否正确
    if (bean == null) {
      bloc.loadError(Exception(bean));
      bloc.controller.finishLoad(IndicatorResult.fail);
      return InitialState<T>(<T>[]);
    }
    //加载完成
    bloc.loadDone();
    // 如果返回的数据不存在则返回一个空列表
    List<T> list = <T>[];
    var result = bean[AppConstant.resultKey];
    for (var item in result) {
      list.add(item as T);
    }
    // 如果当前页数等于总页数，表示没有更多数据
    if (list.length == bean[AppConstant.totalCountKey] || list.isEmpty) {
      bloc.controller.finishRefresh();
      bloc.controller.finishLoad(IndicatorResult.noMore);
      return InitialState(list);
    }
    bloc.controller.finishRefresh();
    bloc.controller.resetFooter();
    // 更新当前状态的数据
    return InitialState(list);
  }
}

// 刷新事件
class RefreshEvent<T> extends ListEvent<T> {
  @override
  Future<ListState<T>> on(ListBloc<T> bloc, ListState<T> currentState) async {
    Map<String, dynamic>? bean;
    // 请求返回数据
    if (bloc.method == 'GET') {
      bean = await HttpClient.instance.getJson(
        bloc.url,
        queryParameters: bloc.params,
        checkCode: true,
      ) as Map<String, dynamic>?;
    } else if (bloc.method == 'POST') {
      bean = await HttpClient.instance.postJson(
        bloc.url,
        queryParameters: bloc.params,
        data: bloc.data,
        checkCode: true,
      ) as Map<String, dynamic>?;
    }
    // 检查状态码是否正确
    if (bean == null) {
      bloc.loadError(Exception(bean));
      bloc.controller.finishLoad(IndicatorResult.fail);
      return InitialState<T>(<T>[]);
    }
    // 如果返回的数据不存在则返回一个空列表
    List<T> list = <T>[];
    var result = bean[AppConstant.resultKey];
    for (var item in result) {
      list.add(item as T);
    }
    // 如果当前页数等于总页数，表示没有更多数据
    if (list.length == bean[AppConstant.totalCountKey] || list.isEmpty) {
      bloc.controller.finishRefresh();
      bloc.controller.finishLoad(IndicatorResult.noMore);
      return InitialState(list);
    }
    bloc.controller.finishRefresh();
    bloc.controller.resetFooter();
    // 更新当前状态的数据
    return InitialState(list);
  }
}

// 加载更多事件
class LoadMoreEvent<T> extends ListEvent<T> {
  @override
  Future<ListState<T>> on(ListBloc<T> bloc, ListState<T> currentState) async {
    Map<String, dynamic>? bean;
    // 请求返回数据
    if (bloc.method == 'GET') {
      bean = await HttpClient.instance.getJson(
        bloc.url,
        queryParameters: bloc.params,
      ) as Map<String, dynamic>?;
    } else if (bloc.method == 'POST') {
      bean = await HttpClient.instance.postJson(
        bloc.url,
        queryParameters: bloc.params,
        data: bloc.data,
      ) as Map<String, dynamic>?;
    }
    // 检查状态码是否正确
    if (bean == null) {
      bloc.loadMoreError();
      bloc.controller.finishLoad(IndicatorResult.fail);
      return currentState;
    }
    // 如果返回的数据不存在则返回一个空列表
    List<T> list = <T>[];

    var result = bean[AppConstant.resultKey];
    for (var item in result) {
      list.add(item as T);
    }
    // 如果当前页数等于总页数，表示没有更多数据
    if (list.length == bean[AppConstant.totalCountKey] || list.isEmpty) {
      bloc.controller.finishLoad(IndicatorResult.noMore);
      return currentState;
    }
    // 更新当前状态的数据
    currentState.data.addAll(list);
    bloc.controller.finishLoad(IndicatorResult.success);
    // 返回更新后的状态
    return currentState;
  }
}

// 更新事件
class UpdateEvent<T> extends ListEvent<T> {
  final List<T> list;

  UpdateEvent(this.list);

  @override
  Future<ListState<T>> on(ListBloc<T> bloc, ListState<T> currentState) async {
    return InitialState(list);
  }
}
