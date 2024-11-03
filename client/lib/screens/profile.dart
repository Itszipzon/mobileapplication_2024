import 'package:client/elements/bottom_navbar.dart';
import 'package:client/elements/button.dart';
import 'package:client/elements/loading.dart';
import 'package:client/elements/profile_picture.dart';
import 'package:client/tools/router.dart';
import 'package:client/tools/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Profile extends ConsumerStatefulWidget {
  const Profile({super.key});

  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends ConsumerState<Profile> {
  late final RouterNotifier router;
  late final UserNotifier user;
  Map<String, dynamic> profile = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      router = ref.read(routerProvider.notifier);
      user = ref.read(userProvider.notifier);
      _getProfile();
    });
  }

  void _getProfile() async {
    user.getProfile().then((value) {
      setState(() {
        profile = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return profile.isEmpty
        ? Scaffold(
            backgroundColor: theme.canvasColor,
            body: const Center(
              child: LogoLoading(),
            ),
            bottomNavigationBar: const BottomNavbar(path: "profile"),
          )
        : Scaffold(
            backgroundColor: theme.canvasColor,
            body: Container(
              margin: const EdgeInsets.all(10),
              child: Column(
                children: [
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
                      const SizedBox(width: 10,),
                      Text(
                        "${profile["username"]}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedTextButton(text: "Settings", onPressed: () => {print("Settings")}, height: 40, width: 128, textStyle: const TextStyle(fontSize: 16, color: Colors.white),),
                      SizedTextButton(text: "Other", onPressed: () => {print("Other")}, height: 40, width: 128, textStyle: const TextStyle(fontSize: 16, color: Colors.white),),
                      SizedTextButton(text: "Sign out", onPressed: () => {user.logout(context, router)}, height: 40, width: 128, textStyle: const TextStyle(fontSize: 16, color: Colors.white),),
                    ],
                  )
                ],
              ),
            ),
            bottomNavigationBar: const BottomNavbar(path: "profile"),
          );
  }
}
