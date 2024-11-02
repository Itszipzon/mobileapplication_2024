import 'package:client/elements/bottom_navbar.dart';
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
    return profile.isEmpty
        ? const Scaffold(
            body: Center(
              child: LogoLoading(),
            ),
            bottomNavigationBar: BottomNavbar(path: "profile"),
          )
        : Scaffold(
            body: Container(
              margin: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    // Profile Picture and Name
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "@${profile["username"]}",
                          ),
                          Text(
                            profile["email"].toString(),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Row(
                    //
                    children: [],
                  )
                ],
              ),
            ),
            bottomNavigationBar: const BottomNavbar(path: "profile"),
          );
  }
}
