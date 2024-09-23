import 'package:flutter/material.dart';

class LoadingStyle {
  // Colors for the loading animation
  static const Color leftDotColor = Colors.red;
  static const Color rightDotColor = Colors.blue;

  // Loading widget size
  static const double loadingWidgetSize = 200;

  // Text Styles
  static const TextStyle waitingTextStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w400,
    color: Colors.black,
  );

  // Spacing
  static const SizedBox spacing20 = SizedBox(height: 20);
}
