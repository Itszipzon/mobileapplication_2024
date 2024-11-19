import 'package:client/dummy_data.dart';
import 'package:client/elements/bottom_navbar.dart';
import 'package:client/elements/button.dart';
import 'package:client/elements/profile_picture.dart';
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
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            // Profile header section
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    print("Not implemented yet");
                  },
                  child: ClipOval(
                    child: ProfilePicture(url: profile["pfp"]),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "${profile["username"]}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),

            // Button row
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SizedTextButton(
                      text: "Settings",
                      onPressed: () => {router.setPath(context, "settings")},
                      height: 40,
                      textStyle:
                          const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: SizedTextButton(
                      text: "Friends",
                      onPressed: () => router.setPath(context, "friends"),
                      height: 40,
                      textStyle:
                          const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: SizedTextButton(
                      text: "Sign out",
                      onPressed: () => {user.logout(context, router)},
                      height: 40,
                      textStyle:
                          const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            ],
        ),
      ),
      bottomNavigationBar: BottomNavbar(path: "profile"),
    );
  }

}