import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'drawing_page_style.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

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

  @override
  void initState() {
    super.initState();
    _startRefreshTimer();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DrawingPageStyle.backgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Chrono\n232',
                textAlign: TextAlign.center,
                style: DrawingPageStyle.chronoTextStyle,
              ),
              DrawingPageStyle.spacing50,
              isLoading
                  ? const CircularProgressIndicator(
                      color: DrawingPageStyle.progressIndicatorColor,
                    )
                  : imageBytes != null
                      ? Image.memory(imageBytes!) // Affiche l'image si disponible
                      : const Text(
                          'Erreur : Impossible de charger l\'image',
                          textAlign: TextAlign.center,
                          style: DrawingPageStyle.statusTextStyle,
                        ),
              DrawingPageStyle.spacing20,
              const Text(
                'Votre équipier est en train de dessiner',
                textAlign: TextAlign.center,
                style: DrawingPageStyle.statusTextStyle,
              ),
            ],
          ),
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

