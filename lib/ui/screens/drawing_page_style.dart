import 'package:flutter/material.dart';

class DrawingPageStyle {
  // Background color
  static const Color backgroundColor = Colors.white;

  // Text Styles
  static const TextStyle chronoTextStyle = TextStyle(
    color: Colors.black, // Texte noir pour le contraste avec le fond blanc
    fontSize: 24,
    fontWeight: FontWeight.bold, // Gras pour plus de visibilité
  );

  static const TextStyle statusTextStyle = TextStyle(
    color: Colors.black, // Texte noir pour cohérence avec le fond blanc
    fontSize: 18,
    fontWeight: FontWeight.w400, // Style légèrement plus léger
  );

  // Circular Progress Indicator Style
  static const Color progressIndicatorColor =
      Colors.blue; // Bleu pour correspondre à l'esthétique générale

  // Spacing
  static const SizedBox spacing50 = SizedBox(height: 50);
  static const SizedBox spacing20 = SizedBox(height: 20);

  static const TextStyle titleStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );

  static const TextStyle challengeTextStyle = TextStyle(
    fontSize: 18,
    color: Colors.black87,
  );

  static const TextStyle forbiddenWordsStyle = TextStyle(
    fontSize: 16,
    color: Colors.red,
    fontWeight: FontWeight.w500,
  );

  static const Color canvasBackgroundColor = Colors.white;
  static const Color canvasBorderColor = Colors.grey;
  static const double canvasBorderWidth = 2.0;

  static const Color drawingColor = Colors.black;
  static const double strokeWidth = 3.0;

  static const Color appBarBackgroundColor = Colors.white;
  static final IconThemeData appBarIconTheme = IconThemeData(
    color: Colors.blue.shade700,
  );
}
