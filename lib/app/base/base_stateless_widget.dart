/// createTime: 2021/9/17 on 17:45
/// desc:
///
/// @author azhon

import 'package:flutter/material.dart';
import 'package:flutter_bloc_template/app/base/ui_adapter.dart';
import 'package:flutter_bloc_template/app/base/ui_widget.dart';

abstract class BaseStatelessWidget extends StatelessWidget
    with UIAdapter, UIWidget {
  const BaseStatelessWidget({Key? key}) : super(key: key);
}
