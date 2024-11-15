import 'dart:convert';
import 'package:client/screens/quiz/quiz_solo/audioManager.dart';
import 'package:client/tools/api_handler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:client/tools/router.dart';

class QuizResults extends ConsumerStatefulWidget {
  const QuizResults({super.key});

  @override
  _QuizResultsState createState() => _QuizResultsState();
}

class _QuizResultsState extends ConsumerState<QuizResults>
    with TickerProviderStateMixin {
  String fixEncoding(String? text) {
    return utf8.decode(text?.runes.toList() ?? [], allowMalformed: true);
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.read(routerProvider);
    final quizData = router.values?['quizData'];
    final results = router.values?['results'];

    if (quizData == null || results == null) {
      return const Scaffold(
        body: Center(child: Text('Error: Quiz data or results are missing.')),
      );
    }

    final checks = results["checks"] ?? [];
    final totalQuestions = quizData["quizQuestions"]?.length ?? 0;
    final correctPercentage =
        (checks.where((check) => check["correct"] == true).length /
                totalQuestions) *
            100;

    final totalScore = results["totalScore"] ?? 0;
    final questionScores = results["questionScores"] ?? [];

    int finalScore = 0;

    for (int i = 0; i < questionScores.length; i++) {
      final questionId = quizData["quizQuestions"][i]["id"];
      final answerCorrect = checks.any((check) =>
          check["questionId"] == questionId && check["correct"] == true);

      if (answerCorrect) {
        finalScore += (questionScores[i] as num).toInt();
      } else {
        finalScore += 0;
      }
    }

    String performanceComment() {
      if (finalScore >= totalQuestions * 1000 * 0.9) {
        return "Excellent job! You're a quiz master!";
      } else if (finalScore >= totalQuestions * 1000 * 0.7) {
        return "Great job! You did well!";
      } else if (finalScore >= totalQuestions * 1000 * 0.5) {
        return "Good effort! But there's room for improvement.";
      } else {
        return "Keep trying! You'll do better next time!";
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final audioManager = AudioManager();
      if (correctPercentage > 20) {
        audioManager.playSoundEffect('countup.mp3');
      } else {
        audioManager.playSoundEffect('losing.mp3');
      }
    });

    final scoreAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2, milliseconds: 500), // 2.5 seconds
    );

    final scoreAnimation = IntTween(begin: 0, end: finalScore).animate(
      CurvedAnimation(
        parent: scoreAnimationController,
        curve: Curves.easeOut,
      ),
    );

    // Start the animation
    scoreAnimationController.forward();

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
                      color: Colors.orangeAccent,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Your Total Score",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Animated score display
                        AnimatedBuilder(
                          animation: scoreAnimationController,
                          builder: (context, child) {
                            return Text(
                              "${scoreAnimation.value}",
                              style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        Icon(
                          Icons.star,
                          color: Colors.white,
                          size: 36,
                        ),
                      ],
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
                  "${performanceComment()} Scoring $finalScore out of ${totalQuestions * 1000} shows your knowledge of ${fixEncoding(quizData["title"] ?? "Unknown Title")}.",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                )),
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
