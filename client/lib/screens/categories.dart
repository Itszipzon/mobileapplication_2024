import 'package:client/elements/card.dart';
import 'package:client/tools/router.dart';
import 'package:flutter/material.dart';
import 'package:client/elements/bottom_navbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Categories extends ConsumerWidget {
  const Categories({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    late RouterNotifier router = ref.watch(routerProvider.notifier);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "I want to learn ....",
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 120.0),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                children: [
                  GestureDetector(
                    onTap: () => router.setPath(context, "category",
                        values: {"category": "general knowledge"}),
                    child: CategoryCard(
                        icon: Icons.star, title: "General", quizCount: 128),
                  ),
                  GestureDetector(
                    onTap: () => router.setPath(context, "category",
                        values: {"category": "pop culture"}),
                    child: CategoryCard(
                        icon: Icons.movie, title: "Pop Cult", quizCount: 58),
                  ),
                  GestureDetector(
                    onTap: () => router.setPath(context, "category",
                        values: {"category": "history"}),
                    child: CategoryCard(
                        icon: Icons.history, title: "History", quizCount: 89),
                  ),
                  GestureDetector(
                    onTap: () => router.setPath(context, "category",
                        values: {"category": "science"}),
                    child: CategoryCard(
                        icon: Icons.science, title: "Science", quizCount: 69),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavbar(path: "categories"),
    );
  }
}
