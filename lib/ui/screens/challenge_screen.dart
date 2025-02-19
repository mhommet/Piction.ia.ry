import 'package:flutter/material.dart';
import 'challenge_screen_style.dart';

class ChallengeScreen extends StatefulWidget {
  final List<Map<String, dynamic>> challenges; // Récupération des défis

  const ChallengeScreen({super.key, required this.challenges});

  @override
  State<ChallengeScreen> createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> {
  String? generatedImageUrl; // URL de l'image générée
  bool isLoading =
      false; // Pour indiquer que l'image est en cours de génération

  // Méthode pour générer l'image via l'API de Stable Diffusion
  Future<void> generateImage() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
    });

    try {
      final prompt = widget.challenges.isNotEmpty
          ? '${widget.challenges[0]['first_word']} ${widget.challenges[0]['second_word']} ${widget.challenges[0]['third_word']} ${widget.challenges[0]['fourth_word']} ${widget.challenges[0]['fifth_word']}'
          : 'Une poule sur un mur';

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Génération de l\'image pour: $prompt')),
      );

      // Simuler l'appel API pour l'instant
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentChallenge =
        widget.challenges.isNotEmpty ? widget.challenges[0] : null;
    final challengeTitle = currentChallenge?['title'] ?? 'Pas de défi';
    final tags = currentChallenge?['tags'] ?? [];

    return Scaffold(
      backgroundColor: ChallengeScreenStyle.backgroundColor, // Fond harmonisé
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            // Chronomètre
            const Text(
              'Chrono',
              style: ChallengeScreenStyle.chronoTitleStyle,
            ),
            const Text(
              '300',
              style: ChallengeScreenStyle.chronoValueStyle,
            ),
            const SizedBox(height: 16),
            // Challenge
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: ChallengeScreenStyle.challengeContainerDecoration,
              child: Column(
                children: [
                  const Text(
                    'Votre challenge:',
                    style: ChallengeScreenStyle.challengeLabelStyle,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    challengeTitle,
                    style: ChallengeScreenStyle.challengeTitleStyle,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: tags.map<Widget>((tag) {
                      return Chip(
                        label: Text(tag),
                        backgroundColor:
                            ChallengeScreenStyle.chipBackgroundColor,
                        labelStyle: ChallengeScreenStyle.chipLabelStyle,
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Placeholder de l'image ou l'image générée
            Container(
              height: 200,
              width: double.infinity,
              decoration: ChallengeScreenStyle.placeholderDecoration,
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : generatedImageUrl != null
                      ? Image.network(
                          generatedImageUrl!) // Affichage de l'image générée
                      : const Center(
                          child: Text(
                            'Image Placeholder',
                            style: ChallengeScreenStyle.placeholderStyle,
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
                    onPressed: generateImage, // Appel de la génération d'image
                    icon: const Icon(Icons.refresh),
                    label: const Text('Régénérer l\'image (-50pts)'),
                    style:
                        ChallengeScreenStyle.elevatedButtonStyle(Colors.blue),
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
                    style:
                        ChallengeScreenStyle.elevatedButtonStyle(Colors.green),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Description en bas
            const TextField(
              decoration: InputDecoration(
                labelText: 'Description',
                labelStyle: ChallengeScreenStyle.descriptionStyle,
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            // Bouton de validation en bas
            CircleAvatar(
              radius: 30,
              backgroundColor: ChallengeScreenStyle.circleAvatarBackgroundColor,
              child: IconButton(
                icon: const Icon(Icons.arrow_upward,
                    color: ChallengeScreenStyle.iconColor),
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
