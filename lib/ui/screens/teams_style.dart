import 'package:flutter/material.dart';

class TeamsStyle {
  // AppBar Styles
  static const TextStyle appBarTitleStyle = TextStyle(
    color: Colors.black,
  );

  static const Color appBarBackgroundColor = Color(0xFFE0E0E0); // Gris clair
  static const IconThemeData appBarIconTheme = IconThemeData(
    color: Colors.black,
  );

  // Background color
  static const Color backgroundColor = Color(0xFFF5F5F5); // Gris très clair

  // Team Titles
  static const TextStyle teamTitleBlue = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.blue,
  );

  static const TextStyle teamTitleRed = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.red,
  );

  // Button Styles
  static ButtonStyle teamButtonBlue = ElevatedButton.styleFrom(
    backgroundColor: Colors.blue,
    padding: const EdgeInsets.symmetric(vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  );

  static ButtonStyle teamButtonRed = ElevatedButton.styleFrom(
    backgroundColor: Colors.red,
    padding: const EdgeInsets.symmetric(vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  );

  // Button Text Style
  static const TextStyle buttonTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 16,
  );

  // Info Text Style
  static const TextStyle infoTextStyle = TextStyle(
    color: Colors.black54,
    fontSize: 16,
  );

  // Spacing
  static const SizedBox spacing20 = SizedBox(height: 20);
  static const SizedBox spacing30 = SizedBox(height: 30);
}
