import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_template/app/base/base_stateless_widget.dart';
import 'package:flutter_bloc_template/app/base/data/data_change_bloc.dart';
import 'package:flutter_bloc_template/app/base/data/data_change_state.dart';

class DataChangeWidget<T> extends BaseStatelessWidget {
  final DataChangeBloc<T> bloc;
  final BlocWidgetBuilder<T?> child;

  const DataChangeWidget({
    required this.bloc,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DataChangeBloc<T>, DataChangeState<T?>>(
      bloc: bloc,
      builder: (BuildContext b, state) {
        return child.call(b, state.data);
      },
    );
  }
}