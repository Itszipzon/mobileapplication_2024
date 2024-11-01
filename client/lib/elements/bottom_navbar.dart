import 'package:client/elements/button.dart';
import 'package:client/tools/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomNavbar extends ConsumerWidget {
  final String path;
  const BottomNavbar({super.key, required this.path});

  void onPressed(BuildContext context, String path, RouterNotifier router) {
    router.setPath(context, path);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.read(routerProvider.notifier);
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
                  active: path == "home",
                ),
              ),
              Expanded(
                child: IconTextButton(
                  icon: Icons.grid_view,
                  text: "Categories",
                  onPressed: () => onPressed(context, "categories", router),
                  active: path == "categories",
                ),
              ),
              BigIconButton(
                height: 56,
                width: 56,
                icon: Icons.add,
                onPressed: () => onPressed(context, "create", router),
              ),
              Expanded(
                child: IconTextButton(
                  icon: Icons.play_arrow_rounded,
                  text: "Join Game",
                  onPressed: () => onPressed(context, "join", router),
                  active: path == "join",
                ),
              ),
              Expanded(
                child: IconTextButton(
                  icon: Icons.person,
                  text: "Profile",
                  onPressed: () => onPressed(context, "profile", router),
                  active: path == "profile",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
