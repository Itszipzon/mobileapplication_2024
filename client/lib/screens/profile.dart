import 'package:client/elements/bottom_navbar.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileSection(),
            const SizedBox(height: 16),
            _buildSectionTitle('History', onViewAllPressed: () {}),
            _buildQuizList(),
            const SizedBox(height: 16),
            _buildSectionTitle('Your quizzes', onViewAllPressed: () {}),
            _buildQuizList(),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavbar(
        path: "profile"
        ),
    );
  }

  Widget _buildProfileSection() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 40,
          backgroundImage: AssetImage('assets/profile.jpg'), // Replace with actual image
        ),
        const SizedBox(width: 16),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Jan Nordskog",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              "@19232",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
          ),
          child: const Text("Sign out"),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, {required VoidCallback onViewAllPressed}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        TextButton(
          onPressed: onViewAllPressed,
          child: const Text(
            "View all",
            style: TextStyle(color: Colors.orange),
          ),
        ),
      ],
    );
  }

  Widget _buildQuizList() {
    return SizedBox(
      height: 120, // Adjust height based on the card size
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildQuizCard('assets/csgo.jpg', 'CSGO Global', 'Rune molander'),
            _buildQuizCard('assets/starwars.jpg', 'Starwars quiz', 'Jan Nordskog'),
            _buildQuizCard('assets/ironman.jpg', 'Tony Stark quiz', 'Avnit'),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizCard(String imagePath, String title, String author) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),  // Right padding for space between cards
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              imagePath,
              width: 120,    // Adjust width
              height: 80,    // Adjust height
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(author, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}