import 'package:client/elements/bottom_navbar.dart';
import 'package:client/elements/feed_category.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  Home({super.key}) {
    _initPosts();
  }
  
  final List<Widget> posts = [];

  void _initPosts() {
    for (int i = 0; i < 5; i++) {
      if (i == 5 - 1) {
        posts.add(FeedCategory(category: "Category $i"));
      } else {
        Widget post = Column(
          children: [
            const SizedBox(height: 6,),
            FeedCategory(category: "Category $i"),
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
      backgroundColor: const Color.fromARGB(255, 241, 241, 241),
      body: ListView(
        children: posts,
      ),
      bottomNavigationBar: const BottomNavbar(path: "home",),
    );
  }
}