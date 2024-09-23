import 'package:flutter/material.dart';

class GuessPageStyle {
  // Background color
  static const Color backgroundColor = Color(0xFFF5F5F5); // Blanc cassé

  // Text Styles
  static const TextStyle chronoTextStyle = TextStyle(
    color: Colors.black,
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle teamScoreLabelStyle = TextStyle(
    color: Colors.black,
    fontSize: 18,
  );

  static const TextStyle teamScoreBlueStyle = TextStyle(
    color: Colors.blue,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle teamScoreRedStyle = TextStyle(
    color: Colors.red,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle questionTextStyle = TextStyle(
    color: Colors.black,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle errorTextStyle = TextStyle(
    color: Colors.red,
  );

  static const TextStyle hintTextStyle = TextStyle(
    color: Colors.black,
  );

  // Text Field Decoration
  static InputDecoration textFieldDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: Colors.grey[300],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    );
  }

  // Button Style
  static ButtonStyle abandonButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.red,
    padding: const EdgeInsets.symmetric(vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  );

  static const TextStyle abandonButtonTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 16,
  );

  // Spacing
  static const SizedBox spacing10 = SizedBox(height: 10);
  static const SizedBox spacing20 = SizedBox(height: 20);
}
