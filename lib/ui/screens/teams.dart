import 'dart:async';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'teams_style.dart';
import 'challenge_input_page.dart';
import 'drawing_page.dart';

class Teams extends StatefulWidget {
  final String username;
  final int gameSessionId;

  const Teams({super.key, required this.username, required this.gameSessionId});

  @override
  State<Teams> createState() => _TeamsState();
}

class _TeamsState extends State<Teams> {
  final List<String> teamBlue = [];
  final List<String> teamRed = [];
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

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _startRefreshTimer() {
    _refreshTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      _fetchGameSessionData();
    });
  }

  void _startCountdown() {
    if (!mounted) return;
    
    setState(() {
      isCountdownActive = true;
      countdownSeconds = 10;
    });
    
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (!mounted) {
        timer.cancel();
        return;
      }
      
      setState(() {
        if (countdownSeconds > 0) {
          countdownSeconds--;
        } else {
          _countdownTimer?.cancel();
          _startChallengePhase();
        }
      });
    });
  }

  Future<void> _startChallengePhase() async {
    if (!mounted) return;
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    if (token == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Token non disponible')),
      );
      return;
    }

    try {
      final url = Uri.parse('https://pictioniary.wevox.cloud/api/game_sessions/${widget.gameSessionId}/start');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 'challenge') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ChallengeInputPage(
                gameSessionId: widget.gameSessionId,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erreur: La session n\'est pas passée en mode challenge')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors du démarrage de la phase challenge: ${response.body}')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e')),
      );
    }
  }

  Future<void> _fetchGameSessionData() async {
    if (!mounted) return;

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

    try {
      final url = Uri.parse('https://pictioniary.wevox.cloud/api/game_sessions/${widget.gameSessionId}');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        final sessionData = jsonDecode(response.body);
        
        if (sessionData['status'] == 'drawing') {
          _refreshTimer?.cancel();
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => DrawingPage(
                  key: const Key('drawingPage'),
                  gameSessionId: widget.gameSessionId,
                ),
              ),
            );
          }
          return;
        }

        final List<String> newTeamBlue = [];
        final List<String> newTeamRed = [];

        await _fetchPlayerNames(sessionData['blue_team'], newTeamBlue, token);
        await _fetchPlayerNames(sessionData['red_team'], newTeamRed, token);

        if (!mounted) return;

        setState(() {
          teamBlue.clear();
          teamBlue.addAll(newTeamBlue);
          teamRed.clear();
          teamRed.addAll(newTeamRed);
        });

        if (teamBlue.isNotEmpty && teamRed.isNotEmpty && !isCountdownActive) {
          _startCountdown();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
      }
    }
  }

  Future<void> _fetchPlayerNames(List<dynamic> playerIds, List<String> team, String token) async {
    team.clear();
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
          } else if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Erreur: ${playerResponse.body}')),
            );
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Erreur: $e')),
            );
          }
        }
      }
    }
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
              if (isCountdownActive)
                Text(
                  'La partie commence dans $countdownSeconds secondes...',
                  style: TeamsStyle.infoTextStyle,
                  textAlign: TextAlign.center,
                )
              else
                const Text(
                  'Les deux équipes doivent avoir au moins un joueur pour commencer.',
                  style: TeamsStyle.infoTextStyle,
                  textAlign: TextAlign.center,
                ),
              TeamsStyle.spacing30,
              Text(
                'Session ID: ${widget.gameSessionId}',
                style: TeamsStyle.infoTextStyle,
                textAlign: TextAlign.center,
              ),
              TeamsStyle.spacing20,
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

