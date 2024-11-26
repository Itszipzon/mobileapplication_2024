import 'package:client/dummy_data.dart';
import 'package:client/elements/button.dart';
import 'package:client/elements/input.dart';
import 'package:client/tools/router.dart';
import 'package:client/tools/user.dart';
import 'package:client/tools/api_handler.dart'; // Import ApiHandler
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

  // State variables for Change Email
  String newEmail = '';
  bool isUpdatingEmail = false;

  // State variables for Change Username
  String newUsername = '';
  bool isUpdatingUsername = false;

  // State variables for Change Password
  String oldPassword = '';
  String newPassword = '';
  String confirmPassword = '';
  bool isUpdatingPassword = false;

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

  // Function to update email
  Future<void> _updateEmail() async {
    setState(() {
      isUpdatingEmail = true;
    });

    try {
      final token = user.token;
      if (token == null) throw Exception("User is not authenticated.");

      await ApiHandler.updateUser(token, newEmail: newEmail);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email updated successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update email: $e")),
      );
    } finally {
      setState(() {
        isUpdatingEmail = false;
      });
    }
  }

  // Function to update username
  Future<void> _updateUsername() async {
    setState(() {
      isUpdatingUsername = true;
    });

    try {
      final token = user.token;
      if (token == null) throw Exception("User is not authenticated.");

      await ApiHandler.updateUser(token, newUsername: newUsername);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Username updated successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update username: $e")),
      );
    } finally {
      setState(() {
        isUpdatingUsername = false;
      });
    }
  }

  // Function to update password
  Future<void> _updatePassword() async {
    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    setState(() {
      isUpdatingPassword = true;
    });

    try {
      final token = user.token;
      if (token == null) throw Exception("User is not authenticated.");

      await ApiHandler.updateUser(
        token,
        oldPassword: oldPassword,
        newPassword: newPassword,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password updated successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update password: $e")),
      );
    } finally {
      setState(() {
        isUpdatingPassword = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Change Username Section
          const Text(
            "Change Username",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Flexible(
                child: Input(
                  labelText: "Username",
                  icon: Icons.person,
                  onChanged: (value) {
                    setState(() {
                      newUsername = value;
                    });
                  },
                ),
              ),
              const SizedBox(width: 10),
              isUpdatingUsername
                  ? const CircularProgressIndicator()
                  : SizedTextButton(
                      text: "Update",
                      onPressed: () {
                        if (newUsername.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Please enter a new username.")),
                          );
                          return;
                        }
                        _updateUsername();
                      },
                      height: 50,
                      width: 75,
                      textStyle: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
            ],
          ),
          const Divider(),
          const SizedBox(height: 10),

          // Change Password Section
          const Text(
            "Change Password",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Input(
            labelText: "Old Password",
            obscureText: true,
            icon: Icons.lock,
            onChanged: (value) {
              setState(() {
                oldPassword = value;
              });
            },
          ),
          const SizedBox(height: 10),
          Input(
            labelText: "New Password",
            obscureText: true,
            icon: Icons.lock,
            onChanged: (value) {
              setState(() {
                newPassword = value;
              });
            },
          ),
          const SizedBox(height: 10),
          Input(
            labelText: "Confirm Password",
            obscureText: true,
            icon: Icons.lock,
            onChanged: (value) {
              setState(() {
                confirmPassword = value;
              });
            },
          ),
          const SizedBox(height: 10),
          isUpdatingPassword
              ? const CircularProgressIndicator()
              : SizedTextButton(
                  text: "Update",
                  onPressed: () {
                    if (oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please fill in all password fields.")),
                      );
                      return;
                    }
                    _updatePassword();
                  },
                  height: 50,
                  width: 75,
                  textStyle: const TextStyle(fontSize: 16, color: Colors.white),
                ),
          const Divider(),
          const SizedBox(height: 10),

          // Change Email Section
          const Text(
            "Change Email",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Flexible(
                child: Input(
                  labelText: "Email",
                  icon: Icons.email,
                  onChanged: (value) {
                    setState(() {
                      newEmail = value;
                    });
                  },
                ),
              ),
              const SizedBox(width: 10),
              isUpdatingEmail
                  ? const CircularProgressIndicator()
                  : SizedTextButton(
                      text: "Update",
                      onPressed: () {
                        if (newEmail.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Please enter a new email.")),
                          );
                          return;
                        }
                        _updateEmail();
                      },
                      height: 50,
                      width: 75,
                      textStyle: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }
}
