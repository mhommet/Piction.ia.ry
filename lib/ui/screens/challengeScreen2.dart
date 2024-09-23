import 'package:flutter/material.dart';

class ChallengeScreen2 extends StatelessWidget {
  const ChallengeScreen2({super.key});

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
              '232',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Scores des équipes
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(
                        'Equipe bleue',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '89',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        'Equipe rouge',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '93',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
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
            // Propositions des équipiers
            const Text(
              'Les propositions de votre équipier',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Column(
              children: [
                _buildProposalRow('Une', 'bête', 'sur un', 'mur', context),
                const SizedBox(height: 8),
                _buildProposalRow('Une', 'bête', 'sur un', 'mur', context),
                const SizedBox(height: 8),
                _buildProposalRow('Une', 'bête', 'sur un', 'mur', context),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildProposalRow(String firstWord, String secondWord,
      String thirdWord, String fourthWord, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildWordChip(firstWord, Colors.grey[300]!),
        _buildWordChip(secondWord, Colors.red),
        _buildWordChip(thirdWord, Colors.grey[300]!),
        _buildWordChip(fourthWord, Colors.green),
      ],
    );
  }

  Widget _buildWordChip(String word, Color color) {
    return Chip(
      label: Text(word),
      backgroundColor: color,
      labelStyle: const TextStyle(color: Colors.white),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: ChallengeScreen2(),
  ));
}
