import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc_template/app/app_color.dart';

class AppStyle {
  static ThemeData lightTheme = ThemeData.light().copyWith(
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    colorScheme: AppColor.colorSchemeLight,
    scaffoldBackgroundColor: Colors.white,
    tabBarTheme: const TabBarThemeData(
      indicatorColor: Colors.blue,
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: AppColor.black333,
      centerTitle: false,
      shape: Border(
        bottom: BorderSide(
          color: Colors.grey.withValues(alpha: .2),
          width: 1,
        ),
      ),
      iconTheme: const IconThemeData(
        color: AppColor.black333,
      ),
      titleTextStyle: const TextStyle(
        fontSize: 16,
        color: AppColor.black333,
      ),
      systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
        systemNavigationBarColor: Colors.transparent,
      ),
    ),
  );
  static ThemeData darkTheme = ThemeData.dark().copyWith(
    brightness: Brightness.dark,
    primaryColor: Colors.blue,
    colorScheme: AppColor.colorSchemeDark,
    scaffoldBackgroundColor: Colors.black,
    tabBarTheme: const TabBarThemeData(
      indicatorColor: Colors.blue,
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      centerTitle: false,
      shape: Border(
        bottom: BorderSide(
          color: Colors.grey.withValues(alpha: .2),
          width: 1,
        ),
      ),
      titleTextStyle: const TextStyle(
        fontSize: 16,
        color: Colors.white,
      ),
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
        systemNavigationBarColor: Colors.transparent,
      ),
    ),
  );
}

