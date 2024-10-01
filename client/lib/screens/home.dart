import 'package:client/elements/bottom_navbar.dart';
import 'package:client/elements/quiz_post.dart';
import 'package:client/tools/router.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  Home({super.key, required this.router}) {
    _initPosts();
  }

  final RouterState router;
  
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
      backgroundColor: Color.fromARGB(255, 241, 241, 241),
      body: ListView(
        children: posts,
      ),
      bottomNavigationBar: BottomNavbar(path: "home", router: router,),
    );
  }
}