import 'package:client/tools/api_handler.dart';
import 'package:client/tools/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Category extends ConsumerStatefulWidget {
  const Category({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => CategoryState();
}

class CategoryState extends ConsumerState<Category> {
  late final RouterNotifier router;
  bool loading = true;

  late List<Map<String, dynamic>> quizzes;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      router = ref.read(routerProvider.notifier);

      _initiateQuizzes();
    });
  }

  Future<void> _initiateQuizzes() async {
    ApiHandler.getQuizzesByCategory(router.getValues!["category"], 0)
        .then((value) => {
              setState(() {
                quizzes = value;
                loading = false;
              }),
            });
  }

  @override
  Widget build(BuildContext context) {
    return loading ? SizedBox(height: 0,)
      : ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: quizzes.length,
      itemBuilder: (context, index) {
        final quiz = quizzes[index];
        return Text(quiz["title"].toString());
      },
      );
  }
}