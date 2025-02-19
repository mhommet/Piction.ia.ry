import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'identification.dart'; // Importer la page login
import 'identification_style.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;

  // Fonction pour envoyer la requête de register à l'API
  Future<void> _register(BuildContext context) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    
    if (!mounted) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final url = Uri.parse('https://pictioniary.wevox.cloud/api/players');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': _usernameController.text,
          'password': _passwordController.text,
        }),
      );

      if (!mounted) return;

      if (response.statusCode == 201) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Account created successfully!')),
        );

        if (!mounted) return;
        navigator.pushReplacement(
          MaterialPageRoute(
            builder: (context) => const Identification(key: Key('loginPage')),
          ),
        );
      } else {
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Registration failed: ${response.body}')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Register',
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
                  'Create your account',
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
                // Bouton Register
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                  onPressed: () =>
                      _register(context), // Appel à la fonction _register
                  style: IdentificationStyle.elevatedButtonStyle,
                  child: const Text(
                    'Register',
                    style: IdentificationStyle.buttonTextStyle,
                  ),
                ),
                IdentificationStyle.spacing20,
                // Lien vers Login
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Identification(key: Key('loginPage')),
                      ),
                    );
                  },
                  child: const Text(
                    'Already have an account? Log in here',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
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
