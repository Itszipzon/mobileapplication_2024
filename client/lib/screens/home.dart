import 'package:client/elements/bottom_navbar.dart';
import 'package:client/elements/feed_category.dart';
import 'package:client/elements/loading.dart';
import 'package:client/tools/router.dart';
import 'package:client/tools/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:client/tools/api_handler.dart'; // Import the API handler

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends ConsumerState<Home> {
  late final RouterNotifier router;
  late final UserNotifier user;
  late Future<List<Map<String, dynamic>>> _quizDataFuture;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      router = ref.read(routerProvider.notifier);
      user = ref.read(userProvider.notifier);
    });
    _quizDataFuture = ApiHandler.getQuizzesByFilter(0, 5, "createdAt", "DESC");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 241, 241),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _quizDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: LogoLoading());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Error loading quizzes: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final quizData = snapshot.data!;
            return Container(
              padding: const EdgeInsets.all(8),
              child: ListView(
                children: [
                  FeedCategory(category: "Quizzes", quizzes: quizData),
                ],
              ),
            );
          } else {
            return const Center(child: Text('No quizzes available.'));
          }
        },
      ),
      bottomNavigationBar: const BottomNavbar(
        path: "home",
      ),
    );
  }
}
