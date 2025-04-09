import 'package:flutter/material.dart';

class Constants {
  static const String appName = "Tourism App";

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSwatch(
      brightness: Brightness.light,
    ).copyWith(
      secondary: Colors.blueAccent, // Replace accentColor
    ),
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSwatch(
      brightness: Brightness.dark,
    ).copyWith(
      secondary: Colors.redAccent, // Replace accentColor
    ),
    primaryColor: Colors.black,
    scaffoldBackgroundColor: Colors.black,
  );
}