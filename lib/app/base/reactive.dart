import 'package:flutter/widgets.dart';

class Reactive<T> extends ValueNotifier<T> {
  Reactive(T value) : super(value);

  void update(void Function(T) callback) {
    callback(value);
    notifyListeners();
  }

  Reactive<R> map<R>(R Function(T) converter) {
    return Reactive<R>(converter(value))
      ..addListener(() {
        value = value; // 当父级变化时保持同步
      });
  }
}