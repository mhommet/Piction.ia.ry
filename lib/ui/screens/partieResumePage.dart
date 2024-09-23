import 'package:flutter/material.dart';

class PartieResumePage extends StatelessWidget {
  const PartieResumePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red, // Couleur de fond rouge pour l'équipe
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            // Victoire de l'équipe rouge
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Victoire de l\'équipe ROUGE',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Résumé de la partie des rouges
            const SectionTitle(title: 'Résumé de la partie des rouges'),
            _buildChallengeSummary(context, 'Une poule sur un mur', '+25 / -8'),
            const SizedBox(height: 16),
            _buildChallengeSummary(context, 'Une poule sur un mur', '+25 / -8'),
            const SizedBox(height: 16),
            _buildChallengeSummary(context, 'Une poule sur un mur', '+25 / -8'),
            const SizedBox(height: 24),
            // Résumé de la partie des bleus
            const SectionTitle(title: 'Résumé de la partie des bleus'),
            _buildChallengeSummary(context, 'Une poule sur un mur', '+25 / -8'),
            const SizedBox(height: 16),
            _buildChallengeSummary(context, 'Une poule sur un mur', '+25 / -8'),
            const SizedBox(height: 16),
            _buildChallengeSummary(context, 'Une poule sur un mur', '+25 / -8'),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildChallengeSummary(
      BuildContext context, String title, String score) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // Image placeholder
              Container(
                width: 50,
                height: 50,
                color: Colors.grey[300],
                child: const Center(child: Icon(Icons.image)),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      _buildTag('Poulet'),
                      _buildTag('Volaille'),
                      _buildTag('Oiseau'),
                    ],
                  ),
                ],
              ),
            ],
          ),
          // Score
          Text(
            score,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const Icon(Icons.arrow_forward_ios),
        ],
      ),
    );
  }

  Widget _buildTag(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: Chip(
        label: Text(label),
        backgroundColor: Colors.red,
        labelStyle: const TextStyle(color: Colors.white),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
