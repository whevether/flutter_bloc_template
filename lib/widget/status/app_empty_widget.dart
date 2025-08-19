import 'package:flutter/material.dart';
import 'package:flutter_bloc_template/app/app_style.dart';
import 'package:flutter_bloc_template/app/base/base_stateless_widget.dart';
import 'package:lottie/lottie.dart';

class AppEmptyWidget extends BaseStatelessWidget {
  final VoidCallback? onRefresh;
  const AppEmptyWidget({this.onRefresh, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          onRefresh?.call();
        },
        child: Padding(
          padding: super.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LottieBuilder.asset(
                'assets/lotties/empty.json',
                width: super.setWidth(200),
                height: super.setHeight(200),
                repeat: false,
              ),
               Text(
                "这里什么都没有",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: super.setFontSize(16), color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
