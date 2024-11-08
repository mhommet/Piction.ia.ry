import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'challenge_input_style.dart';
import 'loading.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChallengeInputPage extends StatefulWidget {
  final int gameSessionId; // Recevoir l'ID de la session de jeu

  const ChallengeInputPage({super.key, required this.gameSessionId});

  @override
  _ChallengeInputPageState createState() => _ChallengeInputPageState();
}

class _ChallengeInputPageState extends State<ChallengeInputPage> {
  List<Map<String, dynamic>> challenges = [];
  String firstWord = 'Un';
  String thirdWord = 'sur';

  // Méthode pour envoyer les défis à la session
  Future<void> submitChallenges() async {
    final url = Uri.parse('https://pictioniary.wevox.cloud/api/game_sessions/${widget.gameSessionId}/challenges');
    final token = await getToken(); // Récupérer le token d'authentification

    for (var challenge in challenges) {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'first_word': challenge['first_word'],
          'second_word': challenge['second_word'],
          'third_word': challenge['third_word'],
          'fourth_word': challenge['fourth_word'],
          'forbidden_words': challenge['tags'],
        }),
      );

      if (response.statusCode == 200) {
        print("Défi ajouté avec succès");
      } else {
        print("Erreur lors de l'ajout du défi: ${response.body}");
      }
    }

    // Naviguer vers la page de loading
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Loading(challenges: challenges),
      ),
    );
  }

  // Récupérer le token d'authentification
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }

  void _openAddChallengeModal(BuildContext context) {
    String secondWord = '';
    String fourthWord = '';
    List<String> tags = [];
    String currentTag = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: firstWord == 'Un' ? Colors.blue : Colors.grey[300],
                        ),
                        onPressed: () {
                          setModalState(() {
                            firstWord = 'Un';
                          });
                        },
                        child: const Text('Un'),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: firstWord == 'Une' ? Colors.blue : Colors.grey[300],
                        ),
                        onPressed: () {
                          setModalState(() {
                            firstWord = 'Une';
                          });
                        },
                        child: const Text('Une'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    decoration: const InputDecoration(hintText: 'Mot 1'),
                    onChanged: (value) {
                      secondWord = value;
                    },
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: thirdWord == 'sur' ? Colors.blue : Colors.grey[300],
                        ),
                        onPressed: () {
                          setModalState(() {
                            thirdWord = 'sur';
                          });
                        },
                        child: const Text('sur'),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: thirdWord == 'dans' ? Colors.blue : Colors.grey[300],
                        ),
                        onPressed: () {
                          setModalState(() {
                            thirdWord = 'dans';
                          });
                        },
                        child: const Text('dans'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    decoration: const InputDecoration(hintText: 'Mot 2'),
                    onChanged: (value) {
                      fourthWord = value;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Tag'),
                    onChanged: (value) {
                      currentTag = value;
                    },
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (currentTag.isNotEmpty) {
                        setModalState(() {
                          tags.add(currentTag);
                          currentTag = '';
                        });
                      }
                    },
                    child: const Text('Ajouter Tag'),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: tags.map((tag) => Chip(label: Text(tag))).toList(),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (secondWord.isNotEmpty && fourthWord.isNotEmpty && tags.isNotEmpty) {
                        String challengeTitle = '$firstWord $secondWord $thirdWord $fourthWord';
                        setState(() {
                          challenges.add({
                            'first_word': firstWord.toLowerCase(),
                            'second_word': secondWord,
                            'third_word': thirdWord,
                            'fourth_word': fourthWord,
                            'tags': tags
                          });
                        });
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('Ajouter'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Saisie des challenges',
          style: ChallengeInputStyle.appBarTitleStyle,
        ),
        backgroundColor: ChallengeInputStyle.appBarBackgroundColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.send, color: Colors.blue),
            onPressed: submitChallenges, // Envoyer les défis à la session
          ),
        ],
        elevation: 0,
        iconTheme: ChallengeInputStyle.appBarIconTheme,
      ),
      backgroundColor: ChallengeInputStyle.pageBackgroundColor,
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 70),
        child: FloatingActionButton(
          onPressed: () {
            _openAddChallengeModal(context);
          },
          backgroundColor: const Color.fromARGB(255, 121, 195, 255),
          child: const Icon(Icons.add),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: challenges.length,
                itemBuilder: (context, index) {
                  final challenge = challenges[index];
                  return _buildChallengeCard(index, challenge['title'], challenge['tags']);
                },
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: submitChallenges, // Envoyer les défis
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 126, 255, 130),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Valider et continuer',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChallengeCard(int index, String title, List<String> tags) {
    return Card(
      margin: ChallengeInputStyle.cardMargin,
      shape: ChallengeInputStyle.cardShape,
      elevation: 3,
      child: Padding(
        padding: ChallengeInputStyle.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: ChallengeInputStyle.challengeTitleStyle),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: tags.map((tag) => _ChallengeTag(label: tag)).toList(),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.delete, color: ChallengeInputStyle.iconDeleteColor),
                onPressed: () {
                  setState(() {
                    challenges.removeAt(index);
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChallengeTag extends StatelessWidget {
  final String label;

  const _ChallengeTag({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: ChallengeInputStyle.tagDecoration,
      child: Text(label, style: ChallengeInputStyle.tagTextStyle),
    );
  }
}
