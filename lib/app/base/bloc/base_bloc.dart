import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_template/app/base/bloc/base_event.dart';
import 'package:flutter_bloc_template/app/base/load/load_bloc.dart';
import 'package:flutter_bloc_template/app/base/loading_state.dart';
/// createTime: 2021/9/29 on 16:49
/// desc:
///
/// @author azhon

abstract class BaseLoadBloc<E extends BaseEvent, S> extends Bloc<E, S> {
  BaseLoadBloc(super.initialState) {
    _init();
  }

  @override
  void add(E event) {
    if (isClosed) {
      return;
    }
    super.add(event);
  }

  void _init() {
    ///分发至event处理
    on<E>((E event, Emitter<S> emit) async {
      final S? resultState = await event.on(this, state);
      if (resultState != null) {
        emit.call(resultState);
      }
      onStateChange(resultState);
    });
  }

  ///状态变更
  void onStateChange(S? state) {}
}

abstract class BaseBloc<E extends BaseEvent, S> extends BaseLoadBloc<E, S> {
  LoadingState? _loadingState;
  final LoadBloc _loadBloc = LoadBloc();

  LoadBloc get loadBloc => _loadBloc;

  Future<void> setState(LoadingState state) async {
    _loadingState = state;
  }

  BaseBloc(super.initialState);

  ///view层接受bloc层事件
  void sendEventToView(String type, [data]) {
    if (_loadingState == null) {
      throw Exception('Please use [BaseState.addBloc()] first...');
    }
    _loadingState!.sendEventToView(type, data);
  }

  BuildContext get context {
    if (_loadingState == null) {
      throw Exception('Please use [BaseState.addBloc()] first...');
    }
    return _loadingState!.buildContext;
  }

  ///配合BlocLoadWidget使用，开始加载
  void loading() {
    loadBloc.loading();
  }

  ///配合BlocLoadWidget使用，加载完成
  void loadDone() {
    loadBloc.loadDone();
  }

  ///配合BlocLoadWidget使用，加载失败
  void loadError(Exception exception) {
    loadBloc.loadError(exception);
  }

  ///是否在加载中
  bool isLoading() {
    return loadBloc.isLoading;
  }

  @override
  Future<void> close() async {
    await loadBloc.close();
    await super.close();
    _loadingState = null;
  }
}