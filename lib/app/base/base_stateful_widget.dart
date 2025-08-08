/// createTime: 2021/9/17 on 21:22
/// desc:
///
/// @author azhon

import 'package:flutter/material.dart';
import 'package:flutter_bloc_template/app/base/ui_adapter.dart';

abstract class BaseStatefulWidget extends StatefulWidget with UIAdapter {
  const BaseStatefulWidget({Key? key}) : super(key: key);
}
