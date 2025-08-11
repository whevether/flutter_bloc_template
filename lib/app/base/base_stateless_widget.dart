import 'package:flutter/material.dart';
import 'package:flutter_bloc_template/app/base/ui_adapter.dart';
import 'package:flutter_bloc_template/app/base/ui_widget.dart';

abstract class BaseStatelessWidget extends StatelessWidget
    with UIAdapter, UIWidget {
  const BaseStatelessWidget({super.key});
}
