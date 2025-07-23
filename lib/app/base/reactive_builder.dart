import 'package:flutter/material.dart';
import 'package:flutter_bloc_template/app/base/reactive.dart';

class ReactiveBuilder<T> extends StatelessWidget {
  final Reactive<T> reactive;
  final Widget Function(BuildContext, T) builder;

  const ReactiveBuilder({
    super.key,
    required this.reactive,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<T>(
      valueListenable: reactive,
      builder: (context, value, child) {
        return builder(context, value);
      },
    );
  }
}
