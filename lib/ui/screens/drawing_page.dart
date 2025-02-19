import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'drawing_page_style.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/drawing_canvas.dart';
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
  Uint8List? imageBytes; // Stocker les données de l'image
  bool isLoading = true; // Indicateur de chargement
  Timer? _refreshTimer;
  List<Map<String, dynamic>> myChallenges = [];
  Map<String, dynamic>? currentDrawing;

  @override
  void initState() {
    super.initState();
    _startRefreshTimer();
    _loadChallenges();
  }

  void _startRefreshTimer() {
    // Vérifier l'image toutes les 5 secondes
    _refreshTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
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
            currentDrawing = myChallenges[0];
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

  Future<void> _loadDrawing(int challengeId) async {
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

    if (!mounted) return;

    try {
      final url = Uri.parse(
          'https://pictioniary.wevox.cloud/api/game_sessions/${widget.gameSessionId}/challenges/$challengeId');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final drawing = jsonResponse['drawing'];

        if (drawing != null) {
          setState(() {
            currentDrawing = drawing;
          });
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Dessin non disponible dans la réponse')),
            );
          }
        }
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
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _submitDrawing() async {
    if (currentDrawing == null) return;

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');
    
    if (token == null || !mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Token non disponible')),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('https://pictioniary.wevox.cloud/api/game_sessions/${widget.gameSessionId}/challenges/${currentDrawing!['id']}/draw'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'prompt': '${currentDrawing!['first_word']} ${currentDrawing!['second_word']} ${currentDrawing!['third_word']} ${currentDrawing!['fourth_word']} ${currentDrawing!['fifth_word']}'
        }),
      );

      if (!mounted) return;

      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const GuessPage(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur lors de l\'envoi du dessin')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e')),
      );
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
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Phase de dessin',
          style: DrawingPageStyle.titleStyle,
        ),
        backgroundColor: DrawingPageStyle.appBarBackgroundColor,
        elevation: 0,
        iconTheme: DrawingPageStyle.appBarIconTheme,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadChallenges,
          ),
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _submitDrawing,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (currentDrawing != null) ...[
              const Text(
                'Défi à dessiner:',
                style: DrawingPageStyle.titleStyle,
              ),
              const SizedBox(height: 8),
              Text(
                '${currentDrawing!['first_word']} ${currentDrawing!['second_word']} ${currentDrawing!['third_word']} ${currentDrawing!['fourth_word']} ${currentDrawing!['fifth_word']}',
                style: DrawingPageStyle.challengeTextStyle,
              ),
              const SizedBox(height: 8),
              const Text(
                'Mots interdits:',
                style: DrawingPageStyle.titleStyle,
              ),
              const SizedBox(height: 4),
              Text(
                parseForbiddenWords(currentDrawing!['forbidden_words']).join(', '),
                style: DrawingPageStyle.forbiddenWordsStyle,
              ),
              const SizedBox(height: 16),
              const DrawingCanvas(),
              const SizedBox(height: 16),
            ],
            
            const Text(
              'Mes défis:',
              style: DrawingPageStyle.titleStyle,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: myChallenges.length,
                itemBuilder: (context, index) {
                  final challenge = myChallenges[index];
                  return Card(
                    child: ListTile(
                      title: Text(
                        '${challenge['first_word']} ${challenge['second_word']} ${challenge['third_word']} ${challenge['fourth_word']} ${challenge['fifth_word']}',
                        style: DrawingPageStyle.challengeTextStyle,
                      ),
                      subtitle: Text(
                        'Mots interdits: ${parseForbiddenWords(challenge['forbidden_words']).join(', ')}',
                        style: DrawingPageStyle.forbiddenWordsStyle,
                      ),
                      onTap: () => _loadDrawing(challenge['id']),
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

void main() {
  runApp(const MaterialApp(
    home: DrawingPage(key: Key('drawingPage'), gameSessionId: 3),
  ));
}

