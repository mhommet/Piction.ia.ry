import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'drawing_page_style.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'guess_page.dart';

class DrawingPage extends StatefulWidget {
  final int gameSessionId;
  
  const DrawingPage({
    super.key,
    required this.gameSessionId
  });

  @override
  State<DrawingPage> createState() => _DrawingPageState();
}

class _DrawingPageState extends State<DrawingPage> {
  bool isLoading = true;
  List<Map<String, dynamic>> myChallenges = [];
  Map<String, dynamic>? currentChallenge;
  String? generatedImage;
  final TextEditingController _promptController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadChallenges();
  }

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  bool _containsForbiddenWord(String prompt) {
    if (currentChallenge == null) return false;
    
    final forbiddenWords = parseForbiddenWords(currentChallenge!['forbidden_words']);
    final promptLower = prompt.toLowerCase();
    
    return forbiddenWords.any((word) => promptLower.contains(word.toLowerCase()));
  }

  Future<void> _generateDrawing() async {
    if (currentChallenge == null) return;

    final prompt = _promptController.text.trim();
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    
    if (prompt.isEmpty) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Veuillez entrer une description')),
      );
      return;
    }

    if (_containsForbiddenWord(prompt)) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('La description contient un mot interdit !')),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');
    
    if (token == null || !mounted) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Token non disponible')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('https://pictioniary.wevox.cloud/api/game_sessions/${widget.gameSessionId}/challenges/${currentChallenge!['id']}/draw'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'prompt': prompt,
        }),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        setState(() {
          generatedImage = jsonResponse['image_path'];
          isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la génération du dessin: ${response.body}')),
        );
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _loadChallenges() async {
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
      final url = Uri.parse(
          'https://pictioniary.wevox.cloud/api/game_sessions/${widget.gameSessionId}/myChallenges');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> challenges = jsonDecode(response.body);
        
        setState(() {
          myChallenges = List<Map<String, dynamic>>.from(challenges);
          if (myChallenges.isNotEmpty) {
            currentChallenge = myChallenges[0];
          }
          isLoading = false;
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur API : ${response.statusCode} - ${response.body}')),
          );
        }
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  List<String> parseForbiddenWords(dynamic forbiddenWords) {
    if (forbiddenWords is String) {
      try {
        final List<dynamic> parsed = jsonDecode(forbiddenWords);
        return parsed.map((word) => word.toString()).toList();
      } catch (e) {
        return [];  // Retour silencieux en cas d'erreur
      }
    } else if (forbiddenWords is List) {
      return forbiddenWords.map((word) => word.toString()).toList();
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Phase de dessin',
          style: DrawingPageStyle.titleStyle,
        ),
        backgroundColor: DrawingPageStyle.appBarBackgroundColor,
        elevation: 0,
        iconTheme: DrawingPageStyle.appBarIconTheme,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (currentChallenge != null) ...[
              const Text(
                'Défi à dessiner:',
                style: DrawingPageStyle.titleStyle,
              ),
              const SizedBox(height: 8),
              Text(
                '${currentChallenge!['first_word']} ${currentChallenge!['second_word']} ${currentChallenge!['third_word']} ${currentChallenge!['fourth_word']} ${currentChallenge!['fifth_word']}',
                style: DrawingPageStyle.challengeTextStyle,
              ),
              const SizedBox(height: 8),
              const Text(
                'Mots interdits:',
                style: DrawingPageStyle.titleStyle,
              ),
              const SizedBox(height: 4),
              Text(
                parseForbiddenWords(currentChallenge!['forbidden_words']).join(', '),
                style: DrawingPageStyle.forbiddenWordsStyle,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _promptController,
                decoration: const InputDecoration(
                  labelText: 'Description pour générer l\'image (sans mots interdits)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: double.infinity),
                child: IntrinsicWidth(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _generateDrawing,
                          child: const Text('Générer le dessin'),
                        ),
                      ),
                      if (generatedImage != null) ...[
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GuessPage(
                                    gameSessionId: widget.gameSessionId,
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                            child: const Text('Valider l\'image'),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (isLoading)
                const Center(child: CircularProgressIndicator())
              else if (generatedImage != null)
                Image.network(
                  generatedImage!,
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                ),
            ],
            
            const SizedBox(height: 16),
            const Text(
              'Mes défis:',
              style: DrawingPageStyle.titleStyle,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: myChallenges.length,
                itemBuilder: (context, index) {
                  final challenge = myChallenges[index];
                  return Card(
                    child: ListTile(
                      title: Text(
                        '${challenge['first_word']} ${challenge['second_word']} ${challenge['third_word']} ${challenge['fourth_word']} ${challenge['fifth_word']}',
                      ),
                      subtitle: Text(
                        'Mots interdits: ${parseForbiddenWords(challenge['forbidden_words']).join(', ')}',
                        style: DrawingPageStyle.forbiddenWordsStyle,
                      ),
                      onTap: () {
                        setState(() {
                          currentChallenge = challenge;
                          generatedImage = null;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

