import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

// A page with 2 list with 2 names in each
class Challenges extends StatelessWidget {
  const Challenges({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CHALLENGES'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Challenge 1
              Row(
                children: <Widget>[
                  const Column(
                    children: <Widget>[
                      Text(
                        'Challenge #1',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Une poule sur un mur',
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Tags: Animaux, Chanson',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Handle the save or login action here
                      // For example, validate inputs or navigate to another screen
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Ionicons.trash_bin),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  // Handle the save or login action here
                  // For example, validate inputs or navigate to another screen
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Ionicons.add),
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
