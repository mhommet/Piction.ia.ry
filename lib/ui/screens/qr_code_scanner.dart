import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'qr_code_scanner_style.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'teams.dart';

class QRCodeScannerPage extends StatefulWidget {
  const QRCodeScannerPage({super.key});

  @override
  State<StatefulWidget> createState() => _QRCodeScannerPageState();
}

class _QRCodeScannerPageState extends State<QRCodeScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool hasScanned = false; // Pour éviter de joindre plusieurs fois la session

  @override
  void initState() {
    super.initState();
    _requestCameraPermission(); // Demander la permission de la caméra
  }

  Future<void> _requestCameraPermission() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      await Permission.camera.request();
    }
    if (await Permission.camera.isGranted) {
      _initializeCamera();
    } else {
      print("Permission caméra refusée");
    }
  }

  void _initializeCamera() {
    setState(() {});
  }

  @override
  void reassemble() {
    super.reassemble();
    if (controller != null) {
      if (defaultTargetPlatform == TargetPlatform.android) {
        controller!.pauseCamera();
      }
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'QR Code Scanner',
          style: QRCodeScannerStyle.appBarTitleStyle,
        ),
        backgroundColor: QRCodeScannerStyle.appBarBackgroundColor,
        elevation: 0,
        iconTheme: QRCodeScannerStyle.appBarIconTheme,
      ),
      backgroundColor: QRCodeScannerStyle.backgroundColor,
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: QRCodeScannerStyle.overlayBorderColor,
                borderRadius: QRCodeScannerStyle.overlayBorderRadius,
                borderLength: QRCodeScannerStyle.overlayBorderLength,
                borderWidth: QRCodeScannerStyle.overlayBorderWidth,
                cutOutSize: QRCodeScannerStyle.overlayCutOutSize,
              ),
            ),
          ),
          const Expanded(
            flex: 1,
            child: Center(
              child: Text(
                'Scan QR Code',
                style: QRCodeScannerStyle.waitingTextStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) async {
      if (!hasScanned && scanData.code != null && int.tryParse(scanData.code!) != null) {
        setState(() {
          hasScanned = true;
        });

        controller.pauseCamera();

        int gameSessionId = int.parse(scanData.code!);
        await _getSessionAndJoin(context, gameSessionId);
      }
    });
  }

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

        // Déterminer l'équipe avec de la place, en équilibrant les équipes
        String color;
        if (sessionData['blue_team'].length < 2 && sessionData['red_team'].length == 1) {
          color = "blue";
        } else if (sessionData['red_team'].length < 2 && sessionData['blue_team'].length == 1) {
          color = "red";
        } else if (sessionData['blue_team'].length < 2) {
          color = "blue";
        } else if (sessionData['red_team'].length < 2) {
          color = "red";
        } else {
          print("Les deux équipes sont déjà pleines");
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
        final responseBody = jsonDecode(response.body);
        if (responseBody["error"] == "Player already in game session") {
          print('Le joueur est déjà dans la session.');
          _navigateToTeamsPage(context, gameSessionId);
        } else {
          print('Erreur lors du join de la session: ${response.body}');
        }
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
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
