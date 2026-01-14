import 'package:flutter/material.dart';
import 'colors.dart';

class PulsoTheme {
  static ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: PulsoColors.background,
      fontFamily: 'Roboto',
      colorScheme: ColorScheme.dark(
        surface: PulsoColors.surface,
        primary: Colors.white,
      ),
    );
  }
}