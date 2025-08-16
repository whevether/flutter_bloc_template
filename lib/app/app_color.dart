import 'package:flutter/material.dart';

class AppColor {
  static ColorScheme colorSchemeLight = ColorScheme.fromSwatch(
    primarySwatch: Colors.blue,
    accentColor: Colors.blue,
    brightness: Brightness.light,
  );
  static ColorScheme colorSchemeDark = ColorScheme.fromSwatch(
    primarySwatch: Colors.blue,
    accentColor: Colors.blue,
    // primaryColorDark: Colors.blue,
    brightness: Brightness.dark,
  );
  static const Color backgroundColor = Color(0xfffafafa);
  static const Color backgroundColorDark = Color(0xff212121);
  static const Color black333 = Color(0xff333333);
  static const Color greyf0f0f0 = Color(0xfff0f0f0);
  static const Color pinkBg = Colors.pink;
  static const Color disableTextColor = Color(0xFFCCCCCC);
  static const Color errorColor = Color(0xFFD54941);
  static const Color scuccessColor = Colors.green;
  static const Color borderTopColor = Color(0xFFC8CFD8);
  static const Color color1 = Color.fromARGB(255, 239, 139, 105);
  static const Color color8E9AB0 = Color(0xFF8E9AB0);
  static const Color color0089FF = Color(0xFF0089FF);
  static const Color colorCCE7FE = Color(0xFFCCE7FE);
  static const Color colorF4F5F7 =  Color(0xFFF4F5F7);
   static const Color color2 =  Color.fromARGB(255, 193, 2, 231);
  static Map<int, List<Color>> msgThemes = {
    0: [
      const Color.fromRGBO(245, 239, 217, 1),
      const Color(0xff301e1b),
    ],
    1: [
      const Color.fromRGBO(248, 247, 252, 1),
      black333,
    ],
    2: [
      const Color.fromRGBO(192, 237, 198, 1),
      Colors.black,
    ],
    3: [
      const Color(0xff3b3a39),
      const Color.fromRGBO(230, 230, 230, 1),
    ],
    4: [
      Colors.black,
      const Color.fromRGBO(200, 200, 200, 1),
    ],
  };
}
