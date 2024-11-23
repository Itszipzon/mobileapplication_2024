import 'package:client/dummy_data.dart';
import 'package:client/elements/bottom_navbar.dart';
import 'package:client/elements/button.dart';
import 'package:client/elements/profile_picture.dart';
import 'package:client/elements/quiz_post.dart';
import 'package:client/tools/api_handler.dart';
import 'package:client/tools/router.dart';
import 'package:client/tools/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Profile extends ConsumerStatefulWidget {
  const Profile({super.key});

  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends ConsumerState<Profile> {
  late final RouterNotifier router;
  late final UserNotifier user;
  Map<String, dynamic> profile = {
    "username": "",
    "pfp": DummyData.profilePicture,
    "lvl": 0,
    "exp": 0,
    "xpToNextLevel": 1,
  };
  late List<Map<String, dynamic>> quizzes = [];
  late List<Map<String, dynamic>> history = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      router = ref.read(routerProvider.notifier);
      user = ref.read(userProvider.notifier);
      _getProfile();
      _getQuizzes(user.token!);
      _getHistory(user.token!);
    });
  }

  void _getProfile() async {
    user.getProfile().then((value) {
      print(value);
      setState(() {
        profile = value;
      });
    });
  }

  void _getQuizzes(String token) async {
    ApiHandler.getUserQuizzesByToken(token, 0, 5).then((value) {
      setState(() {
        quizzes = value;
      });
    });
  }

  void _getHistory(String token) async {
    ApiHandler.getQuizzesByUserHistory(token, 0, 5).then((value) {
      setState(() {
        history = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            // Profile header section
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    print("Not implemented yet");
                  },
                  child: ClipOval(
                    child: ProfilePicture(url: profile["pfp"]),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "${profile["username"]}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Level ${profile["xpToNextLevel"] == -1 ? "Max" : profile["lvl"]}"),
                const SizedBox(width: 10),
                Container(
                  width: 100,
                  height: 10,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.grey,
                  ),
                  child: Stack(
                    children: [
                      Container(
                        width: profile["xpToNextLevel"] == -1
                            ? 100
                            : (profile["exp"] / profile["xpToNextLevel"]) * 100,
                        height: 10,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: theme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Text("${profile["exp"]} / ${profile["xpToNextLevel"]} XP"),
              ],
            ),
            const SizedBox(height: 10),
            // Button row
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SizedTextButton(
                      text: "Settings",
                      icon: const Icon(Icons.settings, color: Colors.white),
                      onPressed: () => {router.setPath(context, "settings")},
                      height: 40,
                      textStyle:
                          const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: SizedTextButton(
                      text: "Friends",
                      icon: const Icon(Icons.people, color: Colors.white),
                      onPressed: () => router.setPath(context, "friends"),
                      height: 40,
                      textStyle:
                          const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: SizedTextButton(
                      text: "Sign out",
                      icon: const Icon(Icons.logout, color: Colors.white),
                      onPressed: () => {user.logout(context, router)},
                      height: 40,
                      textStyle:
                          const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Expanded scrollable area
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // "Your quizzes" section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Your quizzes",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedTextButton(
                          text: "View all",
                          onPressed: () => print("View"),
                          height: 32,
                          width: 73,
                          textStyle: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    quizzes.isNotEmpty
                        ? SizedBox(
                            height: 200,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: quizzes.length,
                              itemBuilder: (context, index) {
                                final quiz = quizzes[index];
                                return Stack(
                                  children: [
                                    // Quiz post content
                                    QuizPost(
                                      id: quiz['id'] ?? '',
                                      profilePicture:
                                          quiz['profile_picture'] ?? '',
                                      title: quiz['title'] ?? '',
                                      username: quiz['username'] ?? '',
                                      createdAt: quiz['createdAt'],
                                    ),

                                    // Three dots menu button in bottom-right corner
                                    Positioned(
                                      right: 8,
                                      bottom: 30,
                                      child: PopupMenuButton<String>(
                                        icon: const Icon(Icons.more_vert),
                                        onSelected: (String result) {
                                          switch (result) {
                                            case 'Edit':
                                              print("Edit quiz ${quiz['id']}");
                                              break;
                                            case 'Delete':
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        'Delete Quiz'),
                                                    content: const Text(
                                                        'Are you sure you want to delete this quiz?'),
                                                    actions: [
                                                      TextButton(
                                                        child: const Text(
                                                            'Cancel'),
                                                        onPressed: () =>
                                                            Navigator.of(
                                                                    context)
                                                                .pop(),
                                                      ),
                                                      TextButton(
                                                        child: const Text(
                                                            'Delete'),
                                                        onPressed: () async {
                                                          try {
                                                            await ApiHandler
                                                                .deleteQuiz(
                                                                    user.token!,
                                                                    quiz['id']);
                                                            Navigator.of(
                                                                    context)
                                                                .pop();

                                                            setState(() {
                                                              quizzes.removeWhere(
                                                                  (q) =>
                                                                      q['id'] ==
                                                                      quiz[
                                                                          'id']);
                                                            });

                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              const SnackBar(
                                                                  content: Text(
                                                                      'Quiz deleted successfully')),
                                                            );
                                                          } catch (e) {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              SnackBar(
                                                                  content: Text(
                                                                      e.toString())),
                                                            );
                                                          }
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                              break;
                                            case 'Share':
                                              print("Share quiz ${quiz['id']}");
                                              break;
                                          }
                                        },
                                        itemBuilder: (BuildContext context) =>
                                            <PopupMenuEntry<String>>[
                                          const PopupMenuItem<String>(
                                            value: 'Edit',
                                            child: Text('Edit'),
                                          ),
                                          const PopupMenuItem<String>(
                                            value: 'Delete',
                                            child: Text('Delete'),
                                          ),
                                          const PopupMenuItem<String>(
                                            value: 'Share',
                                            child: Text('Share'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          )
                        : const SizedBox(
                            height: 200,
                            child: Center(
                              child: Text("No quizzes found"),
                            ),
                          ),
                    const SizedBox(height: 16),

                    // "History" section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "History",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedTextButton(
                          text: "View all",
                          onPressed: () => print("View"),
                          height: 32,
                          width: 73,
                          textStyle: const TextStyle(
                              fontSize: 12, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    history.isNotEmpty
                        ? SizedBox(
                            height: 200,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: history.length,
                              itemBuilder: (context, index) {
                                final quiz = history[index];
                                return QuizPost(
                                  id: quiz['id'] ?? '',
                                  profilePicture: quiz['profile_picture'] ?? '',
                                  title: quiz['title'] ?? '',
                                  username: quiz['username'] ?? '',
                                  createdAt: quiz['createdAt'],
                                );
                              },
                            ),
                          )
                        : const SizedBox(
                            height: 200,
                            child: Center(
                              child: Text("No history found"),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavbar(path: "profile"),
    );
  }
}
