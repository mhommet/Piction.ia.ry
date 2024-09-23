import 'package:flutter/material.dart';

class ChallengeScreen extends StatelessWidget {
  const ChallengeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100], // Couleur de fond similaire à l'image
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            // Chronomètre
            const Text(
              'Chrono',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text(
              '300',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Challenge
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                children: [
                  Text(
                    'Votre challenge:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'UNE POULE SUR UN MUR',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      Chip(
                        label: Text('Poulet'),
                        backgroundColor: Colors.red,
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      Chip(
                        label: Text('Volaille'),
                        backgroundColor: Colors.red,
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      Chip(
                        label: Text('Oiseau'),
                        backgroundColor: Colors.red,
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Placeholder de l'image
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.grey[300],
              child: const Center(
                child: Text(
                  'Image Placeholder',
                  style: TextStyle(color: Colors.black45, fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Boutons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                Expanded(
                  child: ElevatedButton.icon(
                  onPressed: () {
                    // Action pour régénérer l'image
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Régénérer l\'image (-50pts)'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                  onPressed: () {
                    // Action pour envoyer au devineur
                  },
                  icon: const Icon(Icons.send),
                  label: const Text('Envoyer au devineur'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Description en bas
            const Text(
              'Le piaf ingrédient de base des menus KFC sur des briques empilées',
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            // Bouton de validation en bas
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.purple,
              child: IconButton(
                icon: const Icon(Icons.arrow_upward, color: Colors.white),
                onPressed: () {
                  // Action du bouton
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: ChallengeScreen(),
  ));
}
