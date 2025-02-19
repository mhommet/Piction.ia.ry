import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'drawing_page_style.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/drawing_canvas.dart';

class DrawingPage extends StatefulWidget {
  final int gameSessionId;
  
  const DrawingPage({
    required Key key, 
    required this.gameSessionId
  }) : super(key: key);

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
      _fetchDrawing();
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchDrawing() async {
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
          'https://pictioniary.wevox.cloud/api/game_sessions/${widget.gameSessionId}/challenges/3/draw');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'prompt': "Vive le vent d'hivers"}),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final imageBase64 = jsonResponse['image'];

        if (imageBase64 != null) {
          setState(() {
            imageBytes = base64Decode(imageBase64);
            isLoading = false;
          });
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Image non disponible dans la réponse')),
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

    if (!mounted) return;

    try {
      final url = Uri.parse(
          'https://pictioniary.wevox.cloud/api/game_sessions/${widget.gameSessionId}/myChallenges');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        final List<dynamic> challenges = jsonDecode(response.body);
        
        if (challenges.isNotEmpty) {
          setState(() {
            myChallenges = List<Map<String, dynamic>>.from(challenges);
            currentDrawing = myChallenges[0];
            isLoading = false;
          });
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Aucun défi disponible')),
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
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (currentDrawing != null) ...[
              Text(
                'Défi à dessiner:',
                style: DrawingPageStyle.titleStyle,
              ),
              const SizedBox(height: 8),
              Text(
                '${currentDrawing!['challenge']}',
                style: DrawingPageStyle.challengeTextStyle,
              ),
              if (currentDrawing!['forbidden_words'] != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Mots interdits:',
                  style: DrawingPageStyle.titleStyle,
                ),
                const SizedBox(height: 4),
                Text(
                  currentDrawing!['forbidden_words'].join(', '),
                  style: DrawingPageStyle.forbiddenWordsStyle,
                ),
              ],
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
                        'Mots interdits: ${(challenge['forbidden_words'] as List).join(', ')}',
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

