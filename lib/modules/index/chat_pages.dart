import 'package:flutter/material.dart';
import 'package:flutter_bloc_template/app/base/base_state.dart';
import 'package:flutter_bloc_template/app/base/base_stateful_widget.dart';

class ChatPages extends BaseStatefulWidget{
  const ChatPages({super.key});

  @override
  State<ChatPages> createState() => _ChatPagesState();
}
class _ChatPagesState extends BaseState<ChatPages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Chat Page'),
      ),
    );
  }
}