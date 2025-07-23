import 'package:flutter_bloc_template/app/base/reactive_bloc.dart';
import 'package:flutter_bloc_template/modules/test/counter.dart';

class CounterBloc extends ReactiveBloc<CounterEvent, CounterState> {
  CounterBloc() : super(CounterInitial()) {
    // 定义响应式变量
    final count = obs<int>('count', 0);
    final user = obs<User>('user', User(name: 'Guest'));

    on<IncrementEvent>((event, emit) {
      count.update((value) => value + 1);
    });

    on<UpdateUserEvent>((event, emit) {
      user.value = event.user;
    });
  }
}