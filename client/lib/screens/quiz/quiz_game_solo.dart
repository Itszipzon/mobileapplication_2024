import 'dart:async';
import 'package:client/tools/router.dart';
import 'package:client/tools/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:client/tools/api_handler.dart';

class QuizGameSolo extends ConsumerStatefulWidget {
  const QuizGameSolo({super.key});

  @override
  QuizGameSoloState createState() => QuizGameSoloState();
}

class QuizGameSoloState extends ConsumerState<QuizGameSolo> {
  late final RouterNotifier router;
  late final UserNotifier user;

  bool loading = true;
  int currentQuestionIndex = 0;
  Map<String, dynamic>? quizData;
  String? selectedAnswer;
  List<Map<String, int?>> userAnswers = []; 
  bool quizCompleted = false;
  Map<String, dynamic>? results;
  bool submittingAnswers = false; 

  late int questionTimer;
  Timer? _timer; 
  int timeLeft = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      router = ref.read(routerProvider.notifier);
      user = ref.read(userProvider.notifier);
      quizData = router.getValues?["quizData"] as Map<String, dynamic>?;
      questionTimer = quizData?["timer"] ?? 30;
      setState(() {
        loading = false;
      });
      startTimer();
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); 
    super.dispose();
  }

  void startTimer() {
    setState(() {
      timeLeft = questionTimer;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft > 0) {
        if (mounted) {
          setState(() {
            timeLeft--;
          });
        }
      } else {
        _timer?.cancel();
        autoNextQuestion();
      }
    });
  }

  void autoNextQuestion() {
    if (selectedAnswer != null) {
      recordAnswer();
    } else {
      userAnswers.add({
        "questionId": quizData!["quizQuestions"][currentQuestionIndex]["id"],
        "answerId": null, 
      });
    }

    if (currentQuestionIndex < (quizData?["quizQuestions"].length ?? 0) - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedAnswer = null;
      });
      startTimer();
    } else {
      _timer?.cancel(); 
      submitQuizAnswers();
    }
  }

  void recordAnswer() {
    final questionId = quizData!["quizQuestions"][currentQuestionIndex]["id"];
    final selectedOption = quizData!["quizQuestions"][currentQuestionIndex]
            ["quizOptions"]
        .firstWhere((option) => option["option"] == selectedAnswer)["id"];

    userAnswers.add({"questionId": questionId, "answerId": selectedOption});
  }

  Future<void> submitQuizAnswers() async {
    if (submittingAnswers) return; 
    submittingAnswers = true;

    setState(() {
      loading = true;
    });

    try {
      final quizId = quizData!["id"];
      final response =
          await ApiHandler.playQuiz(user.token!, quizId, userAnswers);

      if (mounted) {
        setState(() {
          results = response;
          quizCompleted = true;
          loading = false;
        });
      }
    } catch (error) {
      print("Error submitting quiz answers: $error");
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Results for ${quizData!["title"]}",
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                "Score: ${checks.where((check) => check["correct"] == true).length}/${quizData!["quizQuestions"].length}",
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 16),
              Text("Details:",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...checks.map<Widget>((check) {
                final questionId = check["questionId"];
                final answerCorrect = check["correct"] ?? false;
                final questionData = quizData!["quizQuestions"]
                    .firstWhere((q) => q["id"] == questionId);
                final questionText = questionData["question"];
                final answerText = check["answerId"] != null
                    ? questionData["quizOptions"].firstWhere(
                        (option) => option["id"] == check["answerId"])["option"]
                    : "No Answer, Time Ran Out";

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        questionText,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Your answer: $answerText - ${answerCorrect ? "Correct" : "Incorrect"}",
                        style: TextStyle(
                          fontSize: 16,
                          color: answerCorrect ? Colors.green : Colors.red,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      );
    }

    final currentQuestion = quizData!["quizQuestions"][currentQuestionIndex];
    final questionText = currentQuestion["question"] ?? "No question text";
    final List<dynamic> options = currentQuestion["quizOptions"] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(quizData!["title"] ?? "Quiz Game Solo"),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Time left: $timeLeft seconds",
              style: const TextStyle(fontSize: 18, color: Colors.red),
            ),
            const SizedBox(height: 8),
            Text(
              "Question ${currentQuestionIndex + 1}/${quizData!["quizQuestions"].length}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              questionText,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            ...options.map<Widget>((option) {
              final optionText = option["option"];
              return ListTile(
                title: Text(optionText),
                leading: Radio<String>(
                  value: optionText,
                  groupValue: selectedAnswer,
                  onChanged: (value) {
                    setState(() {
                      selectedAnswer = value;
                    });
                  },
                ),
              );
            }).toList(),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: selectedAnswer != null ? autoNextQuestion : null,
              child: Text(
                currentQuestionIndex == quizData!["quizQuestions"].length - 1
                    ? "Finish Quiz"
                    : "Next Question",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
