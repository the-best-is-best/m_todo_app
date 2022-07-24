import 'package:flutter/material.dart';
import 'package:m_todo_app/app/resources/font_manager.dart';

import '../resources/styles_manger.dart';

ThemeData myThemeData() {
  return ThemeData(
      primarySwatch: Colors.green,
      appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          titleTextStyle: getBoldStyle(),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black, size: FontSize.s30)));
}
