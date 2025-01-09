import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'teams.dart';

class QRCodeScannerPage extends StatefulWidget {
  const QRCodeScannerPage({super.key});

  @override
  State<QRCodeScannerPage> createState() => _QRCodeScannerPageState();
}

class _QRCodeScannerPageState extends State<QRCodeScannerPage> {
  bool hasScanned = false; // Empêche de scanner plusieurs fois

  Future<void> _getSessionAndJoin(BuildContext context, int gameSessionId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    if (token == null) {
      print('Token non disponible. Redirection vers la page de login nécessaire.');
      return;
    }

    final url = Uri.parse('https://pictioniary.wevox.cloud/api/game_sessions/$gameSessionId');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final sessionData = jsonDecode(response.body);

        String color;
        if (sessionData['blue_team'].length < 2) {
          color = "blue";
        } else if (sessionData['red_team'].length < 2) {
          color = "red";
        } else {
          print("Les équipes sont pleines.");
          return;
        }

        await _joinGameSession(context, gameSessionId, color);
      } else {
        print('Erreur lors de la récupération de la session: ${response.body}');
      }
    } catch (e) {
      print('Erreur: $e');
    }
  }

  Future<void> _joinGameSession(BuildContext context, int gameSessionId, String color) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    if (token == null) {
      print('Token non disponible. Redirection vers la page de login nécessaire.');
      return;
    }

    final url = Uri.parse('https://pictioniary.wevox.cloud/api/game_sessions/$gameSessionId/join');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'color': color}),
      );

      if (response.statusCode == 200) {
        print('Joueur rejoint la session avec succès dans l\'équipe $color');
        _navigateToTeamsPage(context, gameSessionId);
      } else {
        print('Erreur lors du join de la session: ${response.body}');
      }
    } catch (e) {
      print('Erreur: $e');
    }
  }

  void _navigateToTeamsPage(BuildContext context, int gameSessionId) async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username') ?? 'Joueur';

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Teams(
          username: username,
          gameSessionId: gameSessionId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Scanner'),
      ),
      body: MobileScanner(
        onDetect: (capture) async {
          final List<Barcode> barcodes = capture.barcodes;
          final Barcode? barcode = barcodes.first;
          if (!hasScanned && barcode?.rawValue != null) {
            setState(() {
              hasScanned = true;
            });

            int gameSessionId = int.tryParse(barcode!.rawValue!) ?? -1;
            if (gameSessionId != -1) {
              await _getSessionAndJoin(context, gameSessionId);
            } else {
              print("QR code invalide");
            }
          }
        },
      ),
    );
  }
}

