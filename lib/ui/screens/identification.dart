import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'identification_style.dart';
import 'home.dart'; // Importer la page Home

class Identification extends StatefulWidget {
  Identification({required Key key}) : super(key: key);

  @override
  _IdentificationState createState() => _IdentificationState();
}

class _IdentificationState extends State<Identification> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;

  // Fonction pour envoyer la requête de login à l'API
  Future<void> _login(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return; // Si le formulaire n'est pas valide, on arrête l'exécution
    }

    setState(() {
      isLoading = true; // Démarrer le loader
    });

    final url = Uri.parse('https://pictioniary.wevox.cloud/api/login');
    final body = jsonEncode({
      'name': _usernameController.text,
      'password': _passwordController.text,
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        // Si la connexion est réussie, on parse la réponse
        final jsonResponse = jsonDecode(response.body);

        // Récupérer le token de la réponse JSON
        final token = jsonResponse['token'];

        // Enregistrer le token dans les préférences partagées
        final prefs = await SharedPreferences.getInstance();
        SharedPreferences.setMockInitialValues({});
        await prefs.setString('authToken', token);
        await prefs.setString('name', _usernameController.text);

        // Rediriger vers la page Home si le login est réussi
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Home(
              username: _usernameController.text,
              key: const Key('home'),
            ),
          ),
        );
      } else {
        // Gérer les erreurs de login
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: ${response.body}')),
        );
      }
    } catch (e) {
      print('Erreur: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }

    setState(() {
      isLoading = false; // Arrêter le loader après la requête
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login',
          style: IdentificationStyle.appBarTitleStyle,
        ),
        backgroundColor: IdentificationStyle.appBarBackgroundColor,
        elevation: 0,
        iconTheme: IdentificationStyle.appBarIconTheme,
      ),
      backgroundColor: IdentificationStyle.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Text(
                  'Welcome to Piction.ia.ry',
                  textAlign: TextAlign.center,
                  style: IdentificationStyle.welcomeTextStyle,
                ),
                IdentificationStyle.spacing30,
                const Text(
                  'Please enter your username and password',
                  textAlign: TextAlign.center,
                  style: IdentificationStyle.instructionTextStyle,
                ),
                IdentificationStyle.spacing20,
                // Champ Username
                TextFormField(
                  controller: _usernameController,
                  key: const Key('username'),
                  decoration:
                      IdentificationStyle.textFieldDecoration('Username'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                ),
                IdentificationStyle.spacing20,
                // Champ Password
                TextFormField(
                  controller: _passwordController,
                  key: const Key('password'),
                  decoration:
                      IdentificationStyle.textFieldDecoration('Password'),
                  obscureText: true, // Cacher le mot de passe
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                IdentificationStyle.spacing30,
                // Bouton Log In
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: () =>
                            _login(context), // Appel à la fonction _login
                        style: IdentificationStyle.elevatedButtonStyle,
                        child: const Text(
                          'Log In',
                          style: IdentificationStyle.buttonTextStyle,
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Identification(key: const Key('loginPage')),
  ));
}
