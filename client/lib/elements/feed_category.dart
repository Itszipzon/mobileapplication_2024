import 'package:client/dummy_data.dart';
import 'package:client/elements/quiz_post.dart';
import 'package:flutter/material.dart';

class FeedCategory extends StatelessWidget {
  const FeedCategory({super.key, required this.category});

  final String category;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(left: 16),
          child: Text(category,
              style:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 10,
            itemBuilder: (context, index) {
              return QuizPost(path: "", thumbnail: DummyData.thumbnail, profilePicture: DummyData.profilePicture);
            },
          ),
        ),
      ],
    );
  }
}
