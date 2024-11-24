import 'package:client/dummy_data.dart';
import 'package:client/elements/button.dart';
import 'package:client/elements/input.dart';
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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Change Username", style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),),
          const SizedBox(height: 10),
          Row(
            children: [
              Flexible(
                child: Input(
                  labelText: "Username",
                  icon: Icons.person,
                  onChanged: (value) {},
                ),
              ),
              const SizedBox(width: 10),
              SizedTextButton(
                text: "Check",
                onPressed: () => print(""),
                height: 50,
                width: 75,
                textStyle: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(height: 15,
          child: Text("Username availability text will come here!"),
          ),
          const SizedBox(height: 10),
          const Divider(),
          const SizedBox(height: 10),
          const Text("Change Password", style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),),
          const SizedBox(height: 10),
          Row(
            children: [
              Flexible(
                child: Input(
                  labelText: "Old Password",
                  obscureText: true,
                  icon: Icons.lock,
                  onChanged: (value) {},
                ),
              ),
              const SizedBox(width: 10),
              SizedTextButton(
                text: "Show",
                onPressed: () => print(""),
                height: 50,
                width: 75,
                textStyle: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Flexible(
                child: Input(
                  labelText: "New Password",
                  obscureText: true,
                  icon: Icons.lock,
                  onChanged: (value) {},
                ),
              ),
              const SizedBox(width: 10),
              SizedTextButton(
                text: "Show",
                onPressed: () => print(""),
                height: 50,
                width: 75,
                textStyle: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Flexible(
                child: Input(
                  labelText: "Confirm Password",
                  obscureText: true,
                  icon: Icons.lock,
                  onChanged: (value) {},
                ),
              ),
              const SizedBox(width: 10),
              SizedTextButton(
                text: "Show",
                onPressed: () => print(""),
                height: 50,
                width: 75,
                textStyle: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
