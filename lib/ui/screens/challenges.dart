import 'package:flutter/material.dart';

class Challenges extends StatefulWidget {
  const Challenges({super.key});

  @override
  _ChallengesState createState() => _ChallengesState();
}

class _ChallengesState extends State<Challenges> {
  final List<Map<String, dynamic>> _challenges = [
    {
      'number': 1,
      'title': 'Une poule sur un mur',
      'tags': ['Poulet', 'Volaille', 'Oiseau']
    },
  ];

  void _addChallenge(String title, List<String> tags) {
    setState(() {
      _challenges.add({
        'number': _challenges.length + 1,
        'title': title,
        'tags': tags,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saisie des challenges'),
        backgroundColor: Colors.grey[300],
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _challenges.length,
                itemBuilder: (context, index) {
                  final challenge = _challenges[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: ChallengeCard(
                      number: challenge['number'],
                      title: challenge['title'],
                      tags: List<String>.from(challenge['tags']),
                    ),
                  );
                },
              ),
            ),
            Center(
              child: CircleAvatar(
                backgroundColor: Colors.grey,
                child: IconButton(
                  icon: const Icon(Icons.add, color: Colors.white),
                  onPressed: () {
                    _openAddChallengeModal(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openAddChallengeModal(BuildContext context) {
    String title = '';
    String tag = '';
    List<String> tags = [];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ajouter un challenge'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration:
                    const InputDecoration(labelText: 'Titre du challenge'),
                onChanged: (value) {
                  title = value;
                },
              ),
                TextField(
                decoration: const InputDecoration(labelText: 'Tag'),
                onChanged: (value) {
                  tag = value;
                },
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                onPressed: () {
                  setState(() {
                  if (tag.isNotEmpty) {
                    tags.add(tag);
                  }
                  });
                },
                child: const Text('Ajouter Tag'),
                ),
              Wrap(
                spacing: 8,
                children: tags.map((tag) => Chip(label: Text(tag))).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                if (title.isNotEmpty && tags.isNotEmpty) {
                  _addChallenge(title, tags);
                }
                Navigator.of(context).pop();
              },
              child: const Text('Ajouter'),
            ),
          ],
        );
      },
    );
  }
}

class ChallengeCard extends StatelessWidget {
  final int number;
  final String title;
  final List<String> tags;

  const ChallengeCard({
    Key? key,
    required this.number,
    required this.title,
    required this.tags,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Challenge #$number',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Icon(Icons.delete_outline),
              ],
            ),
            const SizedBox(height: 8),
            Text(title),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: tags
                  .map((tag) => Chip(
                        label: Text(tag),
                        backgroundColor: Colors.red,
                        labelStyle: const TextStyle(color: Colors.white),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
