import 'package:client/elements/bottom_navbar.dart';
import 'package:client/elements/feed_category.dart';
import 'package:client/tools/router.dart';
import 'package:client/tools/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends ConsumerState<Home> {
  late final RouterNotifier router;
  late final UserNotifier user;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      router = ref.read(routerProvider.notifier);
      user = ref.read(userProvider.notifier);
    });
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
