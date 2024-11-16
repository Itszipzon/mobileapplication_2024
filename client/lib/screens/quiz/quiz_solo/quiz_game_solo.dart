import 'dart:convert';
import 'dart:developer' as developer;
import 'package:client/elements/counter.dart';
import 'package:client/screens/quiz/quiz_solo/audioManager.dart';
import 'package:client/screens/quiz/quiz_solo/quizAnswerManager.dart';
import 'package:client/screens/quiz/quiz_solo/scoringSystem.dart';
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
  late final QuizAnswerManager answerManager;
  late final ScoringSystem scoringSystem;

  Widget? counter;

  bool loading = true;
  int currentQuestionIndex = 0;
  Map<String, dynamic>? quizData;
  String? selectedAnswer;
  bool quizCompleted = false;
  Map<String, dynamic>? results;
  bool submitting = false;

  int duration = 0;

  DateTime? questionStartTime;
  List<int> questionScores = [];

  @override
  void initState() {
    super.initState();

    audioManager = AudioManager();
    answerManager = QuizAnswerManager();
    scoringSystem = ScoringSystem();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      router = ref.read(routerProvider.notifier);
      user = ref.read(userProvider.notifier);
      quizData = router.getValues?["quizData"] as Map<String, dynamic>?;

      setState(() {
        loading = false;
        duration = quizData!["timer"];
        counter = Counter(
          key: ValueKey<int>(currentQuestionIndex),
          onCountdownComplete: autoNextQuestion,
          duration: duration,
          height: 70,
          width: 70,
          color: Colors.white,
        );
      });

      audioManager.playBackgroundAudio(
          ['audio.mp3', 'audio1.mp3', 'audio2.mp3', 'audio3.mp3']);

      questionStartTime = DateTime.now();
    });
  }

  void autoNextQuestion() async {
    questionStartTime ??= DateTime.now();

    int timeTaken = 0;
    if (questionStartTime != null) {
      timeTaken = DateTime.now().difference(questionStartTime!).inSeconds;
    }

    audioManager.playSoundEffect('next.mp3');
    if (selectedAnswer != null) {
      answerManager.recordAnswer(
          quizData!, currentQuestionIndex, selectedAnswer!);
    } else {
      audioManager.playSoundEffect('error.mp3');
      answerManager.saveUnanswered(quizData!, currentQuestionIndex);
    }

    final currentQuestion = quizData!["quizQuestions"][currentQuestionIndex];
    final isMultiSelect = currentQuestion["type"] == "multi-select";

    int pointsPossible = isMultiSelect
        ? scoringSystem.multiSelectMaxPoints
        : scoringSystem.singleSelectMaxPoints;

    int pointsAwarded =
        scoringSystem.calculatePoints(timeTaken, duration, pointsPossible);

    questionScores.add(pointsAwarded);

    if (currentQuestionIndex < (quizData?["quizQuestions"].length ?? 0) - 1) {
      print(duration = quizData!["timer"]);
      setState(() {
        currentQuestionIndex++;
        selectedAnswer = null;
        duration = quizData!["timer"];

        counter = Counter(
          key: ValueKey<int>(currentQuestionIndex),
          onCountdownComplete: () {
            autoNextQuestion();
          },
          height: 70,
          width: 70,
          duration: duration,
          color: Colors.white,
        );
      });
    } else {
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

      final attemptResponse = await ApiHandler.addQuizAttempt(token, quizId);

      if (attemptResponse.statusCode == 201) {
        developer.log("Quiz attempt logged successfully.");

        final response = await answerManager.submitAnswers(token, quizId);
        print(
            "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
        print(questionScores);
        response['questionScores'] = questionScores;
        developer.log('Question scores: $questionScores');

        router.setPath(context, "quiz/results", values: {
          'quizData': quizData,
          'results': response,
        });

        await audioManager.stopAudio();
        audioManager.playSoundEffect('finish.mp3');
      } else {
        developer.log("Failed to log quiz attempt: ${attemptResponse.body}");
        throw Exception("Failed to log quiz attempt.");
      }
    } catch (error) {
      developer.log("Error submitting quiz answers: $error");
      setState(() {
        loading = false;
      });
    } finally {
      submitting = false;
    }
  }

  @override
  void dispose() {
    audioManager.dispose();
    super.dispose();
  }

  String fixEncoding(String text) {
    return utf8.decode(text.runes.toList(), allowMalformed: true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final currentQuestion = quizData!["quizQuestions"][currentQuestionIndex];
    final questionText =
        fixEncoding(currentQuestion["question"] ?? "No question text");
    final List<dynamic> options = currentQuestion["quizOptions"] ?? [];
    final totalQuestions = quizData!["quizQuestions"].length;
    final progress = (currentQuestionIndex + 1) / totalQuestions;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          quizData?["title"] ?? "Untitled Quiz",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
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
                  child: counter != null ? counter! : Container(),
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
                  final optionText = fixEncoding(options[index]["option"]);
                  final isSelected = selectedAnswer == optionText;
                  final isSelectedOrNoAnswer = isSelected || selectedAnswer == null;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedAnswer = optionText;
                      });
                    },
                    child: Container(
                      width: 50,
                      decoration: BoxDecoration(
                        color: isSelectedOrNoAnswer ? Colors.white : Colors.grey[200],
                        border: Border.all(color: isSelectedOrNoAnswer ? theme.primaryColor : Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            optionText,
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                  /* return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
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
                }, */
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
