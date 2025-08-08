import 'package:flutter_bloc_template/app/base/bloc/base_bloc.dart';
import 'package:flutter_bloc_template/app/base/load/load_event.dart';
import 'package:flutter_bloc_template/app/base/load/load_state.dart';

/// createTime: 2021/10/21 on 14:55
/// desc:
///
/// @author azhon
class LoadBloc extends BaseLoadBloc<LoadEvent, LoadState> {
  bool _loading = false;

  LoadBloc() : super(InitialState());

  void loading() {
    _loading = true;
    add(LoadingEvent());
  }

  void loadDone() {
    _loading = false;
    add(InitialEvent());
  }

  void loadError(Exception exception) {
    _loading = false;
    add(ErrorEvent(exception));
  }

  bool get isLoading => _loading;
}
