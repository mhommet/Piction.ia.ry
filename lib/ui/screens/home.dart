import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ionicons/ionicons.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'teams.dart';
import 'qr_code_scanner.dart';

class Home extends StatelessWidget {
  final String username;

  const Home({required Key key, required this.username})
      : super(key: key);

  Future<void> _saveUsername() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
  }

  Future<void> _createGameSession(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');
    await _saveUsername();

    if (token == null) {
      return;
    }

    final url = Uri.parse('https://pictioniary.wevox.cloud/api/game_sessions');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        final gameSessionId = jsonResponse['id'];
        await _joinGameSession(context, gameSessionId, token);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Teams(
              username: username,
              gameSessionId: gameSessionId,
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

  Future<void> _joinGameSession(BuildContext context, int gameSessionId, String token) async {
    await _saveUsername();
    final sessionUrl = Uri.parse('https://pictioniary.wevox.cloud/api/game_sessions/$gameSessionId');

    try {
      // Récupérer les informations de session pour déterminer l'équipe
      final sessionResponse = await http.get(
        sessionUrl,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (sessionResponse.statusCode == 200) {
        final sessionData = jsonDecode(sessionResponse.body);
        String color;

        // Choisir l'équipe avec de la place
        if ((sessionData['blue_team'] as List).length < 2) {
          color = "blue";
        } else {
          color = "red";
        }

        // Requête pour rejoindre la session avec la couleur choisie
        final joinUrl = Uri.parse('https://pictioniary.wevox.cloud/api/game_sessions/$gameSessionId/join');
        final joinResponse = await http.post(
          joinUrl,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({'color': color}),
        );

        if (joinResponse.statusCode == 200) {
          print('Joueur rejoint la session avec succès dans l\'équipe $color');
        } else {
          print('Erreur lors du join de la session: ${joinResponse.body}');
        }
      } else {
        print('Erreur lors de la récupération des données de session: ${sessionResponse.body}');
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
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.grey[200],
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Welcome $username',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _createGameSession(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: const Size.fromHeight(60),
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
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: const Size.fromHeight(60),
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
