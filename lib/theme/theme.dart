import 'package:flutter/material.dart';

///
/// Define the Race Tracker App Colors
///
class RaceColors {
  static const Color primary = Color(0xFF060D4C); // Navy Blue
  static const Color accent = Color(0xFFFF8500); // Orange
  static const Color lightGrey = Color(0xFFCCCCCC);
  static const Color peach = Color(0xFFFFDAB9);

  static const Color black = Colors.black;
  static const Color white = Colors.white;

  // Backgrounds
  static Color get background => white;
  static Color get card => lightGrey;

  // Text
  static Color get textPrimary => black;
  static Color get textHeading => primary;
  static Color get textSubtle => lightGrey;
  static Color get textOnDark => white;

  // Buttons
  static Color get buttonPrimary => primary;
  static Color get buttonAccent => accent;
  static Color get buttonSecondary => peach;

  static Color get disabled => lightGrey;
}

///
/// Define the Spacing in pixels
/// with small (s), medium (m), large (l), extra large (xl), extra extra large (xxl)
/// as well as the radius
///
class RaceSpacings {
  static const double s = 12;
  static const double m = 16;
  static const double l = 24;
  static const double xl = 32;
  static const double xxl = 40;

  static const double radius = 16;
  static const double radiusLarge = 24;
}

///
/// Define the app textStyle with heading, body, label, button
///
class RaceTextStyles {
  static TextStyle heading = TextStyle(
      fontSize: 28, fontWeight: FontWeight.w500, color: RaceColors.textHeading);

  static TextStyle darkHeading = TextStyle(
      fontSize: 28, fontWeight: FontWeight.w500, color: RaceColors.textOnDark);

  static TextStyle body = TextStyle(
      fontSize: 16, fontWeight: FontWeight.w400, color: RaceColors.textPrimary);

  static TextStyle label = TextStyle(
      fontSize: 13, fontWeight: FontWeight.w400, color: RaceColors.textSubtle);

  static TextStyle button = TextStyle(
      fontSize: 14, fontWeight: FontWeight.w500, color: RaceColors.white);
}

///
/// Define the entire app theme
///
ThemeData raceAppTheme = ThemeData(
    fontFamily: 'Roboto',
    scaffoldBackgroundColor: RaceColors.background,
    primaryColor: RaceColors.primary);
