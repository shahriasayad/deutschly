import 'package:flutter/material.dart';
import 'package:deutschly/core/app_colors.dart';

TextStyle getTextStyle({
  double fontSize = 14,
  FontWeight fontWeight = FontWeight.w400,
  Color color = AppColors.textPrimary,
  double? height,
  TextDecoration? decoration,
}) {
  return TextStyle(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
    height: height,
    decoration: decoration,
  );
}
