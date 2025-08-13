import 'package:flutter/material.dart';
import 'package:flutter_bloc_template/app/base/base_state.dart';
import 'package:flutter_bloc_template/app/base/base_stateful_widget.dart';
import 'package:flutter_bloc_template/widget/net_image.dart';

class FindPages extends BaseStatefulWidget{
  const FindPages({super.key});

  @override
  State<FindPages> createState() => _FindPagesState();
}
class _FindPagesState extends BaseState<FindPages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: NetImage('https://ts4.tc.mm.bing.net/th/id/OIP-C.zNMgWWy5sEmcLZ6JB5x5kAHaE7?rs=1&pid=ImgDetMain&o=7&rm=3'),
      ),
    );
  }
}