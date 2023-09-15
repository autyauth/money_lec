import 'package:flutter/material.dart';
import 'package:money_lec/theme/pallete.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Pallete.pinkColor,
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Pallete.whiteColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Pallete.pinkColor,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Pallete.whiteColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    ),
  );
}
