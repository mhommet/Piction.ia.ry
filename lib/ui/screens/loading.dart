import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'challenge_screen.dart'; // Import ChallengeScreen

class Loading extends StatefulWidget {
  final List<Map<String, dynamic>> challenges; // Récupérer les défis

  const Loading({super.key, required this.challenges});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  void initState() {
    super.initState();
    _startLoading();
  }

  void _startLoading() {
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ChallengeScreen(challenges: widget.challenges),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
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
