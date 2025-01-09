import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'drawing_page_style.dart';

class DrawingPage extends StatefulWidget {
  const DrawingPage({required Key key}) : super(key: key);

  @override
  State<DrawingPage> createState() => _DrawingPageState();
}

class _DrawingPageState extends State<DrawingPage> {
  Uint8List? imageBytes; // Stocker les données de l'image
  bool isLoading = true; // Indicateur de chargement

  @override
  void initState() {
    super.initState();
    _fetchDrawing(); // Lancer la requête API au démarrage
  }

  Future<void> _fetchDrawing() async {
    final String token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6MTAsIm5hbWUiOiJBbWFuZGluZSJ9.Rh7psY5manOCnWqvcdOV6o8EWohCzwVME7z2KFFjPfU";

    print('Récupération du dessin en cours...');
    final url = Uri.parse(
        'http://localhost:8000/api/game_sessions/3/challenges/3/draw');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'prompt': "Vive le vent d'hivers"}),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final imageBase64 = jsonResponse['image']; // Récupérer l'image en base64

        if (imageBase64 != null) {
          setState(() {
            imageBytes = base64Decode(imageBase64); // Décoder en Uint8List
            isLoading = false;
          });
        } else {
          throw Exception('Image non disponible dans la réponse');
        }
      } else {
        throw Exception('Erreur API : ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Erreur lors de la récupération du dessin : $e');
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
    home: DrawingPage(key: Key('drawingPage')),
  ));
}

