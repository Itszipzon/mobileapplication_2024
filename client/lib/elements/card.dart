import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final GestureTapCallback? onTap;
  final IconData icon;
  final String title;
  final int quizCount;

  const CategoryCard({super.key, this.onTap, required this.icon, required this.title, required this.quizCount});

 @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Card(
        color: theme.primaryColor,
        elevation: 4.0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 60.0, color: Colors.white),
            const SizedBox(height: 16.0),
            Flexible(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 20.0, // Default font size
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
                maxLines: 2, // Allow up to 2 lines for long titles
                overflow: TextOverflow.ellipsis, // Add ellipsis for overflow
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              "$quizCount Quizzes",
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}