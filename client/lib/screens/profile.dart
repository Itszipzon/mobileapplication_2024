import 'package:client/elements/bottom_navbar.dart';
import 'package:client/elements/profile_picture.dart';
import 'package:client/tools/router.dart';
import 'package:client/tools/router_provider.dart';
import 'package:client/tools/user.dart';
import 'package:client/tools/user_provider.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  late final RouterState router;
  late final User user;
  Map<String, dynamic> profile = {"username": "", "email": "", "pfp": ""};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      router = RouterProvider.of(context);
      user = UserProvider.of(context);
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
    return Scaffold(
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
                    child: ProfilePicture(url: profile["pfp"].toString()),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile["username"].toString().isEmpty
                          ? "Loading..."
                          : "@${profile["username"]}",
                    ),
                    Text(
                      profile["email"].toString().isEmpty
                          ? "Loading..."
                          : profile["email"].toString(),
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
