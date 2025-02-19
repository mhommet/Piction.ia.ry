import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'challenge_input_style.dart';
import 'loading.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChallengeInputPage extends StatefulWidget {
  final int gameSessionId;

  const ChallengeInputPage({super.key, required this.gameSessionId});

  @override
  _ChallengeInputPageState createState() => _ChallengeInputPageState();
}

class _ChallengeInputPageState extends State<ChallengeInputPage> {
  List<Map<String, dynamic>> challenges = [];
  String firstWord = 'une';
  String thirdWord = 'sur';

  Future<void> submitChallenges() async {
    final started = await _startChallengeMode();
    if (!started) {
      print('Échec du démarrage du mode challenge');
      return;
    }
    final url = Uri.parse(
        'https://pictioniary.wevox.cloud/api/game_sessions/${widget.gameSessionId}/challenges');
    final token = await getToken();

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Token d'authentification non disponible.")),
      );
      return;
    }

    for (var challenge in challenges) {
      try {
        print("Request URI: $url");
        print("Request Body: ${jsonEncode(challenge)}");

        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(challenge),
        );

        if (response.statusCode == 200) {
          print("Défi ajouté avec succès");
        } else {
          print("Status Code: ${response.statusCode}");
          print("Response Body: ${response.body}");

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Erreur API : ${response.statusCode}\n${response.body}',
              ),
            ),
          );
        }
      } catch (e) {
        print("Erreur lors de l'envoi de la requête : $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur de connexion : $e')),
        );
      }
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Loading(challenges: challenges),
      ),
    );
  }

  Future<bool> _startChallengeMode() async {
    final url = Uri.parse('https://pictioniary.wevox.cloud/api/game_sessions/${widget.gameSessionId}/start');
    final token = await getToken();

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Token d'authentification non disponible.")),
      );
      return false;
    }

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print("Mode challenge démarré avec succès");
        return true;
      } else {
        print("Erreur lors du démarrage du mode challenge: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur API : ${response.statusCode}\n${response.body}')),
        );
      }
    } catch (e) {
      print("Erreur lors de l'envoi de la requête : $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur de connexion : $e')),
      );
      return false;
    }
    return false;
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }

  void _openAddChallengeModal(BuildContext context) {
    String secondWord = '';
    String fourthWord = 'un';
    String fifthWord = '';
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
                          backgroundColor: firstWord == 'une'
                              ? Colors.blue
                              : Colors.grey[300],
                        ),
                        onPressed: () {
                          setModalState(() {
                            firstWord = 'une';
                          });
                        },
                        child: const Text('Une'),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: firstWord == 'un'
                              ? Colors.blue
                              : Colors.grey[300],
                        ),
                        onPressed: () {
                          setModalState(() {
                            firstWord = 'un';
                          });
                        },
                        child: const Text('Un'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    decoration:
                        const InputDecoration(hintText: 'Mot 1 (ex. poule)'),
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
                          backgroundColor: thirdWord == 'sur'
                              ? Colors.blue
                              : Colors.grey[300],
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
                          backgroundColor: thirdWord == 'dans'
                              ? Colors.blue
                              : Colors.grey[300],
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
                    decoration:
                        const InputDecoration(hintText: 'Mot 2 (ex. un)'),
                    onChanged: (value) {
                      fourthWord = value;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    decoration:
                        const InputDecoration(hintText: 'Mot 3 (ex. mur)'),
                    onChanged: (value) {
                      fifthWord = value;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    decoration:
                        const InputDecoration(labelText: 'Mot interdit'),
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
                    child: const Text('Ajouter Mot Interdit'),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children:
                        tags.map((tag) => Chip(label: Text(tag))).toList(),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (secondWord.isEmpty ||
                          fourthWord.isEmpty ||
                          fifthWord.isEmpty ||
                          tags.length != 3) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Veuillez remplir tous les champs et ajouter 3 mots interdits.')),
                        );
                        return;
                      }

                      setState(() {
                        challenges.add({
                          'first_word': firstWord,
                          'second_word': secondWord,
                          'third_word': thirdWord,
                          'fourth_word': fourthWord,
                          'fifth_word': fifthWord,
                          'forbidden_words': tags,
                        });
                      });

                      Navigator.of(context).pop();
                    },
                    child: const Text('Ajouter Défi'),
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
            onPressed: submitChallenges,
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
                  return _buildChallengeCard(index, challenge);
                },
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: submitChallenges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 126, 255, 130),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Valider et envoyer',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChallengeCard(int index, Map<String, dynamic> challenge) {
    return Card(
      margin: ChallengeInputStyle.cardMargin,
      shape: ChallengeInputStyle.cardShape,
      elevation: 3,
      child: Padding(
        padding: ChallengeInputStyle.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${challenge['first_word']} ${challenge['second_word']} ${challenge['third_word']} ${challenge['fourth_word']} ${challenge['fifth_word']}',
              style: ChallengeInputStyle.challengeTitleStyle,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: challenge['forbidden_words']
                  .map<Widget>((tag) => Chip(label: Text(tag)))
                  .toList(),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.delete,
                    color: ChallengeInputStyle.iconDeleteColor),
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
