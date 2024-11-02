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

  final List<Quiz> questions = [];

  void onPressed() {
    print("pressed");
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
                TextField(
                  decoration: InputDecoration(
                    prefixIcon: const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text("1."),
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
                const SizedBox(height: 5),
                TextField(
                  decoration: InputDecoration(
                    prefixIcon: const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text("2."),
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
                const SizedBox(height: 5),
                TextField(
                  decoration: InputDecoration(
                    prefixIcon: const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text("3."),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        print("add answer");
                      },
                      icon: const Icon(Icons.add),
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
                const SizedBox(height: 5),
                TextField(
                  decoration: InputDecoration(
                    prefixIcon: const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text("4."),
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
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavbar(path: "create"),
    );
  }
}
