import 'package:client/elements/bottom_navbar.dart';
import 'package:client/tools/router.dart';
import 'package:client/tools/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Settings extends ConsumerStatefulWidget {

  const Settings({super.key});

  @override
  SettingsState createState() => SettingsState();

}

class SettingsState extends ConsumerState<Settings> {
  late final RouterNotifier router;
  late final UserNotifier user;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      router = ref.read(routerProvider.notifier);
      user = ref.read(userProvider.notifier);
      loading = false;
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text("Settings"),
        ),
      ),
      bottomNavigationBar: BottomNavbar(path: "profile"),
    );
  }

}