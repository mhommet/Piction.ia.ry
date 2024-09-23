import 'package:flutter/material.dart';
import 'prompt_details_page_style.dart';

class PromptDetailsPage extends StatelessWidget {
  const PromptDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PromptDetailsStyle.backgroundColor, // Fond gris clair
      appBar: AppBar(
        backgroundColor:
            PromptDetailsStyle.appBarBackgroundColor, // Fond gris clair
        title: const Text(
          'Une poule sur un mur',
          style:
              PromptDetailsStyle.appBarTitleStyle, // Style du titre de l'AppBar
        ),
        leading: const BackButton(color: Colors.black),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            Container(
              width: double.infinity,
              height: PromptDetailsStyle.placeholderHeight,
              decoration: BoxDecoration(
                color: PromptDetailsStyle.placeholderBackgroundColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Icon(
                  Icons.image,
                  size: PromptDetailsStyle.placeholderIconSize,
                  color: PromptDetailsStyle.placeholderIconColor,
                ),
              ),
            ),
            PromptDetailsStyle.spacing16,
            // Prompt utilisé
            const Text(
              'Prompt utilisé',
              style: PromptDetailsStyle.promptTitleStyle, // Style du titre
            ),
            PromptDetailsStyle.spacing8,
            const Text(
              'Le piag ingrédient de base des menus KFC sur des briques empilées',
              style: PromptDetailsStyle
                  .descriptionTextStyle, // Style de description
            ),
            PromptDetailsStyle.spacing16,
            // Propositions faites
            const Text(
              'Propositions faites',
              style:
                  PromptDetailsStyle.promptTitleStyle, // Style des propositions
            ),
            PromptDetailsStyle.spacing8,
            _buildProposal('Une bête sur un mur', -1),
            PromptDetailsStyle.spacing8,
            _buildProposal('Une bête sur un mur', -1),
            PromptDetailsStyle.spacing8,
            _buildProposal('Une bête sur un mur', -1),
            PromptDetailsStyle.spacing8,
            _buildProposal('Une poule sur un mur', 25),
          ],
        ),
      ),
    );
  }

  Widget _buildProposal(String text, int score) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: PromptDetailsStyle
              .proposalTextStyle, // Style du texte des propositions
        ),
        Text(
          score > 0 ? '+$score' : '$score',
          style: score > 0
              ? PromptDetailsStyle
                  .scorePositiveStyle // Style pour les scores positifs
              : PromptDetailsStyle
                  .scoreNegativeStyle, // Style pour les scores négatifs
        ),
      ],
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: PromptDetailsPage(),
  ));
}
