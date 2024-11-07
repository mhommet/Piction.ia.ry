import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ionicons/ionicons.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'teams.dart';
import 'qr_code_scanner.dart';

class Home extends StatelessWidget {
  final String username; // Ajouter une variable pour stocker le nom d'utilisateur

  const Home({required Key key, required this.username})
      : super(key: key); // Recevoir le nom d'utilisateur

  // Ajoute le username dans prefs.getString('username')
  Future<void> _saveUsername() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
  }

  // Fonction pour créer une session de jeu
  Future<void> _createGameSession(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');
    // Save the username
    await _saveUsername();

    if (token == null) {
      // Gérer l'absence de token (redirection vers login ou message d'erreur)
      return;
    }

    final url = Uri.parse('https://pictioniary.wevox.cloud/api/game_sessions');

    try {
      // Créer une nouvelle session de jeu
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        final gameSessionId = jsonResponse['id']; // Récupérer l'ID de la session

        // Appeler la fonction pour faire rejoindre le joueur
        print(jsonResponse['id']);
        await _joinGameSession(context, gameSessionId, token);

        // Rediriger vers la page Teams avec l'ID de la session
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Teams(
              username: username,
              gameSessionId: gameSessionId, // Passer l'ID de la session à Teams
            ),
          ),
        );
      } else {
        print('Erreur lors de la création de la session: ${response.body}');
      }
    } catch (e) {
      print('Erreur: $e');
    }
  }

  // Fonction pour rejoindre une session de jeu
  Future<void> _joinGameSession(BuildContext context, int gameSessionId, String token) async {
    final url = Uri.parse('https://pictioniary.wevox.cloud/api/game_sessions/$gameSessionId/join');
    await _saveUsername(); // Sauvegarder le nom d'utilisateur
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print('Joueur rejoint la session avec succès');
      } else {
        print('Erreur lors du join de la session: ${response.body}');
      }
    } catch (e) {
      print('Erreur: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Piction.ia.ry',
          style: TextStyle(color: Colors.black), // Titre noir pour cohérence
        ),
        backgroundColor: Colors.grey[200], // Fond gris clair
        elevation: 0, // Pas d'ombre pour un look plus propre
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.grey[100], // Fond harmonisé avec le style général
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Welcome $username', // Afficher le nom de l'utilisateur
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                  color: Colors.black, // Texte noir pour contraste
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _createGameSession(context); // Appeler la fonction pour créer et rejoindre la session
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // Bouton bleu
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: const Size.fromHeight(60), // Assurer la même taille
                      ),
                      child: const Text(
                        'Nouvelle partie',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const QRCodeScannerPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green, // Bouton vert
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: const Size.fromHeight(60), // Assurer la même taille
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Ionicons.qr_code, color: Colors.white),
                          SizedBox(width: 10),
                          Text(
                            'Rejoindre une partie',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
