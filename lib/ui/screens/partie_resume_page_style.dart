import 'package:flutter/material.dart';

class PartieResumeStyle {
  // Background color
  static const Color backgroundColor = Color(0xFFF5F5F5); // Gris clair

  // Victory Container Styles
  static const Color victoryBackgroundColor = Colors.red;
  static const TextStyle victoryTextStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  // Challenge Summary Styles
  static const Color summaryBackgroundColor = Colors.white;
  static const Color summaryShadowColor = Color(0x33000000); // Gris clair ombré

  static const BoxDecoration summaryContainerDecoration = BoxDecoration(
    color: summaryBackgroundColor,
    borderRadius: BorderRadius.all(Radius.circular(10)),
    boxShadow: [
      BoxShadow(
        color: summaryShadowColor,
        spreadRadius: 2,
        blurRadius: 5,
      ),
    ],
  );

  static const TextStyle challengeTitleTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle scoreTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const Color iconColor = Colors.black54;

  // Tag Styles
  static const Color tagBackgroundColor = Colors.red;
  static const TextStyle tagTextStyle = TextStyle(
    color: Colors.white,
  );

  // Section Title Styles
  static const TextStyle sectionTitleTextStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  // Placeholder Styles
  static const Color placeholderBackgroundColor = Color(0xFFBDBDBD); // Gris
  static const Color placeholderIconColor = Colors.black45;

  // Spacing
  static const SizedBox spacing16 = SizedBox(height: 16);
  static const SizedBox spacing24 = SizedBox(height: 24);
  static const SizedBox spacing8 = SizedBox(width: 8);
}
