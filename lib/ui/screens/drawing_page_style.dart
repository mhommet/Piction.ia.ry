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
}
