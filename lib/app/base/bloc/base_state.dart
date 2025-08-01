import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_template/app/base/bloc/base_bloc.dart';
import 'package:flutter_bloc_template/app/base/loading_state.dart';

///bloc
abstract class BaseBlocState<T extends StatefulWidget>
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
  void sendEventToView(String type, [data]) {}

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