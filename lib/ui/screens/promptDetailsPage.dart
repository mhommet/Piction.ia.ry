import 'package:flutter/material.dart';

class PromptDetailsPage extends StatelessWidget {
  const PromptDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        title: const Text(
          'Une poule sur un mur',
          style: TextStyle(color: Colors.black),
        ),
        leading: const BackButton(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            Container(
              width: double.infinity,
              height: 200,
              color: Colors.grey[300],
              child: const Center(child: Icon(Icons.image)),
            ),
            const SizedBox(height: 16),
            // Prompt utilisé
            const Text(
              'Prompt utilisé',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Le piag ingrédient de base des menus KFC sur des briques empilées',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 16),
            // Propositions faites
            const Text(
              'Propositions faites',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildProposal('Une bête sur un mur', -1),
            const SizedBox(height: 8),
            _buildProposal('Une bête sur un mur', -1),
            const SizedBox(height: 8),
            _buildProposal('Une bête sur un mur', -1),
            const SizedBox(height: 8),
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
        Text(text),
        Text(
          score > 0 ? '+$score' : '$score',
          style: TextStyle(
            color: score > 0 ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
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
