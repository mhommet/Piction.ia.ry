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
  int gameSessionId = -1;  // Default value instead of nullable

  Future<void> _getSessionAndJoin(BuildContext context, int sessionId) async {
    gameSessionId = sessionId;
    if (!context.mounted) return;
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    
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
      final url = Uri.parse('https://pictioniary.wevox.cloud/api/game_sessions/$sessionId');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (!context.mounted) return;

      if (response.statusCode == 200) {
        final sessionData = jsonDecode(response.body);
        String color = (sessionData['blue_team'] as List).length < 2 ? "blue" : "red";
        await _joinGameSession(scaffoldMessenger, sessionId, color, token);
        
        if (!context.mounted) return;
        final username = prefs.getString('username') ?? 'Joueur';
        navigator.pushReplacement(
          MaterialPageRoute(
            builder: (context) => Teams(
              username: username,
              gameSessionId: sessionId,
            ),
          ),
        );
      } else {
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Erreur lors de la récupération de la session: ${response.body}')),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Erreur: $e')),
      );
    }
  }

  Future<void> _joinGameSession(ScaffoldMessengerState scaffoldMessenger, int gameSessionId, String color, String token) async {
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
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Joueur rejoint la session avec succès dans l\'équipe $color')),
        );
      } else {
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Erreur lors du join de la session: ${response.body}')),
        );
      }
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Erreur: $e')),
      );
    }
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
          if (barcodes.isEmpty) return;
          
          final Barcode barcode = barcodes.first;
          if (!hasScanned && barcode.rawValue != null) {
            setState(() {
              hasScanned = true;
            });

            int sessionId = int.tryParse(barcode.rawValue!) ?? -1;
            if (sessionId != -1) {
              await _getSessionAndJoin(context, sessionId);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('QR code invalide')),
              );
            }
          }
        },
      ),
    );
  }
}

