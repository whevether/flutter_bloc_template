import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_template/app/base/bloc/base_bloc.dart';
import 'package:flutter_bloc_template/app/base/loading_state.dart';
import 'package:flutter_bloc_template/app/base/ui_adapter.dart';
import 'package:flutter_bloc_template/app/base/ui_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_template/app/base/global_event_manager.dart';

/// createTime: 2021/9/17 on 21:18
/// desc:
///
/// @author azhon

///UI
abstract class BaseUIState<T extends StatefulWidget> extends State<T>
    with UIAdapter, UIWidget {}

///bloc
abstract class BaseBlocState<T extends StatefulWidget> extends BaseUIState<T>
    with LoadingState {
  List<BaseBloc>? _blocs;

  ///添加bloc进行管理
  void addBloc(BaseBloc bloc) {
    _blocs ??= [];
    _blocs!.add(bloc);
    bloc.setState(this);
  }

  ///获取bloc进行管理
  B getBloc<B extends BlocBase>() {
    final list = _blocs
        ?.where((element) => element.runtimeType.toString() == B.toString())
        .toList();
    if (list == null || list.isEmpty) {
      throw Exception('please use addBloc($B()) first...');
    }
    return list.first as B;
  }


  @override
  BuildContext get buildContext => context;

  @override
  void dispose() {
    super.dispose();

    ///组件销毁，释放bloc
    _blocs?.forEach((element) {
      element.close();
    });
    _blocs?.clear();
  }
}

///global event
abstract class BaseGlobalEventState<T extends StatefulWidget>
    extends BaseBlocState<T> {
  StreamSubscription? _streamSubscription;

  ///only one listener
  ///[type] Specify event type
  void listenerGlobalEvent({
    required GlobalEventCallBack callBack,
    List<String>? type,
  }) {
    _cancel();
    _streamSubscription = GlobalEventManager.instance.subscribe((global) {
      if (type == null) {
        callBack.call(global.type, global.data);
      } else {
        if (type.contains(global.type)) {
          callBack.call(global.type, global.data);
        }
      }
    });
  }

  void _cancel() {
    if (_streamSubscription != null) {
      _streamSubscription?.cancel();
      _streamSubscription = null;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _cancel();
  }
}

abstract class BaseState<T extends StatefulWidget>
    extends BaseGlobalEventState<T> {}
