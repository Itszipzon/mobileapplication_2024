import 'package:client/elements/card.dart';
import 'package:flutter/material.dart';
import 'package:client/elements/bottom_navbar.dart';

class Categories extends StatelessWidget {
  const Categories({super.key});

  @override
  Widget build(BuildContext context) {
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
                children: const [
                  CategoryCard(icon: Icons.star, title: "General", quizCount: 128),
                  CategoryCard(icon: Icons.movie, title: "Pop Cult", quizCount: 58),
                  CategoryCard(icon: Icons.history, title: "History", quizCount: 89),
                  CategoryCard(icon: Icons.science, title: "Science", quizCount: 69),
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
