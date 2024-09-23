import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'challenge_screen.dart'; // Import ChallengeScreen

class Loading extends StatelessWidget {
  final List<Map<String, dynamic>> challenges; // Récupérer les défis

  const Loading({super.key, required this.challenges});

  @override
  Widget build(BuildContext context) {
    // Simuler l'attente de validation
    Future.delayed(const Duration(seconds: 3), () {
      // Une fois l'attente terminée, rediriger vers ChallengeScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ChallengeScreen(challenges: challenges),
        ),
      );
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LoadingAnimationWidget.twistingDots(
              leftDotColor: Colors.red,
              rightDotColor: Colors.blue,
              size: 200,
            ),
            const SizedBox(height: 20),
            const Text(
              "Waiting for other players...",
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
