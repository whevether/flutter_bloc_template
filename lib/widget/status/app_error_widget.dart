import 'package:flutter/material.dart';
import 'package:flutter_bloc_template/app/app_style.dart';
import 'package:flutter_bloc_template/app/base/base_stateless_widget.dart';
import 'package:flutter_bloc_template/app/utils.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:lottie/lottie.dart';

class AppErrorWidget extends BaseStatelessWidget {
  final VoidCallback? onRefresh;
  final String errorMsg;
  final Error? error;
  const AppErrorWidget(
      {this.errorMsg = "", this.onRefresh, this.error, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          onRefresh?.call();
        },
        child: Padding(
          padding: AppStyle.edgeInsetsA12,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LottieBuilder.asset(
                'assets/lotties/error.json',
                width: 260,
                repeat: false,
              ),
              Visibility(
                visible: onRefresh != null,
                child: Text(
                  "$errorMsg\r\n点击刷新",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              Visibility(
                visible: error != null,
                child: Padding(
                  padding: AppStyle.edgeInsetsT12,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 14),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () {
                      Utils.copyText(
                          "$errorMsg\n${error?.stackTrace?.toString()}");
                      SmartDialog.showToast("已复制详细信息");
                    },
                    child: const Text("复制详细信息"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}