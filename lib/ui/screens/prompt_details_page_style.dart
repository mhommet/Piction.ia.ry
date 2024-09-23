import 'package:flutter/material.dart';

class PromptDetailsStyle {
  // AppBar Styles
  static const TextStyle appBarTitleStyle = TextStyle(
    color: Colors.black,
  );

  static const Color appBarBackgroundColor = Color(0xFFE0E0E0); // Gris clair

  // Background Color
  static const Color backgroundColor = Color(0xFFF5F5F5); // Gris très clair

  // Image Placeholder
  static const Color placeholderBackgroundColor =
      Color(0xFFBDBDBD); // Gris moyen
  static const Color placeholderIconColor = Colors.black45;
  static const double placeholderHeight = 200;
  static const double placeholderIconSize = 50;

  // Text Styles
  static const TextStyle promptTitleStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle descriptionTextStyle = TextStyle(
    fontSize: 14,
    color: Colors.black54,
  );

  static const TextStyle proposalTextStyle = TextStyle(
    color: Colors.black,
  );

  static const TextStyle scorePositiveStyle = TextStyle(
    color: Colors.green,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle scoreNegativeStyle = TextStyle(
    color: Colors.red,
    fontWeight: FontWeight.bold,
  );

  // Spacing
  static const SizedBox spacing16 = SizedBox(height: 16);
  static const SizedBox spacing8 = SizedBox(height: 8);
}
