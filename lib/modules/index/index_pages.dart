import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_template/app/app_color.dart';
import 'package:flutter_bloc_template/app/base/base_state.dart';
import 'package:flutter_bloc_template/app/base/base_stateful_widget.dart';
import 'package:flutter_bloc_template/app/base/data/data_change_bloc.dart';
import 'package:flutter_bloc_template/app/event_bus.dart';
import 'package:flutter_bloc_template/modules/index/chat_pages.dart';
import 'package:flutter_bloc_template/modules/index/find_pages.dart';
import 'package:flutter_bloc_template/modules/index/home_pages.dart';
import 'package:flutter_bloc_template/modules/index/my_pages.dart';
import 'package:flutter_bloc_template/services/app_setting_service.dart';
import 'package:flutter_bloc_template/widget/data_change_widget.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';

// 首页
class IndexPages extends BaseStatefulWidget {
  const IndexPages({super.key});
  @override
  State<IndexPages> createState() => _IndexPagesState();
}

class _IndexPagesState extends BaseState<IndexPages> {
  final pageList = [HomePages(), FindPages(), ChatPages(), MyPages()];
  late DataChangeBloc<int> _selectIndex;
  // 初始化
  @override
  void initState() {
    super.initState();
    super.context.read<AppSettingService>().showFirstRun();
    _selectIndex = DataChangeBloc<int>(0);
  }

  @override
  void dispose() {
    super.dispose();
    _selectIndex.close();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var appSetting = context.read<AppSettingService>();
    return Stack(
      children: [
        DataChangeWidget<int>(
          bloc: _selectIndex,
          child: (context, state) {
            return Scaffold(
              extendBody: true,
              resizeToAvoidBottomInset: false,
              body: pageList[state!],
              floatingActionButton: FloatingActionButton(
                elevation: 8,
                backgroundColor: theme.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                onPressed: () {},
                child: Center(
                  child: Icon(Icons.add, color: theme.scaffoldBackgroundColor),
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              bottomNavigationBar: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: appSetting.state.themeMode == ThemeMode.light ? AppColor.backgroundColorDark.withValues(alpha: 0.5) : AppColor.backgroundColor.withValues(alpha: 0.5),
                      spreadRadius: 0,
                      blurRadius: 5,
                      offset: Offset(0, -0.5), // 控制阴影位置（向上偏移）
                    ),
                  ],
                ),
                child: WaterDropNavBar(
                  backgroundColor: theme.scaffoldBackgroundColor,
                  waterDropColor: theme.primaryColor,
                  inactiveIconColor: theme.primaryColor,
                  onItemSelected: (int index) {
                    if(index == state){
                      EventBus.instance.emit(EventBus.kBottomNavigationBarClicked, index);
                    }
                    _selectIndex.changeData(index);
                  },
                  selectedIndex: state,
                  barItems: <BarItem>[
                    BarItem(
                      filledIcon: Icons.bookmark_rounded,
                      outlinedIcon: Icons.bookmark_border_rounded,
                    ),
                    BarItem(
                      filledIcon: Icons.favorite_rounded,
                      outlinedIcon: Icons.favorite_border_rounded,
                    ),
                    BarItem(
                      filledIcon: Icons.email_rounded,
                      outlinedIcon: Icons.email_outlined,
                    ),
                    BarItem(
                      filledIcon: Icons.folder_rounded,
                      outlinedIcon: Icons.folder_outlined,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
