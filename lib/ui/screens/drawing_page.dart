import 'package:flutter/material.dart';
import 'drawing_page_style.dart';

class DrawingPage extends StatelessWidget {
  const DrawingPage({required Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: DrawingPageStyle.backgroundColor, // Fond blanc
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Chrono\n232',
                textAlign: TextAlign.center,
                style: DrawingPageStyle
                    .chronoTextStyle, // Utilisation du style chrono
              ),
              DrawingPageStyle.spacing50, // Utilisation de l'espacement
              CircularProgressIndicator(
                color: DrawingPageStyle
                    .progressIndicatorColor, // Style de l'indicateur
              ),
              DrawingPageStyle.spacing20, // Utilisation de l'espacement
              Text(
                'Votre équipier est en train de dessiner',
                textAlign: TextAlign.center, // Centré pour meilleure lisibilité
                style: DrawingPageStyle
                    .statusTextStyle, // Utilisation du style du texte de statut
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: DrawingPage(key: Key('drawingPage')),
  ));
}
