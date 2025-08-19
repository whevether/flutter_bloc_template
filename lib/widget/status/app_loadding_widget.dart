import 'package:flutter/material.dart';
import 'package:flutter_bloc_template/app/base/base_stateless_widget.dart';
import 'package:lottie/lottie.dart';

class AppLoaddingWidget extends BaseStatelessWidget {
  final String msg;
  const AppLoaddingWidget(
      {this.msg = "加载中", super.key});

  @override
  Widget build(BuildContext context) {
    late String loadName = 'loadding';
    List<String> arr= msg.split("^");
    String newMsg = msg;
    if(arr.length >= 2){
      loadName = arr[1];
      newMsg = arr[0];
    }
    return Center(
      child: Padding(
        padding: super.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LottieBuilder.asset(
              'assets/lotties/$loadName.json',
              width: super.setWidth(200),
            ),
            Text(
              newMsg,
              textAlign: TextAlign.center,
              style:  TextStyle(fontSize: super.setFontSize(16)),
            ),
          ],
        ),
      ),
    );
  }
}
