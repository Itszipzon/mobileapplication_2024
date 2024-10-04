import 'package:client/elements/button.dart';
import 'package:client/tools/router.dart';
import 'package:client/tools/router_provider.dart';
import 'package:flutter/material.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key, required this.path});

  final String path;

  @override
  State<StatefulWidget> createState() {
    return BottomNavbarState();
  }
}

class BottomNavbarState extends State<BottomNavbar> {
  void onPressed(BuildContext context, String path, RouterState router) {
    router.setPath(context, path);
  }

  @override
  Widget build(BuildContext context) {
    final router = RouterProvider.of(context);
    final theme = Theme.of(context);
    return Container(
      color: theme.canvasColor,
      height: 80,
      child: Align(
        alignment: Alignment.center,
        child: SizedBox(
          width: 492,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: IconTextButton(
                  icon: Icons.local_fire_department,
                  text: "Feed",
                  onPressed: () => onPressed(context, "home", router),
                  active: widget.path == "home",
                ),
              ),
              Expanded(
                child: IconTextButton(
                  icon: Icons.grid_view,
                  text: "Categories",
                  onPressed: () => onPressed(context, "categories", router),
                  active: widget.path == "categories",
                ),
              ),
              SizedBox(
                width: 40, // Adjust the width as needed
                height: 40, // Adjust the height as needed
                child: BigIconButton(
                  icon: Icons.add,
                  onPressed: () => onPressed(context, "create", router),
                ),
              ),
              Expanded(
                child: IconTextButton(
                  icon: Icons.play_arrow,
                  text: "Join",
                  onPressed: () => onPressed(context, "join", router),
                  active: widget.path == "join",
                ),
              ),
              Expanded(
                child: IconTextButton(
                  icon: Icons.person,
                  text: "Profile",
                  onPressed: () => onPressed(context, "profile", router),
                  active: widget.path == "profile",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
