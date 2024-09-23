import 'package:flutter/material.dart';
import 'challenge_screen2_style.dart';

class ChallengeScreen2 extends StatelessWidget {
  const ChallengeScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ChallengeScreen2Style.backgroundColor, // Fond harmonisé
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            // Chronomètre
            const Text(
              'Chrono',
              style: ChallengeScreen2Style.chronoTitleStyle,
            ),
            const Text(
              '232',
              style: ChallengeScreen2Style.chronoValueStyle,
            ),
            const SizedBox(height: 16),
            // Scores des équipes
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: ChallengeScreen2Style.scoresContainerDecoration,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(
                        'Equipe bleue',
                        style: ChallengeScreen2Style.teamScoreLabelStyle,
                      ),
                      SizedBox(height: 4),
                      Text(
                        '89',
                        style: ChallengeScreen2Style.blueTeamScoreStyle,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        'Equipe rouge',
                        style: ChallengeScreen2Style.teamScoreLabelStyle,
                      ),
                      SizedBox(height: 4),
                      Text(
                        '93',
                        style: ChallengeScreen2Style.redTeamScoreStyle,
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
              decoration: ChallengeScreen2Style.placeholderDecoration,
              child: const Center(
                child: Text(
                  'Image Placeholder',
                  style: ChallengeScreen2Style.placeholderStyle,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Propositions des équipiers
            const Text(
              'Les propositions de votre équipier',
              style: ChallengeScreen2Style.proposalTitleStyle,
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
      labelStyle: ChallengeScreen2Style.chipTextStyle,
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: ChallengeScreen2(),
  ));
}
