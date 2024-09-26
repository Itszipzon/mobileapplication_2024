import 'package:client/elements/button.dart';
import 'package:flutter/material.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar(
      {super.key, required this.path, required this.switchScreen});

  final String path;
  final Function(BuildContext, String) switchScreen;

  @override
  State<StatefulWidget> createState() {
    return BottomNavbarState();
  }
}

class BottomNavbarState extends State<BottomNavbar> {

  void onPressed(String path) {
    widget.switchScreen(context, 'home');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 241, 241, 241),
      ),
      child: Align(
        alignment: Alignment.center,
        child: SizedBox(
          width: 520,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconTextButton(icon: Icons.feed, text: "Feed", onPressed: () => onPressed("home"), active: widget.path == "home"),
              IconTextButton(
                  icon: Icons.four_k, text: "Categories", onPressed: () => onPressed("categories"), active: widget.path == "categories"),
              IconTextButton(
                  icon: Icons.person, text: "Profile", onPressed: () => onPressed("profile"), active: widget.path == "profile"),
            ],
          ),
        ),
      ),
    );
  }
}
