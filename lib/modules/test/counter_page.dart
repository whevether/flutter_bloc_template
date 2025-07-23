import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_template/app/base/reactive_builder.dart';
import 'package:flutter_bloc_template/modules/test/counter.dart';
import 'package:flutter_bloc_template/modules/test/counter_bloc.dart';

class CounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CounterBloc(),
      child: Scaffold(
        appBar: AppBar(title: Text('Reactive BLoC')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 响应式构建计数器
              ReactiveBuilder<int>(
                reactive: context.read<CounterBloc>().obs<int>('count', 0),
                builder: (context, count) {
                  return Text('Count: $count', style: TextStyle(fontSize: 24));
                },
              ),
              
              const SizedBox(height: 20),
              
              // 响应式构建用户信息
              ReactiveBuilder<User>(
                reactive: context.read<CounterBloc>().obs<User>('user', User(name: 'Guest')),
                builder: (context, user) {
                  return Text('User: ${user.name}', style: TextStyle(fontSize: 20));
                },
              ),
              
              ElevatedButton(
                onPressed: () => context.read<CounterBloc>().add(IncrementEvent()),
                child: Text('Increment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}