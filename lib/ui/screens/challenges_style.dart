import 'package:flutter/material.dart';

class ChallengesStyle {
  // AppBar Style
  static const TextStyle appBarTitleStyle = TextStyle(
    color: Colors.black,
  );

  static const Color appBarBackgroundColor = Color(0xFFEEEEEE); // Gris clair
  static const IconThemeData appBarIconTheme = IconThemeData(
    color: Colors.blue,
  );

  static const Color pageBackgroundColor = Color(0xFFF5F5F5); // Fond gris clair

  // CircleAvatar Style
  static const Color addChallengeButtonColor = Colors.blue;
  static const Color addChallengeIconColor = Colors.white;

  // Card Style
  static const EdgeInsets cardPadding = EdgeInsets.all(16.0);
  static const ShapeBorder cardShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(10)),
  );

  static const TextStyle challengeTitleStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 18,
    color: Colors.black,
  );

  static const TextStyle challengeDescriptionStyle = TextStyle(
    color: Colors.black54,
  );

  // Chip Style
  static const Color chipBackgroundColor = Colors.red;
  static const TextStyle chipTextStyle = TextStyle(
    color: Colors.white,
  );

  // Icon Style
  static const Color iconDeleteColor = Colors.grey;

  // Button Style
  static ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.blue,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  );
}
