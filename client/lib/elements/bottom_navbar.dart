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

  void onPressed(BuildContext context, String path) {
    widget.switchScreen(context, path);
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
              IconTextButton(icon: Icons.local_fire_department, text: "Feed", onPressed: () => onPressed(context, "home"), active: widget.path == "home"),
              IconTextButton(
                  icon: Icons.grid_view, text: "Categories", onPressed: () => onPressed(context, "categories"), active: widget.path == "categories"),
              IconTextButton(
                  icon: Icons.person, text: "Profile", onPressed: () => onPressed(context, "profile"), active: widget.path == "profile"),
            ],
          ),
        ),
      ),
    );
  }
}
