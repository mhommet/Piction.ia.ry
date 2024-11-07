import 'package:flutter/material.dart';
import 'challenge_input_page.dart'; // Importer la page ChallengeInputPage
import 'package:qr_flutter/qr_flutter.dart';

import 'teams_style.dart'; // Assuming TeamsStyle is defined in teams_style.dart

class Teams extends StatefulWidget {
  final String username; // Recevoir le nom de l'utilisateur
  final int gameSessionId; // Recevoir l'ID de la session de jeu

  const Teams({super.key, required this.username, required this.gameSessionId});

  @override
  _TeamsState createState() => _TeamsState();
}

class _TeamsState extends State<Teams> {
  // Listes des joueurs dans chaque équipe
  List<String> teamBlue = [];
  List<String> teamRed = [];

  @override
  void initState() {
    super.initState();
    // Ajouter le joueur à l'équipe bleue au moment de l'initialisation de la page
    teamBlue.add(widget.username); // Ajouter l'utilisateur à la Team Blue

    // Si il y a un joueur par équipe, rediriger vers ChallengeInputPage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (teamBlue.length == 1 && teamRed.length == 1) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ChallengeInputPage(
              gameSessionId: widget.gameSessionId, // Passer l'ID de la session
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'TEAMS COMPOSITION',
          style: TeamsStyle.appBarTitleStyle, // Style du titre de l'AppBar
        ),
        backgroundColor: TeamsStyle.appBarBackgroundColor, // Fond AppBar
        elevation: 0,
        iconTheme: TeamsStyle.appBarIconTheme, // Style des icônes de l'AppBar
      ),
      backgroundColor: TeamsStyle.backgroundColor, // Fond gris clair
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TeamsStyle.spacing30,
              // Team 1
              Text(
                'Team Blue',
                textAlign: TextAlign.center,
                style: TeamsStyle.teamTitleBlue, // Style de l'équipe bleue
              ),
              TeamsStyle.spacing20,
              // Afficher les joueurs de l'équipe bleue
              ...teamBlue.map((player) => ElevatedButton(
                onPressed: () {
                  // Action pour les joueurs de l'équipe bleue
                },
                style: TeamsStyle.teamButtonBlue, // Style du bouton bleu
                child: Text(
                  player,
                  style: TeamsStyle.buttonTextStyle, // Style du texte du bouton
                  textAlign: TextAlign.center,
                ),
              )),
              TeamsStyle.spacing30,
              // Team 2
              Text(
                'Team Red',
                textAlign: TextAlign.center,
                style: TeamsStyle.teamTitleRed, // Style de l'équipe rouge
              ),
              TeamsStyle.spacing20,
              // Afficher les joueurs de l'équipe rouge
              ...teamRed.map((player) => ElevatedButton(
                onPressed: () {
                  // Action pour les joueurs de l'équipe rouge
                },
                style: TeamsStyle.teamButtonRed, // Style du bouton rouge
                child: Text(
                  player,
                  style: TeamsStyle.buttonTextStyle, // Style du texte du bouton
                  textAlign: TextAlign.center,
                ),
              )),
              TeamsStyle.spacing30,
              // Info sur le démarrage automatique
              Text(
                'The game will start automatically when all players are ready',
                style: TeamsStyle.infoTextStyle, // Style du texte d'information
              ),
              TeamsStyle.spacing30,
              // QR Code pour rejoindre la session
              Center(
                child: QrImageView(
                  data: widget.gameSessionId.toString(), // Utilise l'ID de la session
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