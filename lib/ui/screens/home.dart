import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ionicons/ionicons.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'teams.dart';
import 'qr_code_scanner.dart';

class Home extends StatefulWidget {
  final String username;

  const Home({super.key, required this.username});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<void> _saveUsername() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', widget.username);
  }

  Future<void> _createGameSession(BuildContext context) async {
    if (!context.mounted) return;
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    
    await _saveUsername();
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    if (!context.mounted) return;
    if (token == null) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Token non disponible')),
      );
      return;
    }

    try {
      final url = Uri.parse('https://pictioniary.wevox.cloud/api/game_sessions');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (!context.mounted) return;

      if (response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        final gameSessionId = jsonResponse['id'];
        
        final success = await _joinGameSession(scaffoldMessenger, gameSessionId, token);
        
        if (!context.mounted) return;
        if (success) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Teams(
                username: widget.username,
                gameSessionId: gameSessionId,
              ),
            ),
          );
        }
      } else {
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Erreur lors de la création de la session: ${response.body}')),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Erreur: $e')),
      );
    }
  }

  Future<bool> _joinGameSession(ScaffoldMessengerState scaffoldMessenger, int gameSessionId, String token) async {
    await _saveUsername();
    final sessionUrl = Uri.parse('https://pictioniary.wevox.cloud/api/game_sessions/$gameSessionId');

    try {
      final sessionResponse = await http.get(
        sessionUrl,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (!mounted) return false;

      if (sessionResponse.statusCode == 200) {
        final sessionData = jsonDecode(sessionResponse.body);
        String color = (sessionData['blue_team'] as List).length < 2 ? "blue" : "red";

        final joinUrl = Uri.parse('https://pictioniary.wevox.cloud/api/game_sessions/$gameSessionId/join');
        final joinResponse = await http.post(
          joinUrl,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({'color': color}),
        );

        if (!mounted) return false;

        if (joinResponse.statusCode == 200) {
          scaffoldMessenger.showSnackBar(
            SnackBar(content: Text('Joueur rejoint la session avec succès dans l\'équipe $color')),
          );
          return true;
        } else {
          scaffoldMessenger.showSnackBar(
            SnackBar(content: Text('Erreur lors du join de la session: ${joinResponse.body}')),
          );
        }
      } else {
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Erreur lors de la récupération des données de session: ${sessionResponse.body}')),
        );
      }
    } catch (e) {
      if (!mounted) return false;
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Erreur: $e')),
      );
    }
    return false;
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
                'Welcome ${widget.username}',
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

