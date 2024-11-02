import 'package:client/elements/bottom_navbar.dart';
import 'package:client/elements/button.dart';
import 'package:client/tools/error_message.dart';
import 'package:client/tools/quiz.dart';
import 'package:client/tools/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateQuiz extends ConsumerStatefulWidget {
  const CreateQuiz({super.key});

  @override
  CreateQuizState createState() => CreateQuizState();
}

class CreateQuizState extends ConsumerState<CreateQuiz> {
  late final RouterNotifier router;
  int _selectedIndex = 0;

  final List<Quiz> questions = [
    Quiz(question: "", options: [
      Option(option: ""),
      Option(option: ""),
    ])
  ];

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  TextEditingController questionController = TextEditingController();

  List<TextEditingController> controllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];



  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      router = ref.read(routerProvider.notifier);
    });
  }

  void onPressed() {
    print("pressed");
  }

  void changeSelectedQuestion(int prev, int newIndex) {
    final prevQuiz = questions[prev];

    questions[prev] = Quiz(
      question: questionController.text,
      options: [
        for (int i = 0; i < prevQuiz.options.length; i++)
          Option(
            option: controllers[i].text,
            isCorrect: prevQuiz.options[i].isCorrect,
          ),
      ],
    );

    questionController.text = questions[newIndex].question;
    for (int i = 0; i < questions[newIndex].options.length; i++) {
      controllers[i].text = questions[newIndex].options[i].option;
    }

    setState(() {
      _selectedIndex = newIndex;
    });
  }

  void addOption(int index) {
    setState(() {
      questions[_selectedIndex].options.add(Option(option: ""));
    });
  }

  void addNewQuestion() {
    if (questions.length >= 25) {
      ErrorHandler.showOverlayError(context, "Maximum of 25 questions");
      return;
    }
    setState(() {
      questions.add(Quiz(question: "", options: [
        Option(option: ""),
        Option(option: ""),
      ]));
    });
  }

  void addImage() {
    
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const topButtonTextStyle = TextStyle(color: Colors.white, fontSize: 12);
    return Scaffold(
      backgroundColor: theme.canvasColor,
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedTextButton(
                textStyle: topButtonTextStyle,
                width: 70,
                height: 30,
                text: "Add desc",
                onPressed: onPressed),
            SizedTextButton(
                textStyle: topButtonTextStyle,
                width: 70,
                height: 30,
                text: "Add time",
                onPressed: onPressed),
            SizedTextButton(
                textStyle: topButtonTextStyle,
                width: 70,
                height: 30,
                text: "Add title",
                onPressed: onPressed),
            SizedTextButton(
                textStyle: topButtonTextStyle,
                width: 70,
                height: 30,
                text: "Save",
                onPressed: onPressed),
            IconButton(
                onPressed: () => router.goBack(context),
                icon: const Icon(Icons.close)),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                print("add image");
              },
              child: Container(
                height: 162,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 217, 217, 217),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(6),
                    topRight: Radius.circular(6),
                  ),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add),
                      Text("Add Image"),
                    ],
                  ),
                ),
              ),
            ),
            TextField(
              controller: questionController,
              decoration: const InputDecoration(
                hintText: "Enter question",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(6),
                    bottomRight: Radius.circular(6),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(6),
                    bottomRight: Radius.circular(6),
                  ),
                  borderSide: BorderSide(
                    color: Colors.orange,
                    width: 2.0,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: questions[_selectedIndex].options.length,
                itemBuilder: (context, index) {
                  if (index >= controllers.length) {
                    controllers.add(TextEditingController());
                  }
                  return Column(
                    children: [
                      TextField(
                        controller: controllers[index],
                        decoration: InputDecoration(
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text("${index + 1}."),
                          ),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: GestureDetector(
                              onTap: () => setState(
                                () {
                                  questions[_selectedIndex]
                                      .options[index]
                                      .setIsCorrect(
                                        !questions[_selectedIndex]
                                            .options[index]
                                            .isCorrect,
                                      );
                                },
                              ),
                              child: questions[_selectedIndex]
                                      .options[index]
                                      .isCorrect
                                  ? const Icon(
                                      Icons.check,
                                      color: Colors.green,
                                    )
                                  : const Icon(
                                      Icons.close,
                                      color: Colors.red,
                                    ),
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: const BorderSide(
                              color: Colors.orange,
                              width: 2.0,
                            ),
                          ),
                        ),
                      ),
                      index < questions[_selectedIndex].options.length
                          ? const SizedBox(height: 5)
                          : const SizedBox(height: 0),
                      questions[_selectedIndex].options.length < 5 &&
                              index ==
                                  questions[_selectedIndex].options.length - 1
                          ? Center(
                              child: SmallTextButton(
                                text: "Add new option",
                                onPressed: () => addOption(_selectedIndex),
                              ),
                            )
                          : const SizedBox(height: 0),
                    ],
                  );
                },
              ),
            )
          ],
        ),
      ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(left: 16, right: 16),
        color: theme.canvasColor,
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 5), // Padding between list and add button
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: [
                    for (int i = 0; i < questions.length; i++)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () =>
                              changeSelectedQuestion(_selectedIndex, i),
                          child: Container(
                            height: 30,
                            width: 80,
                            decoration: BoxDecoration(
                              color: i == _selectedIndex
                                  ? Colors.orange
                                  : Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Center(
                              child: Text(
                                "Question ${i + 1}",
                                style: TextStyle(
                                  color: i == _selectedIndex
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(6),
              ),
              width: 50,
              child: IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  addNewQuestion();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
