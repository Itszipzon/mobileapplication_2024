// file: quiz_game_solo.dart

import 'package:client/screens/quiz/quiz_solo/audioManager.dart';
import 'package:client/screens/quiz/quiz_solo/quizAnswerManager.dart';
import 'package:client/screens/quiz/quiz_solo/quizTimer.dart';
import 'package:client/tools/api_handler.dart';
import 'package:client/tools/router.dart';
import 'package:client/tools/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuizGameSolo extends ConsumerStatefulWidget {
  const QuizGameSolo({super.key});

  @override
  QuizGameSoloState createState() => QuizGameSoloState();
}

class QuizGameSoloState extends ConsumerState<QuizGameSolo> {
  late final RouterNotifier router;
  late final UserNotifier user;
  late final AudioManager audioManager;
  late final QuizTimer quizTimer;
  late final QuizAnswerManager answerManager;

  bool loading = true;
  int currentQuestionIndex = 0;
  Map<String, dynamic>? quizData;
  String? selectedAnswer;
  bool quizCompleted = false;
  Map<String, dynamic>? results;
  bool submitting = false;

  @override
  void initState() {
    super.initState();
    audioManager = AudioManager();
    answerManager = QuizAnswerManager();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      router = ref.read(routerProvider.notifier);
      user = ref.read(userProvider.notifier);
      quizData = router.getValues?["quizData"] as Map<String, dynamic>?;

      if (quizData != null) {
        quizTimer = QuizTimer(duration: quizData!["timer"] ?? 30);
        quizTimer.start(_onTimerTick, autoNextQuestion);
      }
      audioManager.playBackgroundAudio(
          ['audio.mp3', 'audio1.mp3', 'audio2.mp3', 'audio3.mp3']);

      setState(() {
        loading = false;
      });
    });
  }

  void _onTimerTick() {
    setState(() {});
  }

  void autoNextQuestion() async {
    audioManager.playSoundEffect('next.mp3');
    if (selectedAnswer != null) {
      answerManager.recordAnswer(
          quizData!, currentQuestionIndex, selectedAnswer!);
    } else {
      audioManager.playSoundEffect('error.mp3');
      answerManager.saveUnanswered(quizData!, currentQuestionIndex);
    }

    if (currentQuestionIndex < (quizData?["quizQuestions"].length ?? 0) - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedAnswer = null;
      });
      quizTimer.start(_onTimerTick, autoNextQuestion);
    } else {
      quizTimer.stop();

      submitQuizAnswers();
    }
  }

  Future<void> submitQuizAnswers() async {
    if (submitting) return;
    submitting = true;

    setState(() {
      loading = true;
    });

    try {
      final String token = user.token!.toString();
      final int quizId = quizData!["id"] as int;

      final response = await answerManager.submitAnswers(token, quizId);

      setState(() {
        results = response;
        quizCompleted = true;
        loading = false;
      });

      await audioManager.stopAudio();

      audioManager.playSoundEffect('finish.mp3');
    } catch (error) {
      print("Error submitting quiz answers: $error");
      setState(() {
        loading = false;
      });
    } finally {
      submitting = false;
    }
  }

  @override
  void dispose() {
    quizTimer.stop();
    audioManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (quizCompleted && results != null) {
      final checks = results!["checks"] ?? [];
      final correctAnswersCount =
          checks.where((check) => check["correct"] == true).length;
      final totalQuestions = quizData!["quizQuestions"].length;

      return Scaffold(
        appBar: AppBar(
          title: const Text('Quiz Results'),
          actions: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                router.goBack(context);
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
                    '${ApiHandler.url}/api/quiz/thumbnail/${quizData!["id"]}',
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    bottom: 10,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
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
                  "Great job! Scoring $correctAnswersCount out of $totalQuestions shows your knowledge of ${quizData!["title"]}.",
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
                  final questionData = quizData!["quizQuestions"]
                      .firstWhere((q) => q["id"] == questionId);
                  final questionText = questionData["question"];

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

              // Leave Quiz Button
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
                  router.goBack(context);
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

    final currentQuestion = quizData!["quizQuestions"][currentQuestionIndex];
    final questionText = currentQuestion["question"] ?? "No question text";
    final List<dynamic> options = currentQuestion["quizOptions"] ?? [];
    final totalQuestions = quizData!["quizQuestions"].length;
    final progress = (currentQuestionIndex + 1) / totalQuestions;

    return Scaffold(
      appBar: AppBar(
        title: const Text('QuizAPP'),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              router.goBack(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Center(
                  child: Image.network(
                    '${ApiHandler.url}/api/quiz/thumbnail/${quizData!["id"]}',
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 10,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 70,
                        height: 70,
                        child: CircularProgressIndicator(
                          value: quizTimer.timeLeft / quizTimer.duration,
                          strokeWidth: 8,
                          backgroundColor: Colors.grey.withOpacity(0.3),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          "${quizTimer.timeLeft}",
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
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
                questionText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final optionText = options[index]["option"];
                  final isSelected = selectedAnswer == optionText;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor:
                            isSelected ? Colors.white : Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(
                          color: isSelected
                              ? Colors.green
                              : Theme.of(context).primaryColor,
                          width: 1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          selectedAnswer = optionText;
                        });
                      },
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Text(
                            optionText,
                            style: TextStyle(
                              fontSize: 16,
                              color: isSelected ? Colors.black : Colors.black,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
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
              onPressed: selectedAnswer != null ? autoNextQuestion : null,
              child: Text(
                currentQuestionIndex == totalQuestions - 1
                    ? "Finish Quiz"
                    : "Next",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.grey[300],
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 8),
            Text(
              'Question ${currentQuestionIndex + 1} of $totalQuestions',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
