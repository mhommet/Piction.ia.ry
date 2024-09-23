import 'package:flutter/material.dart';

class QRCodeScannerStyle {
  // AppBar Styles
  static const TextStyle appBarTitleStyle = TextStyle(
    color: Colors.black,
  );

  static const Color appBarBackgroundColor = Color(0xFFE0E0E0); // Gris clair
  static const IconThemeData appBarIconTheme = IconThemeData(
    color: Colors.black,
  );

  // Background color
  static const Color backgroundColor = Color(0xFFF5F5F5); // Gris très clair

  // QR Scanner Overlay
  static const Color overlayBorderColor = Colors.red;
  static const double overlayBorderRadius = 10;
  static const double overlayBorderLength = 30;
  static const double overlayBorderWidth = 10;
  static const double overlayCutOutSize = 300;

  // Text Styles
  static const TextStyle resultTextStyle = TextStyle(
    color: Colors.black,
    fontSize: 16,
  );

  static const TextStyle waitingTextStyle = TextStyle(
    color: Colors.black45,
    fontSize: 16,
  );
}
