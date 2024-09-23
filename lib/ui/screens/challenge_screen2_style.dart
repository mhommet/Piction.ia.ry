import 'package:flutter/material.dart';

class ChallengeScreen2Style {
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

  static const TextStyle teamScoreLabelStyle = TextStyle(
    fontSize: 16,
    color: Colors.black,
  );

  static const TextStyle blueTeamScoreStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.blue,
  );

  static const TextStyle redTeamScoreStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.red,
  );

  static const TextStyle placeholderStyle = TextStyle(
    color: Colors.black45,
    fontSize: 18,
  );

  static const TextStyle proposalTitleStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );

  // Container Decorations
  static BoxDecoration scoresContainerDecoration = BoxDecoration(
    color: Colors.grey[300],
    borderRadius: BorderRadius.circular(8),
  );

  static BoxDecoration placeholderDecoration = BoxDecoration(
    color: Colors.grey[300],
  );

  // Chip Style
  static BoxDecoration chipDecoration(Color color) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(15),
    );
  }

  static const TextStyle chipTextStyle = TextStyle(
    color: Colors.white,
  );
}
