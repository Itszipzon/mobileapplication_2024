import 'package:client/dummy_data.dart';
import 'package:client/tools/router.dart';
import 'package:client/tools/user.dart';
import 'package:flutter/material.dart';
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
  Map<String, dynamic> profile = {
    "username": "",
    "pfp": DummyData.profilePicture,
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      router = ref.read(routerProvider.notifier);
      user = ref.read(userProvider.notifier);
      loading = false;
      _getProfile();
    });
  }

  Future<void> _getProfile() async {
    user.getProfile().then((value) {
      setState(() {
        profile = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("Settings"),
      ),
    );
  }
}
