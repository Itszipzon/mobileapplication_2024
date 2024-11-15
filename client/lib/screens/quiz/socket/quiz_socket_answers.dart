import 'package:client/elements/counter.dart';
import 'package:client/tools/router.dart';
import 'package:client/tools/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuizSocketAnswers extends ConsumerStatefulWidget {
  const QuizSocketAnswers({
    super.key,
    required this.router,
    required this.user,
    required this.values,
    required this.onClick,
    required this.onTimer,
  });

  final RouterNotifier router;
  final UserNotifier user;
  final Map<String, dynamic> values;
  final Function onClick;
  final Function onTimer;

  @override
  QuizSocketAnswersState createState() => QuizSocketAnswersState();
}

class QuizSocketAnswersState extends ConsumerState<QuizSocketAnswers> {
  late final RouterNotifier router;
  late final UserNotifier user;
  bool isLoading = true;
  bool isAnswered = false;

  bool showAnswer = false;

  String thumbnail = "";
  String title = "Loading...";
  int counter = 5;
  String state = "countdown";
  Map<String, dynamic> questionData = {
    "question": "Loading...",
    "options": [{}]
  };
  Map<String, dynamic> answer = {"option": "", "id": -1};

  @override
  void initState() {
    super.initState();
    _initStates();
    _setAnswer();
    print(widget.values);
  }

  void _initStates() {
    setState(() {
      title = widget.values['quiz']['title'];
      questionData = widget.values['quizQuestions']["questions"];
    });
    setState(() {
      isLoading = false;
    });
  }

  void _setAnswer() {
    final username = widget.values["username"];
    final players = widget.values["players"] as List<dynamic>;
    final player = players.firstWhere(
      (player) => player["username"] == username,
      orElse: () => null,
    );

    if (player != null &&
        player["answers"] is List &&
        player["answers"].isNotEmpty) {
      setState(() {
        answer = player["answers"].last; // Use the last answer
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
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
            questionData['question'] ?? "No question found",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: 350,
          height: 350,
          child: ListView.builder(
            itemCount: questionData['quizOptions'].length ?? 0,
            itemBuilder: (context, index) {
              final option = questionData['quizOptions'][index];
              final isCorrect = widget.values["lastCorrectAnswers"]
                  .contains(option['id']);
              final isSelected = answer["id"] ==
                  option['id'];

              return Container(
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: isSelected
                      ? (isCorrect
                          ? Border.all(
                              color: Colors.green)
                          : Border.all(
                              color: Colors.red))
                      : (isCorrect
                          ? Border.all(color: Colors.green)
                          : Border.all(color: theme.primaryColor)),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                margin: EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      option['option'] ?? "",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    if (isSelected)
                      Icon(
                        isCorrect
                            ? Icons.check
                            : Icons.close,
                        color: isCorrect
                            ? Colors.green
                            : Colors.red,
                      )
                  ],
                ),
              );
            },
          ),
        ),
        Center(
          child: Counter(
              onCountdownComplete: () =>
                  widget.onTimer(widget.values["message"] != "showAnswer"),
              duration: 5,
              marginTop: 16),
        )
      ],
    );
  }
}