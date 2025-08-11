import 'package:flutter_bloc_template/app/base/bloc/base_event.dart';
import 'package:flutter_bloc_template/app/base/load/load_bloc.dart';
import 'package:flutter_bloc_template/app/base/load/load_state.dart';

abstract class LoadEvent extends BaseEvent<LoadBloc, LoadState> {}

class InitialEvent extends LoadEvent {
  @override
  Future<LoadState> on(LoadBloc bloc, LoadState currentState) async {
    return InitialState();
  }
}

class LoadingEvent extends LoadEvent {
  @override
  Future<LoadState> on(LoadBloc bloc, LoadState currentState) async {
    return LoadingState();
  }
}

class ErrorEvent extends LoadEvent {
  final Exception exception;

  ErrorEvent(this.exception);

  @override
  Future<LoadState> on(LoadBloc bloc, LoadState currentState) async {
    return ErrorState(exception);
  }
}
