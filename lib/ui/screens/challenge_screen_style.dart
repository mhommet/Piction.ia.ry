import 'package:flutter/material.dart';

class ChallengeScreenStyle {
  // Background Color
  static const Color backgroundColor = Color(0xFFF5F5F5); // Gris clair

  // Text Styles
  static const TextStyle chronoTitleStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle chronoValueStyle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle challengeLabelStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );

  static const TextStyle challengeTitleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle chipLabelStyle = TextStyle(color: Colors.white);

  static const TextStyle descriptionStyle = TextStyle(
    fontSize: 14,
    color: Colors.black54,
  );

  static const TextStyle placeholderStyle = TextStyle(
    color: Colors.black45,
    fontSize: 18,
  );

  // Container Decoration
  static BoxDecoration challengeContainerDecoration = BoxDecoration(
    color: Colors.grey[300], // Gris clair
    borderRadius: BorderRadius.circular(8),
  );

  static BoxDecoration placeholderDecoration = BoxDecoration(
    color: Colors.grey[300],
  );

  // Button Styles
  static ButtonStyle elevatedButtonStyle(Color backgroundColor) {
    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  // Chip Style
  static const Color chipBackgroundColor = Colors.red;

  static BoxDecoration chipDecoration = BoxDecoration(
    color: chipBackgroundColor,
    borderRadius: BorderRadius.circular(15),
  );

  // Icon Button Style
  static const Color circleAvatarBackgroundColor = Colors.blue;
  static const Color iconColor = Colors.white;
}
