import 'package:client/elements/card.dart';
import 'package:client/tools/api_handler.dart';
import 'package:client/tools/router.dart';
import 'package:flutter/material.dart';
import 'package:client/elements/bottom_navbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Categories extends ConsumerWidget {
  const Categories({super.key});
  
  

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    late RouterNotifier router = ref.watch(routerProvider.notifier);

  Future<List<String>> allCategories = ApiHandler.getQuizCategories();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "I want to learn ....",
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            FutureBuilder<List<String>>(
              future: allCategories,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // Show a loading spinner while waiting
                }
                if (snapshot.hasError) {
                  return const Text("Error loading categories");
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text("No categories available");
                }

                // Get the list of categories once the Future completes
                List<String> categories = snapshot.data!;

                String selectedCategory = categories[0];

                return Column(
                  children: [
                    // Dropdown button to select a category
                    DropdownButton<String>(
                      value: selectedCategory,
                      onChanged: (newCategory) {
                        if (newCategory != null) {
                          selectedCategory = newCategory;
                          // You can route or filter quizzes based on the selected category
                          // For example: router.setPath(context, "category", values: {"category": newCategory});
                        }
                      },
                      items: categories.map<DropdownMenuItem<String>>((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_drop_down),
                      hint: const Text("Select Category"),
                    ),
                    const SizedBox(height: 16.0),
                    const Divider(), // A divider to separate dropdown from the grid
                    const SizedBox(height: 16.0),
                  ],
                );
              },
            ),

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
