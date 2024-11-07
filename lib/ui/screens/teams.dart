import 'dart:async'; // Import nécessaire pour le Timer
import 'package:flutter/material.dart';
import 'challenge_input_page.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'teams_style.dart';

class Teams extends StatefulWidget {
  final String username;
  final int gameSessionId;

  const Teams({super.key, required this.username, required this.gameSessionId});

  @override
  _TeamsState createState() => _TeamsState();
}

class _TeamsState extends State<Teams> {
  List<String> teamBlue = [];
  List<String> teamRed = [];
  Timer? _refreshTimer; // Timer pour actualiser les données de session
  Timer? _countdownTimer; // Timer pour le compte à rebours
  int countdownSeconds = 10; // Compteur initial du compte à rebours
  bool isCountdownActive = false; // Pour vérifier si le compte à rebours est en cours

  @override
  void initState() {
    super.initState();
    _fetchGameSessionData();
    // Démarrer le Timer pour rafraîchir les données toutes les 5 secondes
    _refreshTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      _fetchGameSessionData();
    });
  }

  Future<void> _fetchGameSessionData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    if (token == null) {
      print('Token non disponible. Redirection vers la page de login nécessaire.');
      return;
    }

    final url = Uri.parse('https://pictioniary.wevox.cloud/api/game_sessions/${widget.gameSessionId}');

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

        // Vider les listes pour éviter les doublons
        teamBlue.clear();
        teamRed.clear();

        // Récupérer les noms des joueurs pour chaque équipe
        await _fetchPlayerNames(sessionData['blue_team'], teamBlue, token);
        await _fetchPlayerNames(sessionData['red_team'], teamRed, token);

        // Mettre à jour l'état avec les noms des joueurs
        setState(() {});

        // Si chaque équipe a un joueur, démarrer le compte à rebours
        if (teamBlue.length == 1 && teamRed.length == 1 && !isCountdownActive) {
          _startCountdown();
        }
      } else {
        print('Erreur lors de la récupération des données de session: ${response.body}');
      }
    } catch (e) {
      print('Erreur: $e');
    }
  }

  Future<void> _fetchPlayerNames(List<dynamic> playerIds, List<String> team, String token) async {
    for (var playerId in playerIds) {
      if (playerId != null) {
        final playerUrl = Uri.parse('https://pictioniary.wevox.cloud/api/players/$playerId');
        try {
          final playerResponse = await http.get(
            playerUrl,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          );
          if (playerResponse.statusCode == 200) {
            final playerData = jsonDecode(playerResponse.body);
            team.add(playerData['name']);
          } else {
            print('Erreur lors de la récupération des informations du joueur: ${playerResponse.body}');
          }
        } catch (e) {
          print('Erreur: $e');
        }
      }
    }
  }

  void _startCountdown() {
    setState(() {
      isCountdownActive = true;
      countdownSeconds = 10;
    });
    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (countdownSeconds > 0) {
          countdownSeconds--;
        } else {
          _countdownTimer?.cancel();
          // Rediriger vers ChallengeInputPage une fois le compte à rebours terminé
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ChallengeInputPage(
                gameSessionId: widget.gameSessionId,
              ),
            ),
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel(); // Annuler le Timer pour éviter les fuites de mémoire
    _countdownTimer?.cancel(); // Annuler le Timer du compte à rebours
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'TEAMS COMPOSITION',
          style: TeamsStyle.appBarTitleStyle,
        ),
        backgroundColor: TeamsStyle.appBarBackgroundColor,
        elevation: 0,
        iconTheme: TeamsStyle.appBarIconTheme,
      ),
      backgroundColor: TeamsStyle.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TeamsStyle.spacing30,
              // Team Blue
              Text(
                'Team Blue',
                textAlign: TextAlign.center,
                style: TeamsStyle.teamTitleBlue,
              ),
              TeamsStyle.spacing20,
              // Afficher les joueurs de l'équipe bleue
              ...teamBlue.map((player) => ElevatedButton(
                onPressed: () {},
                style: TeamsStyle.teamButtonBlue,
                child: Text(
                  player,
                  style: TeamsStyle.buttonTextStyle,
                  textAlign: TextAlign.center,
                ),
              )),
              TeamsStyle.spacing30,
              // Team Red
              Text(
                'Team Red',
                textAlign: TextAlign.center,
                style: TeamsStyle.teamTitleRed,
              ),
              TeamsStyle.spacing20,
              // Afficher les joueurs de l'équipe rouge
              ...teamRed.map((player) => ElevatedButton(
                onPressed: () {},
                style: TeamsStyle.teamButtonRed,
                child: Text(
                  player,
                  style: TeamsStyle.buttonTextStyle,
                  textAlign: TextAlign.center,
                ),
              )),
              TeamsStyle.spacing30,
              // Info sur le démarrage automatique ou le compte à rebours
              if (isCountdownActive)
                Text(
                  'La partie commence dans $countdownSeconds secondes...',
                  style: TeamsStyle.infoTextStyle,
                  textAlign: TextAlign.center,
                )
              else
                Text(
                  'The game will start automatically when all players are ready',
                  style: TeamsStyle.infoTextStyle,
                ),
              TeamsStyle.spacing30,
              // QR Code pour rejoindre la session
              Center(
                child: QrImageView(
                  data: widget.gameSessionId.toString(),
                  version: QrVersions.auto,
                  size: 200.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
