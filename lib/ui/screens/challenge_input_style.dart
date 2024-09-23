import 'package:flutter/material.dart';

class ChallengeInputStyle {
  // AppBar Styles
  static const TextStyle appBarTitleStyle = TextStyle(
    color: Colors.black,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static const Color appBarBackgroundColor = Colors.white;

  static const IconThemeData appBarIconTheme = IconThemeData(
    color: Colors.black,
  );

  // Background Color for the Page
  static const Color pageBackgroundColor = Colors.white;

  // Card Styles for Challenge Cards
  static const EdgeInsets cardPadding = EdgeInsets.all(12.0);
  static const EdgeInsets cardMargin = EdgeInsets.only(bottom: 16);

  static final ShapeBorder cardShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),
  );

  // Challenge Title Style
  static const TextStyle challengeTitleStyle = TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.black,
    fontSize: 18,
  );

  // Tag Styles
  static final BoxDecoration tagDecoration = BoxDecoration(
    color: Colors.red,
    borderRadius: BorderRadius.circular(15),
  );

  static const TextStyle tagTextStyle = TextStyle(
    color: Colors.white,
  );

  // Icon Delete Color
  static const Color iconDeleteColor = Colors.grey;
}
