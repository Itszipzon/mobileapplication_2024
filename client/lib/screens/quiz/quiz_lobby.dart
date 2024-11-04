import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuizLobby extends ConsumerStatefulWidget {
  const QuizLobby({super.key});

  @override
  QuizLobbyState createState() => QuizLobbyState();
}

class QuizLobbyState extends ConsumerState<QuizLobby> {
  List<String> players = ["Player 1", "Player 2", "Player 3", "Player 4"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Lobby'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                // Navigate to the quiz screen
              },
              child: const Text('Start Quiz'),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Quiz ID: '),
                Text("SDH22DS"),
              ],
            ),
            SizedBox(
              height: double.infinity,
              child: SingleChildScrollView(
                child: Wrap(
                  children: [
                    for (int i = 0; i < players.length; i++)
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Chip(
                          label: Text(players[i]),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
