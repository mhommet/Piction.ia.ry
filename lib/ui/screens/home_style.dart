import 'package:flutter/material.dart';

class HomeStyle {
  // AppBar styles
  static const TextStyle appBarTitleStyle = TextStyle(
    color: Colors.black, // Titre noir
  );

  // Correct usage of Color.fromARGB instead of Colors.grey[200]
  static const Color appBarBackgroundColor =
      Color.fromARGB(255, 238, 238, 238); // Fond gris clair

  static const IconThemeData appBarIconTheme = IconThemeData(
    color: Colors.black, // Icônes noires
  );

  // Background color for the page
  static const Color pageBackgroundColor =
      Color.fromARGB(255, 245, 245, 245); // Fond harmonisé

  // Welcome text style
  static const TextStyle welcomeTextStyle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w500,
    color: Colors.black, // Texte noir pour contraste
  );

  // Elevated button style
  static ButtonStyle elevatedButtonStyle(Color backgroundColor) {
    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor, // Couleur du bouton
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Bords arrondis
      ),
    );
  }

  // Elevated button text style
  static const TextStyle buttonTextStyle = TextStyle(
    color: Colors.white, // Texte blanc
    fontSize: 16,
  );

  // Icon style for the button
  static const TextStyle buttonIconTextStyle = TextStyle(
    color: Colors.white, // Texte blanc
    fontSize: 16,
  );

  // Space between elements
  static const SizedBox spacing30 = SizedBox(height: 30);
}
