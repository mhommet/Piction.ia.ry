import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class Home extends StatelessWidget {
  const Home({required Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Piction.ia.ry'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                'Welcome Milan',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30),
              ),
              const SizedBox(height: 30),
                SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                  ElevatedButton(
                    onPressed: () {
                    // Handle the save or login action here
                    // For example, validate inputs or navigate to another screen
                    },
                    child: const Text(
                    'Nouvelle partie',
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                    // Handle the save or login action here
                    // For example, validate inputs or navigate to another screen
                    },
                    child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Ionicons.qr_code),
                      SizedBox(width: 10),
                      Text('Rejoindre une partie'),
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
