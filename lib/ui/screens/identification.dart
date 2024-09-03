import 'package:flutter/material.dart';

class Identification extends StatelessWidget {
  const Identification({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LOGIN PAGE'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                'Welcome to Piction.ia.ry',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30),
              ),
              const SizedBox(height: 30),
              const Text(
                'Please enter your username',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const TextField(
                key: Key('username'),
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                },
                child: const Text(
                  'Save',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
