import 'package:client/elements/bottom_navbar.dart';
import 'package:client/elements/button.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      router = ref.read(routerProvider.notifier);
    });
  }

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

  void onPressed() {
    print("pressed");
  }

  void changeSelectedQuestion(int prev, int newIndex) {
    final prevQuiz = questions[prev];

    questions[prev] = Quiz(
      question: questionController.text,
      options: [
        Option(option: controllers[0].text),
        Option(option: controllers[1].text),
        Option(option: controllers[2].text),
        Option(option: controllers[3].text),
        Option(option: controllers[4].text),
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
                onPressed: () => print("Closing"),
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
            const TextField(
              decoration: InputDecoration(
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
            ListView(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: questions[_selectedIndex].options.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text("${index + 1}."),
                            ),
                            suffixIcon: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: GestureDetector(
                                onTap: () => 
                                  setState(
                                    () {
                                      questions[_selectedIndex]
                                          .options[index]
                                          .setIsCorrect(
                                              !questions[_selectedIndex]
                                                  .options[index]
                                                  .isCorrect);
                                    },
                                  ),
                                child: questions[_selectedIndex]
                                        .options[index]
                                        .isCorrect ?
                                        const Icon(Icons.check, color: Colors.green,)
                                        :
                                        const Icon(Icons.close, color: Colors.red,),
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
                                    onPressed: () => addOption(_selectedIndex)),
                              )
                            : const SizedBox(height: 0),
                      ],
                    );
                  },
                ),
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavbar(path: "create"),
    );
  }
}
