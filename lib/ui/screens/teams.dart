import 'dart:async';
import 'package:flutter/foundation.dart';
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
  Timer? _refreshTimer;
  Timer? _countdownTimer;
  int countdownSeconds = 10;
  bool isCountdownActive = false;

  @override
  void initState() {
    super.initState();
    _startRefreshTimer();
    _fetchGameSessionData();
  }

  void _startRefreshTimer() {
    _refreshTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
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

        // Préparer les nouvelles listes pour comparaison
        List<String> newTeamBlue = [];
        List<String> newTeamRed = [];

        await _fetchPlayerNames(sessionData['blue_team'], newTeamBlue, token);
        await _fetchPlayerNames(sessionData['red_team'], newTeamRed, token);

        // Mettre à jour l'état seulement si les listes ont changé
        if (!listEquals(newTeamBlue, teamBlue) || !listEquals(newTeamRed, teamRed)) {
          setState(() {
            teamBlue = newTeamBlue;
            teamRed = newTeamRed;
          });
        }

        // Si au moins une équipe a un joueur, arrêter le timer et démarrer le compte à rebours
        if ((teamBlue.length >= 1 || teamRed.length >= 1) && !isCountdownActive) {
          _refreshTimer?.cancel();
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
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (countdownSeconds > 0) {
          countdownSeconds--;
        } else {
          _countdownTimer?.cancel();
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
    _refreshTimer?.cancel();
    _countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
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
              const Text(
                'Team Blue',
                textAlign: TextAlign.center,
                style: TeamsStyle.teamTitleBlue,
              ),
              TeamsStyle.spacing20,
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
              const Text(
                'Team Red',
                textAlign: TextAlign.center,
                style: TeamsStyle.teamTitleRed,
              ),
              TeamsStyle.spacing20,
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
              else if (teamBlue.length >= 1 || teamRed.length >= 1)
                const Text(
                  'Waiting for more players to join...',
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
