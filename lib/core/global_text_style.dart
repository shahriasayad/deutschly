import 'package:flutter/material.dart';
import 'package:deutschly/core/screen_util.dart';

TextStyle getTextStyle({
  double fontSize = 14,
  FontWeight fontWeight = FontWeight.w400,
  Color? color,
  double? height,
  TextDecoration? decoration,
}) {
  return TextStyle(
    fontSize: fontSize.sp,
    fontWeight: fontWeight,
    color: color,
    height: height,
    decoration: decoration,
  );
}
