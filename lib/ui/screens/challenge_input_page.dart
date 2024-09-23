import 'package:flutter/material.dart';
import 'challenge_input_style.dart';
import 'loading.dart'; // Import the loading screen

class ChallengeInputPage extends StatefulWidget {
  const ChallengeInputPage({super.key, required int gameSessionId});

  @override
  _ChallengeInputPageState createState() => _ChallengeInputPageState();
}

class _ChallengeInputPageState extends State<ChallengeInputPage> {
  // List of challenges in memory
  List<Map<String, dynamic>> challenges = [];

  // Variables for fixed parts of the sentence
  String firstWord = 'Un';
  String thirdWord = 'sur';

  // Method to open a modal to add a challenge using a bottom sheet (no dimming)
  void _openAddChallengeModal(BuildContext context) {
    String secondWord = ''; // Free text for word 1
    String fourthWord = ''; // Free text for word 2
    List<String> tags = [];
    String currentTag = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Buttons for Un/Une with capital letters
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: firstWord == 'Un'
                              ? Colors.blue
                              : Colors.grey[300],
                        ),
                        onPressed: () {
                          setModalState(() {
                            firstWord = 'Un';
                          });
                        },
                        child: const Text('Un'),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: firstWord == 'Une'
                              ? Colors.blue
                              : Colors.grey[300],
                        ),
                        onPressed: () {
                          setModalState(() {
                            firstWord = 'Une';
                          });
                        },
                        child: const Text('Une'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Free text input (word 1)
                  TextField(
                    decoration: const InputDecoration(hintText: 'Mot 1'),
                    onChanged: (value) {
                      secondWord = value;
                    },
                  ),
                  const SizedBox(height: 8),
                  // Buttons for sur/dans with lowercase
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: thirdWord == 'sur'
                              ? Colors.blue
                              : Colors.grey[300],
                        ),
                        onPressed: () {
                          setModalState(() {
                            thirdWord = 'sur';
                          });
                        },
                        child: const Text('sur'),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: thirdWord == 'dans'
                              ? Colors.blue
                              : Colors.grey[300],
                        ),
                        onPressed: () {
                          setModalState(() {
                            thirdWord = 'dans';
                          });
                        },
                        child: const Text('dans'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Free text input (word 2)
                  TextField(
                    decoration: const InputDecoration(hintText: 'Mot 2'),
                    onChanged: (value) {
                      fourthWord = value;
                    },
                  ),
                  const SizedBox(height: 8),
                  // Add tag
                  TextField(
                    decoration: const InputDecoration(labelText: 'Tag'),
                    onChanged: (value) {
                      currentTag = value;
                    },
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (currentTag.isNotEmpty) {
                        setModalState(() {
                          tags.add(currentTag); // Add the tag to the list
                          currentTag = ''; // Reset the tag field
                        });
                      }
                    },
                    child: const Text('Ajouter Tag'),
                  ),
                  const SizedBox(height: 8),
                  // Display added tags in a Wrap
                  Wrap(
                    spacing: 8,
                    children:
                        tags.map((tag) => Chip(label: Text(tag))).toList(),
                  ),
                  const SizedBox(height: 8),
                  // Add challenge button
                  ElevatedButton(
                    onPressed: () {
                      if (secondWord.isNotEmpty &&
                          fourthWord.isNotEmpty &&
                          tags.isNotEmpty) {
                        String challengeTitle =
                            '$firstWord $secondWord $thirdWord $fourthWord';
                        setState(() {
                          challenges
                              .add({'title': challengeTitle, 'tags': tags});
                        });
                        Navigator.of(context).pop(); // Close the modal
                      }
                    },
                    child: const Text('Ajouter'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Method to remove a challenge
  void _removeChallenge(int index) {
    setState(() {
      challenges.removeAt(index);
    });
  }

// Méthode pour naviguer vers l'écran de loading puis vers challenge_screen avec les challenges
  Future<void> _validateAndNavigate() async {
    // Naviguer vers la page Loading en passant les défis
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            Loading(challenges: challenges), // Pass challenges
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Saisie des challenges',
          style: ChallengeInputStyle.appBarTitleStyle,
        ),
        backgroundColor: ChallengeInputStyle.appBarBackgroundColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.send, color: Colors.blue),
            onPressed: _validateAndNavigate, // Call validation method
          ),
        ],
        elevation: 0,
        iconTheme: ChallengeInputStyle.appBarIconTheme,
      ),
      backgroundColor: ChallengeInputStyle.pageBackgroundColor,
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 70),
        child: FloatingActionButton(
          onPressed: () {
        _openAddChallengeModal(context);
          },
          backgroundColor: const Color.fromARGB(255, 121, 195, 255),
          child: const Icon(Icons.add),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
            children: [
            Expanded(
              child: ListView.builder(
              itemCount: challenges.length,
              itemBuilder: (context, index) {
                final challenge = challenges[index];
                return _buildChallengeCard(
                  index, challenge['title'], challenge['tags']);
              },
              ),
            ),
            const SizedBox(height: 16),
            // Validation button
            SizedBox(
              width: double.infinity, // Set the width to match the parent
              child: ElevatedButton(
              onPressed: _validateAndNavigate, // Navigate to loading
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 126, 255, 130),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Valider et continuer',
                style: TextStyle(
                color: Colors.white,
                fontSize: 18, // Increase the font size
                ),
              ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChallengeCard(int index, String title, List<String> tags) {
    return Card(
      margin: ChallengeInputStyle.cardMargin,
      shape: ChallengeInputStyle.cardShape,
      elevation: 3,
      color: Colors.white, // Remove focus background (no gray background)
      child: Padding(
        padding: ChallengeInputStyle.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: ChallengeInputStyle.challengeTitleStyle,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: tags.map((tag) => _ChallengeTag(label: tag)).toList(),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.delete,
                    color: ChallengeInputStyle.iconDeleteColor),
                onPressed: () {
                  _removeChallenge(index); // Remove the challenge
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChallengeTag extends StatelessWidget {
  final String label;

  const _ChallengeTag({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: ChallengeInputStyle.tagDecoration,
      child: Text(
        label,
        style: ChallengeInputStyle.tagTextStyle,
      ),
    );
  }
}
