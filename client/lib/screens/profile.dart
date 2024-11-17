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
      print(value);
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
                      onPressed: () => {print("Settings")},
                      height: 40,
                      textStyle:
                          const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: SizedTextButton(
                      text: "Other",
                      onPressed: () => {print("Other")},
                      height: 40,
                      textStyle:
                          const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: SizedTextButton(
                      text: "Sign out",
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
                                          // Handle menu options here
                                          switch (result) {
                                            case 'Edit':
                                              print("Edit quiz ${quiz['id']}");
                                              break;
                                            case 'Delete':
                                              print(
                                                  "Delete quiz ${quiz['id']}");
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
