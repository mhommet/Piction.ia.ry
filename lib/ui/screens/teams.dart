import 'package:flutter/material.dart';

// A page with 2 list with 2 names in each
class Teams extends StatelessWidget {
  const Teams({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TEAMS COMPOSITION'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 30),
              // Team 1
              const Text(
                'Team blue',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Handle the save or login action here
                  // For example, validate inputs or navigate to another screen
                },
                child: const Text(
                  'Milan (vous) \n <en attente>',
                ),
              ),
              const SizedBox(height: 30),
              // Team 2
              const Text(
                'Team red',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Handle the save or login action here
                  // For example, validate inputs or navigate to another screen
                },
                child: const Text(
                  '<en attente> \n <en attente>',
                ),
              ),
              const Text(
                'The game will start automatically when all players are ready',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
