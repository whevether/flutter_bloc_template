import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_template/app/base/base_stateless_widget.dart';
import 'package:flutter_bloc_template/app/base/load/load_bloc.dart';
import 'package:flutter_bloc_template/app/base/load/load_state.dart';
import 'package:flutter_bloc_template/widget/status/app_error_widget.dart';
import 'package:flutter_bloc_template/widget/status/app_loadding_widget.dart';

typedef ErrorWidgetBuilder = Widget? Function(
  BuildContext context,
  Exception exception,
);

class BlocLoadWidget extends BaseStatelessWidget {
  final Color color;
  final Widget child;
  final LoadBloc loadBloc;
  final VoidCallback? reload;
  final ErrorWidgetBuilder? errorBuilder;

  const BlocLoadWidget({
    required this.child,
    required this.loadBloc,
    required this.reload,
    this.errorBuilder,
    this.color = const Color(0xFF161619),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoadBloc, LoadState>(
      bloc: loadBloc,
      builder: (BuildContext context, LoadState state) {
        if (state is LoadingState) {
          return SizedBox.expand(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppLoaddingWidget()
              ],
            ),
          );
        }
        if (state is ErrorState) {
          return _errorWidget(context, state.exception);
        }
        return child;
      },
    );
  }

  Widget _errorWidget(BuildContext context, Exception exception) {
    final w = errorBuilder?.call(context, exception);
    if (w == null) {
      return AppErrorWidget(
        onRefresh: reload,
      );
    }
    return w;
  }
}