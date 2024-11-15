import 'package:client/elements/counter.dart';
import 'package:client/tools/router.dart';
import 'package:client/tools/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuizSocketQuestion extends ConsumerStatefulWidget {
  const QuizSocketQuestion(
      {super.key,
      required this.router,
      required this.user,
      required this.values,
      required this.onClick,
      required this.onTimer});

  final RouterNotifier router;
  final UserNotifier user;
  final Map<String, dynamic> values;
  final Function onClick;
  final Function onTimer;

  @override
  QuizSocketQuestionState createState() => QuizSocketQuestionState();
}

class QuizSocketQuestionState extends ConsumerState<QuizSocketQuestion> {
  late final RouterNotifier router;
  late final UserNotifier user;
  bool isLoading = true;
  bool isAnswered = false;
  Map<String, dynamic> answer = {"option": "", "id": -1};

  bool showAnswer = false;

  String thumbnail = "";
  String title = "Loading...";
  int counter = 0;
  String state = "countdown";
  Map<String, dynamic> questionData = {
    "question": "Loading...",
    "options": [{}]
  };

  @override
  void initState() {
    super.initState();
    _initStates();
  }

  void _initStates() {
    setState(() {
      title = widget.values['quiz']['title'];
      counter = widget.values['quiz']['timer'];
      questionData = widget.values['quizQuestions']["questions"];
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Positioned(
          bottom: 10,
          child: Counter(
              height: 70,
              width: 70,
              onCountdownComplete: () =>
                  widget.onTimer(widget.values["message"] != "showAnswer"),
              duration: widget.values['quiz']['timer'],
              marginTop: 16),
        ),
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
        isAnswered
            ? SizedBox(
                height: 350,
                child: Center(
                  child: Text(
                    answer['option'],
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              )
            : SizedBox(
                width: 350,
                height: 350,
                child: ListView.builder(
                  itemCount: questionData['quizOptions'].length ?? 0,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          answer = questionData['quizOptions'][index];
                          isAnswered = true;
                        });
                        widget.onClick({
                          "answer": questionData['quizOptions'][index]
                              ['option'],
                          "answerId": questionData['quizOptions'][index]['id'],
                        });
                      },
                      child: Container(
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: theme.primaryColor),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              questionData['quizOptions'][index]['option'] ??
                                  "",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
      ],
    );
  }
}
