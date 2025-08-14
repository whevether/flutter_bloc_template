import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_template/app/base/base_state.dart';
import 'package:flutter_bloc_template/app/base/base_stateful_widget.dart';
import 'package:flutter_bloc_template/services/app_setting_service.dart';
import 'package:flutter_bloc_template/services/user_service.dart';

class MyPages extends BaseStatefulWidget {
  const MyPages({super.key});

  @override
  State<MyPages> createState() => _MyPagesState();
}

class _MyPagesState extends BaseState<MyPages> {
  @override
  Widget build(BuildContext context) {
    var bloc = context.read<UserBloc>();
    var appSetting = context.read<AppSettingService>();
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('id: ${bloc.state.user?.id} ,用户名: ${bloc.state.user?.username}'),
            super.sizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                if(appSetting.state.themeMode == ThemeMode.light){
                  appSetting.setTheme(ThemeMode.dark);
                }else{
                  appSetting.setTheme(ThemeMode.light);
                }
                
              },
              child: Text('切换主题色', style: TextStyle(fontSize: 16)),
            ),
            super.sizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                bloc.logout();
              },
              child: Text('退出登录', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
