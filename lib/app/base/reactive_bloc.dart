import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_template/app/base/reactive.dart';

abstract class ReactiveBloc<Event, State> extends Bloc<Event, State> {
  final Map<String, Reactive<dynamic>> _reactives = {};

  ReactiveBloc(super.initialState);

  Reactive<T> obs<T>(String key, T initialValue) {
    if (!_reactives.containsKey(key)) {
      _reactives[key] = Reactive<T>(initialValue);
    }
    return _reactives[key] as Reactive<T>;
  }

  void updateReactive<T>(String key, T newValue) {
    if (_reactives.containsKey(key)) {
      (_reactives[key] as Reactive<T>).value = newValue;
    }
  }

  @override
  Future<void> close() {
    for (var element in _reactives.values) {
      element.dispose();
    }
    return super.close();
  }
}
