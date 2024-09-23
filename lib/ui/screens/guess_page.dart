import 'package:flutter/material.dart';
import 'guess_page_style.dart';

class GuessPage extends StatelessWidget {
  const GuessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GuessPageStyle.backgroundColor, // Fond blanc cassé
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            const Text(
              'Chrono\n232',
              textAlign: TextAlign.center,
              style: GuessPageStyle.chronoTextStyle, // Style chrono
            ),
            GuessPageStyle.spacing10,
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  children: [
                    Text('Equipe bleue',
                        style: GuessPageStyle.teamScoreLabelStyle),
                    Text('89',
                        style: GuessPageStyle
                            .teamScoreBlueStyle), // Style score équipe bleue
                  ],
                ),
                Column(
                  children: [
                    Text('Equipe rouge',
                        style: GuessPageStyle.teamScoreLabelStyle),
                    Text('93',
                        style: GuessPageStyle
                            .teamScoreRedStyle), // Style score équipe rouge
                  ],
                ),
              ],
            ),
            GuessPageStyle.spacing20,
            const Text(
              'Qu\'as dessiné votre équipier?',
              style: GuessPageStyle.questionTextStyle, // Style question
            ),
            GuessPageStyle.spacing10,
            // Placeholder with spinner while loading the image
            Expanded(
              child: Center(
                child: Image.network(
                  'https://placeholder.image/link_to_image.png', // Replace with your image URL
                  height: 200,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return SizedBox(
                        height: 200,
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    (loadingProgress.expectedTotalBytes ?? 1)
                                : null,
                          ),
                        ),
                      );
                    }
                  },
                  errorBuilder: (BuildContext context, Object error,
                      StackTrace? stackTrace) {
                    return const Text(
                      'Erreur lors du chargement de l\'image',
                      style: GuessPageStyle.errorTextStyle, // Style d'erreur
                    );
                  },
                ),
              ),
            ),
            GuessPageStyle.spacing20,
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: GuessPageStyle.textFieldDecoration('mot 1'),
                  ),
                ),
                const SizedBox(width: 10),
                const Text('sur un', style: GuessPageStyle.hintTextStyle),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    decoration: GuessPageStyle.textFieldDecoration('mot 2'),
                  ),
                ),
              ],
            ),
            GuessPageStyle.spacing20,
            ElevatedButton(
              onPressed: () {},
              style: GuessPageStyle.abandonButtonStyle, // Style bouton abandon
              child: const Text(
                'Abandonner et devenir dessinateur',
                style:
                    GuessPageStyle.abandonButtonTextStyle, // Style texte bouton
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: GuessPage(),
  ));
}
