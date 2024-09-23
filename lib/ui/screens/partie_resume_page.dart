import 'package:flutter/material.dart';
import 'partie_resume_page_style.dart';

class PartieResumePage extends StatelessWidget {
  const PartieResumePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PartieResumeStyle.backgroundColor, // Fond gris clair
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            PartieResumeStyle.spacing16,
            // Victoire de l'équipe rouge
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: PartieResumeStyle.victoryBackgroundColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Victoire de l\'équipe ROUGE',
                textAlign: TextAlign.center,
                style: PartieResumeStyle.victoryTextStyle, // Style de victoire
              ),
            ),
            PartieResumeStyle.spacing24,
            // Résumé de la partie des rouges
            const SectionTitle(title: 'Résumé de la partie des rouges'),
            _buildChallengeSummary(context, 'Une poule sur un mur', '+25 / -8'),
            PartieResumeStyle.spacing16,
            _buildChallengeSummary(context, 'Une poule sur un mur', '+25 / -8'),
            PartieResumeStyle.spacing16,
            _buildChallengeSummary(context, 'Une poule sur un mur', '+25 / -8'),
            PartieResumeStyle.spacing24,
            // Résumé de la partie des bleus
            const SectionTitle(title: 'Résumé de la partie des bleus'),
            _buildChallengeSummary(context, 'Une poule sur un mur', '+25 / -8'),
            PartieResumeStyle.spacing16,
            _buildChallengeSummary(context, 'Une poule sur un mur', '+25 / -8'),
            PartieResumeStyle.spacing16,
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
      padding: const EdgeInsets.all(12.0),
      decoration:
          PartieResumeStyle.summaryContainerDecoration, // Style des résumés
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // Image placeholder
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: PartieResumeStyle.placeholderBackgroundColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Icon(Icons.image,
                      color: PartieResumeStyle.placeholderIconColor),
                ),
              ),
              PartieResumeStyle.spacing8,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: PartieResumeStyle
                        .challengeTitleTextStyle, // Style du titre de défi
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
            style: PartieResumeStyle.scoreTextStyle, // Style du score
          ),
          const Icon(Icons.arrow_forward_ios,
              color: PartieResumeStyle.iconColor), // Icône
        ],
      ),
    );
  }

  Widget _buildTag(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: Chip(
        label: Text(
          label,
          style: PartieResumeStyle.tagTextStyle, // Style du texte de tag
        ),
        backgroundColor: PartieResumeStyle.tagBackgroundColor, // Couleur du tag
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
      textAlign: TextAlign.center,
      style:
          PartieResumeStyle.sectionTitleTextStyle, // Style du titre de section
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: PartieResumePage(),
  ));
}
