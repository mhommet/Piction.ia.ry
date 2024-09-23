import 'package:flutter/material.dart';
import 'teams_style.dart';
import 'challenge_input_page.dart'; // Importer la page ChallengeInputPage

class Teams extends StatefulWidget {
  final String username; // Recevoir le nom de l'utilisateur

  const Teams({super.key, required this.username});

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

    // Si l'équipe bleue contient au moins un joueur, rediriger vers ChallengeInputPage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (teamBlue.isNotEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ChallengeInputPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
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
              const Text(
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
                      style: TeamsStyle
                          .buttonTextStyle, // Style du texte du bouton
                      textAlign: TextAlign.center,
                    ),
                  )),
              TeamsStyle.spacing30,
              // Team 2
              const Text(
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
                      style: TeamsStyle
                          .buttonTextStyle, // Style du texte du bouton
                      textAlign: TextAlign.center,
                    ),
                  )),
              TeamsStyle.spacing30,
              // Info sur le démarrage automatique
              const Text(
                'The game will start automatically when all players are ready',
                style: TeamsStyle.infoTextStyle, // Style du texte d'information
              ),
            ],
          ),
        ),
      ),
    );
  }
}
