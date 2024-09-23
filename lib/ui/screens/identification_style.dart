import 'package:flutter/material.dart';

class IdentificationStyle {
  // AppBar Styles
  static const TextStyle appBarTitleStyle = TextStyle(
    color: Colors.black,
  );

  static const Color appBarBackgroundColor = Color(0xFFE0E0E0); // Gris clair
  static const IconThemeData appBarIconTheme = IconThemeData(
    color: Colors.black,
  );

  // Background Color
  static const Color backgroundColor = Colors.white;

  // Text Styles
  static const TextStyle welcomeTextStyle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w400,
    color: Colors.black,
  );

  static const TextStyle instructionTextStyle = TextStyle(
    color: Colors.black54,
    fontSize: 16,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 16,
  );

  // Input Decoration
  static InputDecoration textFieldDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: const TextStyle(color: Colors.black54),
      filled: true,
      fillColor: Colors.grey[200],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    );
  }

  // Button Style
  static ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.blue,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    padding: const EdgeInsets.symmetric(vertical: 16),
  );

  // Spacing
  static const SizedBox spacing30 = SizedBox(height: 30);
  static const SizedBox spacing20 = SizedBox(height: 20);
}
