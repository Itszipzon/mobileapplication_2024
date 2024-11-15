import 'dart:convert';

import 'package:client/screens/quiz/quiz_solo/audioManager.dart';
import 'package:client/tools/api_handler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:client/tools/router.dart';

class QuizResults extends ConsumerWidget {
  const QuizResults({super.key});

  String fixEncoding(String? text) {
    return utf8.decode(text?.runes.toList() ?? [], allowMalformed: true);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.read(routerProvider);
    final quizData = router.values?['quizData'];
    final results = router.values?['results'];

    print("Received quizData in results screen: $quizData");
    print("Received results in results screen: $results");

    if (quizData == null || results == null) {
      return const Scaffold(
        body: Center(child: Text('Error: Quiz data or results are missing.')),
      );
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final audioManager = AudioManager();
      audioManager.playSoundEffect('finish.mp3');
    });

    final checks = results["checks"] ?? [];
    final correctAnswersCount =
        checks.where((check) => check["correct"] == true).length;
    final totalQuestions = quizData["quizQuestions"]?.length ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Results'),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              final router = ref.read(routerProvider.notifier);
              router.setPath(context, "home");
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Image.network(
                  '${ApiHandler.url}/api/quiz/thumbnail/${quizData["id"]}',
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: 10,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      "$correctAnswersCount/$totalQuestions",
                      style: const TextStyle(
                        fontSize: 34,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Text(
                "Great job! Scoring $correctAnswersCount out of $totalQuestions shows your knowledge of ${fixEncoding(quizData["title"] ?? "Unknown Title")}.",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Column(
              children: checks.map<Widget>((check) {
                final questionId = check["questionId"];
                final answerCorrect = check["correct"] ?? false;
                final questionData = quizData["quizQuestions"]?.firstWhere(
                    (q) => q["id"] == questionId,
                    orElse: () => {});

                final questionText =
                    fixEncoding(questionData?["question"] ?? "No Question");

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: answerCorrect ? Colors.green : Colors.red,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "${checks.indexOf(check) + 1}. $questionText",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      Icon(
                        answerCorrect ? Icons.check_circle : Icons.cancel,
                        color: answerCorrect ? Colors.green : Colors.red,
                        size: 28,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              onPressed: () {
                final router = ref.read(routerProvider.notifier);
                router.setPath(context, "home");
              },
              child: const Text(
                "Leave Quiz",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
