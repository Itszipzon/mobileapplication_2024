import 'package:client/elements/quiz_post.dart';
import 'package:client/tools/api_handler.dart';
import 'package:flutter/material.dart';

class FeedCategory extends StatelessWidget {
  const FeedCategory({
    super.key,
    required this.category,
    required this.quizzes,
  });

  final String category;
  final List<Map<String, dynamic>> quizzes;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadProfilePictures(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  category,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: quizzes.length,
                  itemBuilder: (context, index) {
                    final quiz = quizzes[index];
                    return QuizPost(
                      id: quiz['id'] ?? '',
                      profilePicture: quiz['profile_picture'] ?? '',
                      title: quiz['title'] ?? '',
                      username: quiz['username'] ?? '',
                      createdAt: DateTime(
                        quiz['createdAt'][0],
                        quiz['createdAt'][1],
                        quiz['createdAt'][2],
                        quiz['createdAt'][3],
                        quiz['createdAt'][4],
                        quiz['createdAt'][5],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }
      },
    );
  }

  Future<void> _loadProfilePictures() async {
    for (var quiz in quizzes) {
      quiz["profile_picture"] = await ApiHandler.getProfilePicture(quiz["username"]);
    }
  }
}
