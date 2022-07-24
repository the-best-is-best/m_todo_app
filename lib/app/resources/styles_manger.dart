import 'package:flutter/material.dart';

import 'font_manager.dart';

TextStyle _getTextStyle({
  required double fontSize,
  required FontWeight fontWeight,
  Color color = Colors.black,
}) {
  return TextStyle(
    fontSize: fontSize,
    color: color,
    fontWeight: fontWeight,
  );
}

// light

TextStyle getLightStyle({
  double? fontSize,
  Color color = Colors.black,
}) {
  return _getTextStyle(
      fontSize: fontSize ?? FontSize.s18,
      fontWeight: FontWeightManager.light,
      color: color);
}

// regular

TextStyle getRegularStyle({
  double? fontSize,
  Color color = Colors.black,
}) {
  return _getTextStyle(
      fontSize: fontSize ?? FontSize.s20,
      fontWeight: FontWeightManager.regular,
      color: color);
}

// medium

TextStyle getMediumStyle({
  double? fontSize,
  Color color = Colors.black,
}) {
  return _getTextStyle(
      fontSize: fontSize ?? FontSize.s24,
      fontWeight: FontWeightManager.medium,
      color: color);
}

// semi bold

TextStyle getSemiBoldStyle({
  double? fontSize,
  Color color = Colors.black,
}) {
  return _getTextStyle(
      fontSize: fontSize ?? FontSize.s28,
      fontWeight: FontWeightManager.semiBold,
      color: color);
}

// bold

TextStyle getBoldStyle({
  double? fontSize,
  Color color = Colors.black,
}) {
  return _getTextStyle(
      fontSize: fontSize ?? FontSize.s30,
      fontWeight: FontWeightManager.bold,
      color: color);
}
