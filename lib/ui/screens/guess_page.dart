import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class GuessPage extends StatefulWidget {
  final int gameSessionId;

  const GuessPage({
    super.key,
    required this.gameSessionId,
  });

  @override
  State<GuessPage> createState() => _GuessPageState();
}

class _GuessPageState extends State<GuessPage> {
  bool isLoading = true;
  List<Map<String, dynamic>> challengesToGuess = [];
  final TextEditingController _guessController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadChallengesToGuess();
  }

  @override
  void dispose() {
    _guessController.dispose();
    super.dispose();
  }

  Future<void> _loadChallengesToGuess() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    if (token == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Token non disponible')),
        );
      }
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('https://pictioniary.wevox.cloud/api/game_sessions/${widget.gameSessionId}/challenges'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> challenges = jsonDecode(response.body);
        setState(() {
          challengesToGuess = List<Map<String, dynamic>>.from(challenges);
          isLoading = false;
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur API : ${response.statusCode}')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Devinez les défis'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: challengesToGuess.length,
          itemBuilder: (context, index) {
            final challenge = challengesToGuess[index];
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (challenge['image_path'] != null)
                      Image.network(
                        challenge['image_path'],
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.contain,
                      ),
                    const SizedBox(height: 16),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Votre proposition',
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (value) {
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
