import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart' hide ErrorWidgetBuilder;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_template/app/base/base_state.dart';
import 'package:flutter_bloc_template/app/base/list/list_bloc.dart';
import 'package:flutter_bloc_template/app/base/list/list_state.dart';
import 'package:flutter_bloc_template/widget/bloc_load_widget.dart';
import 'package:flutter_bloc_template/widget/status/app_empty_widget.dart';

typedef RefreshChild<T> = Widget Function(BuildContext context, List<T> list);

class CommonRefreshWidget<T> extends StatefulWidget {
  final ListBloc<T> bloc;
  final RefreshChild<T> child;
  final Widget? emptyWidget;
  final bool wantKeepAlive;
  final bool autoInit;
  final ErrorWidgetBuilder? errorBuilder;

  const CommonRefreshWidget({
    required this.bloc,
    required this.child,
    this.emptyWidget,
    this.errorBuilder,
    this.wantKeepAlive = false,
    this.autoInit = true,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _CommonRefreshWidgetState<T>();
}

class _CommonRefreshWidgetState<T> extends BaseState<CommonRefreshWidget<T>>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    if (widget.autoInit) {
      widget.bloc.init();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<ListBloc<T>, ListState<T>>(
      bloc: widget.bloc,
      builder: (BuildContext context, ListState<T> state) {
        return BlocLoadWidget(
          loadBloc: widget.bloc.loadBloc,
          reload: () => widget.bloc.init(),
          errorBuilder: widget.errorBuilder,
          child: EasyRefresh(
            triggerAxis: Axis.vertical,
            // clipBehavior: Clip.none,
            header: const ClassicHeader(
              // safeArea: false,
              mainAxisAlignment: MainAxisAlignment.center,
              dragText: '拉动以刷新',
              armedText: '准备就绪',
              readyText: '刷新中...',
              processingText: '刷新中...',
              processedText: '成功',
              noMoreText: '没有更多了',
              failedText: '失败',
              messageText: '最后更新时间 %T',
            ),
            // header: const MaterialHeader(),
            footer: const ClassicFooter(
                    infiniteOffset: 70,
                    triggerOffset: 70,
                    mainAxisAlignment: MainAxisAlignment.center,
                    dragText: '拉动以刷新',
                    armedText: '准备就绪',
                    readyText: '加载中...',
                    processingText: '加载中...',
                    processedText: '成功',
                    noMoreText: '没有更多了',
                    failedText: '失败',
                    messageText: '最后更新时间 %T'),
            onRefresh: () => widget.bloc.refresh(),
            onLoad: () => widget.bloc.loadMore(),
            controller: widget.bloc.controller,
            child: state.data.isEmpty
                ? _emptyView()
                : widget.child.call(context, state.data),
          ),
        );
      },
    );
  }

  Widget _emptyView() {
    return Center(
      child: widget.emptyWidget ?? AppEmptyWidget(onRefresh: widget.bloc.init,),
    );
  }

  @override
  bool get wantKeepAlive => widget.wantKeepAlive;
}