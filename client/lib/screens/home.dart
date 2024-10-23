import 'package:client/elements/bottom_navbar.dart';
import 'package:client/elements/feed_category.dart';
import 'package:client/tools/router.dart';
import 'package:client/tools/router_provider.dart';
import 'package:client/tools/user.dart';
import 'package:client/tools/user_provider.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  late final RouterState router;
  late final User user;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      router = RouterProvider.of(context);
      user = UserProvider.of(context);
      _checkUserSession();
    });
    _initPosts();
  }

  final List<Widget> posts = [];

  Future<void> _checkUserSession() async {
/*     if (!await user.inSession()) {
      if (mounted) {
        router.setPath(context, '');
      }
    } else {
      _initPosts();
    } */
  }

  void _initPosts() {
    for (int i = 0; i < 5; i++) {
      if (i == 5 - 1) {
        posts.add(FeedCategory(category: "Category $i"));
      } else {
        Widget post = Column(
          children: [
            const SizedBox(
              height: 6,
            ),
            FeedCategory(category: "Category $i"),
            Container(
              color: Colors.grey,
              child: (const SizedBox(
                height: 1,
                width: double.infinity,
              )),
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
      bottomNavigationBar: const BottomNavbar(
        path: "home",
      ),
    );
  }
}
