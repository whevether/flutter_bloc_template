import 'package:flutter/material.dart';
import 'package:flutter_bloc_template/app/base/ui_adapter.dart';
import 'package:flutter_bloc_template/app/base/ui_widget.dart';

abstract class BaseStatefulWidget extends StatefulWidget with UIAdapter,UIWidget {
  const BaseStatefulWidget({super.key});
}
