import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_template/app/base/data/data_change_state.dart';

/// createTime: 2025/08/11 on 21:22
/// desc:
///
/// @author keep.wan
class DataChangeBloc<T> extends Cubit<DataChangeState<T?>> {
  DataChangeBloc(T? data) : super(DataChangeState(data));

  T? get data => state.data;

  void changeData(T? data) {
    if (isClosed) {
      return;
    }
    emit(DataChangeState(data));
  }

  void update() {
    changeData(data);
  }
}
