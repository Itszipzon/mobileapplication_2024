import 'package:flutter/material.dart';
import 'package:client/elements/bottom_navbar.dart';

class Categories extends StatelessWidget {
  const Categories({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF1F1F1), 
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
                  _buildCategoryCard(context, Icons.star, "General", 128),
                  _buildCategoryCard(context, Icons.movie, "Pop Cult", 58),
                  _buildCategoryCard(context, Icons.history, "History", 89),
                  _buildCategoryCard(context, Icons.science, "Science", 69),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavbar(path: "categories"),
    );
  }

  Widget _buildCategoryCard(
      BuildContext context, IconData icon, String title, int quizCount) {
    return Container(
      child: Card(
        color: const Color(0xFFFF8000), 
        elevation: 4.0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero, 
        ),
        child: InkWell(
          onTap: () {
            // Handle category tap
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 60.0, color: Colors.white), 
              const SizedBox(height: 16.0),
              Text(
                title,
                style: const TextStyle(
                    fontSize: 20.0, color: Colors.white), 
              ),
              const SizedBox(height: 8.0),
              Text(
                "$quizCount Quizzes",
                style: const TextStyle(
                    color: Colors.white70), 
              ),
            ],
          ),
        ),
      ),
    );
  }
}
