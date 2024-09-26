import 'package:client/elements/quiz_post.dart';
import 'package:client/elements/small_button.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  Home({super.key, required this.switchScreen}) {
    _initPosts();
  }

  final Function(BuildContext, String) switchScreen;
  
  final List<Widget> posts = [];

  void _initPosts() {

    for (int i = 0; i < 5; i++) {
      if (i == 5 - 1) {
        posts.add(const QuizPost());
      } else {
        Widget post = Column(
          children: [
            const SizedBox(height: 20,),
            const QuizPost(),
            Container(
              color: Colors.grey,
              child: (const SizedBox(height: 1, width: double.infinity,)),
            )
          ],
        );
        posts.add(post);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: posts,
      )
    );
  }
}