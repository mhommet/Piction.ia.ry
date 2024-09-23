import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'teams.dart'; // Importer la page Teams

class Home extends StatelessWidget {
  final String
      username; // Ajouter une variable pour stocker le nom d'utilisateur

  const Home({required Key key, required this.username})
      : super(key: key); // Recevoir le nom d'utilisateur

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Piction.ia.ry',
          style: TextStyle(color: Colors.black), // Titre noir pour cohérence
        ),
        backgroundColor: Colors.grey[200], // Fond gris clair
        elevation: 0, // Pas d'ombre pour un look plus propre
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.grey[100], // Fond harmonisé avec le style général
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Welcome $username', // Afficher le nom de l'utilisateur
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                  color: Colors.black, // Texte noir pour contraste
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Redirection vers la page Teams en passant le nom de l'utilisateur
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                Teams(username: username), // Passer le nom ici
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // Bouton bleu
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
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
                        // Action pour rejoindre une partie
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green, // Bouton vert
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
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
