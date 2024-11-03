import 'package:client/dummy_data.dart';
import 'package:client/elements/bottom_navbar.dart';
import 'package:client/elements/button.dart';
import 'package:client/tools/api_handler.dart';
import 'package:client/tools/error_message.dart';
import 'package:client/tools/router.dart';
import 'package:client/tools/tools.dart';
import 'package:client/tools/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuizScreen extends ConsumerStatefulWidget {
  const QuizScreen({super.key});

  @override
  QuizScreenState createState() => QuizScreenState();
}

class QuizScreenState extends ConsumerState<QuizScreen> {
  late final RouterNotifier router;
  late final UserNotifier user;
  bool isLoading = true;

  late Map<String, dynamic> quiz;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      router = ref.read(routerProvider.notifier);
      user = ref.read(userProvider.notifier);
      if (router.getValues == null || router.getValues!['id'] == null) {
        ErrorHandler.showOverlayError(context, 'No quiz found.');
        router.setPath(context, 'home');
      } else {
        _getQuiz();
      }
    });
  }

  Future<void> _getQuiz() async {
    final response =
        await ApiHandler.getQuiz(int.parse(router.getValues!['id'].toString()));

    if (response.isEmpty) {
      ErrorHandler.showOverlayError(context, 'Failed to load quiz.');
      router.setPath(context, 'home');
    } else {
      final profilePicture =
          await ApiHandler.getProfilePicture(response['username']);

      setState(() {
        quiz = response;
        quiz['pfp'] = profilePicture;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Container(
        color: theme.canvasColor,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              isLoading
                  ? DummyData.thumbnail
                  : '${ApiHandler.url}/api/quiz/thumbnail/${router.getValues!['id']}',
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                ClipOval(
                  child: Image.network(
                    isLoading ? DummyData.profilePicture : quiz['pfp'],
                    width: 49,
                    height: 49,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isLoading ? "" : quiz['title'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Text(isLoading ? "" : quiz['username'].toString()),
                        const SizedBox(width: 4),
                        const Text("|"),
                        const SizedBox(width: 4),
                        Text(isLoading
                            ? ""
                            : Tools.formatCreatedAt(DateTime(
                                quiz['createdAt'][0],
                                quiz['createdAt'][1],
                                quiz['createdAt'][2],
                                quiz['createdAt'][3],
                                quiz['createdAt'][4],
                                quiz['createdAt'][5],
                              ))),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              color: Colors.grey,
              height: 0.5,
            ),
            const SizedBox(height: 8),
            SizedTextButton(
              text: "Play",
              onPressed: () => print("Play"),
              width: double.infinity,
              height: 50,
              textStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 8),
            SizedTextButton(
              text: "Play with friends",
              onPressed: () => print("Play with friends"),
              width: double.infinity,
              inversed: true,
              height: 50,
              textStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange),
            ),
            const SizedBox(height: 8),
            Container(
              color: Colors.grey,
              height: 0.5,
            ),
            const SizedBox(height: 8),
            Text(
              isLoading ? "" : quiz['description'],
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavbar(path: "quiz"),
    );
  }
}
