import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:client/elements/button.dart';
import 'package:client/elements/input.dart';
import 'package:client/tools/api_handler.dart';

class Create extends ConsumerStatefulWidget {
  const Create({super.key});

  @override
  CreateScreenState createState() => CreateScreenState();
}

class CreateScreenState extends ConsumerState<Create> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final thumbnailController = TextEditingController();
  final timerController = TextEditingController();

  final List<Map<String, dynamic>> questions = [];
  bool isLoading = false;

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    thumbnailController.dispose();
    timerController.dispose();
    super.dispose();
  }

  void addQuestion() {
    setState(() {
      questions.add({
        'question': '',
        'options': [
          {'option': '', 'correct': false},
          {'option': '', 'correct': false},
        ],
      });
    });
  }

  Future<void> submitQuiz() async {
    if (titleController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        thumbnailController.text.isEmpty ||
        timerController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields.')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    // Build the quiz data payload
    Map<String, dynamic> quizData = {
      'title': titleController.text,
      'description': descriptionController.text,
      'thumbnail': thumbnailController.text,
      'timer': int.parse(timerController.text),
      'quizQuestions': questions.map((question) {
        return {
          'question': question['question'],
          'quizOptions': question['options'].map((option) {
            return {
              'option': option['option'],
              'correct': option['correct'],
            };
          }).toList(),
        };
      }).toList(),
    };

    // Send the POST request
    final response = await ApiHandler.createQuiz(quizData);

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Quiz created successfully!')),
      );
      Navigator.of(context).pop(); // Go back to the previous screen
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to create quiz.')),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Quiz"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Input(
              labelText: "Title",
              controller: titleController,
            ),
            const SizedBox(height: 16),
            Input(
              labelText: "Description",
              controller: descriptionController,
            ),
            const SizedBox(height: 16),
            Input(
              labelText: "Thumbnail URL",
              controller: thumbnailController,
            ),
            const SizedBox(height: 16),
            Input(
              labelText: "Timer (in seconds)",
              controller: timerController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            const Text(
              "Questions",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...questions.map((question) {
              int index = questions.indexOf(question);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text("Question ${index + 1}"),
                  Input(
                    labelText: "Question Text",
                    onChanged: (value) {
                      setState(() {
                        question['question'] = value;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  ...question['options'].map<Widget>((option) {
                    int optionIndex = question['options'].indexOf(option);
                    return Row(
                      children: [
                        Expanded(
                          child: Input(
                            labelText: "Option ${optionIndex + 1}",
                            onChanged: (value) {
                              setState(() {
                                option['option'] = value;
                              });
                            },
                          ),
                        ),
                        Checkbox(
                          value: option['correct'],
                          onChanged: (value) {
                            setState(() {
                              option['correct'] = value;
                            });
                          },
                        ),
                      ],
                    );
                  }).toList(),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        question['options'].add({'option': '', 'correct': false});
                      });
                    },
                    child: const Text("Add Option"),
                  ),
                ],
              );
            }).toList(),
            TextButton(
              onPressed: addQuestion,
              child: const Text("Add Question"),
            ),
            const SizedBox(height: 16),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
              onPressed: submitQuiz,
              child: const Text("Submit Quiz"),
            ),
          ],
        ),
      ),
    );
  }
}