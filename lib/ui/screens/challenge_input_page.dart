import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'challenge_input_style.dart';
import 'loading.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'drawing_page.dart';

class ChallengeInputPage extends StatefulWidget {
  final int gameSessionId;

  const ChallengeInputPage({super.key, required this.gameSessionId});

  @override
  State<ChallengeInputPage> createState() => _ChallengeInputPageState();
}

class _ChallengeInputPageState extends State<ChallengeInputPage> {
  List<Map<String, dynamic>> challenges = [];  // Liste locale des défis
  String firstWord = 'une';
  String thirdWord = 'sur';

  Future<void> submitChallenges() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    
    if (!mounted) return;

    final token = await getToken();
    if (token == null) {
      if (!mounted) return;
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text("Token d'authentification non disponible.")),
      );
      return;
    }

    // D'abord envoyer tous les défis à l'API
    for (var challenge in challenges) {
      try {
        await http.post(
          Uri.parse('https://pictioniary.wevox.cloud/api/game_sessions/${widget.gameSessionId}/challenges'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(challenge),
        );
      } catch (e) {
        // Ignorer les erreurs car les défis sont probablement déjà envoyés
      }
    }

    // Ensuite passer en mode drawing
    try {
      await http.post(
        Uri.parse('https://pictioniary.wevox.cloud/api/game_sessions/${widget.gameSessionId}/start'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (!mounted) return;
      
      // Passer à la page de dessin
      navigator.pushReplacement(
        MaterialPageRoute(
          builder: (context) => Loading(challenges: challenges),
        ),
      );
    } catch (e) {
      // Ignorer l'erreur car on est probablement déjà en mode drawing
      if (!mounted) return;
      navigator.pushReplacement(
        MaterialPageRoute(
          builder: (context) => Loading(challenges: challenges),
        ),
      );
    }
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');
    return token;
  }

  void _openAddChallengeModal(BuildContext modalContext) {
    String secondWord = '';
    String fourthWord = 'un';
    String fifthWord = '';
    List<String> tags = [];
    String currentTag = '';

    showModalBottomSheet(
      context: modalContext,
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
                    onPressed: () async {
                      if (secondWord.isEmpty ||
                          fourthWord.isEmpty ||
                          fifthWord.isEmpty ||
                          tags.length != 3) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Veuillez remplir tous les champs et ajouter 3 mots interdits.'),
                          ),
                        );
                        return;
                      }

                      // Capture les références avant les opérations asynchrones
                      final scaffoldMessenger = ScaffoldMessenger.of(context);
                      final navigator = Navigator.of(context);
                      final challenge = {
                        'first_word': firstWord,
                        'second_word': secondWord,
                        'third_word': thirdWord,
                        'fourth_word': fourthWord,
                        'fifth_word': fifthWord,
                        'forbidden_words': tags,
                      };

                      final token = await getToken();
                      if (token == null || !mounted) {
                        scaffoldMessenger.showSnackBar(
                          const SnackBar(content: Text("Token d'authentification non disponible")),
                        );
                        return;
                      }

                      try {
                        final response = await http.post(
                          Uri.parse('https://pictioniary.wevox.cloud/api/game_sessions/${widget.gameSessionId}/challenges'),
                          headers: {
                            'Content-Type': 'application/json',
                            'Authorization': 'Bearer $token',
                          },
                          body: jsonEncode(challenge),
                        );

                        if (!mounted) return;

                        if (response.statusCode == 200 || response.statusCode == 201) {
                          setState(() {
                            challenges.add(challenge);
                          });
                          navigator.pop();

                          if (challenges.length >= 3) {
                            navigator.pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => DrawingPage(
                                  gameSessionId: widget.gameSessionId,
                                ),
                              ),
                            );
                          } else {
                            scaffoldMessenger.showSnackBar(
                              SnackBar(
                                content: Text('Défi ajouté ! Il reste ${3 - challenges.length} défi(s) à ajouter.'),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          }
                        } else {
                          scaffoldMessenger.showSnackBar(
                            const SnackBar(content: Text('Erreur lors de l\'ajout du défi')),
                          );
                        }
                      } catch (e) {
                        if (!mounted) return;
                        scaffoldMessenger.showSnackBar(
                          SnackBar(content: Text('Erreur de connexion: $e')),
                        );
                      }
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
              child: ListView(
                children: [
                  // Afficher les défis de la session
                  ...challenges.map((challenge) => Card(
                    // Afficher le défi en lecture seule
                    child: ListTile(
                      title: Text('${challenge['first_word']} ${challenge['second_word']} ${challenge['third_word']} ${challenge['fourth_word']} ${challenge['fifth_word']}'),
                      subtitle: Wrap(
                        spacing: 8,
                        children: (challenge['forbidden_words'] as List)
                            .map<Widget>((tag) => Chip(label: Text(tag.toString())))
                            .toList(),
                      ),
                    ),
                  )),
                ],
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
}
