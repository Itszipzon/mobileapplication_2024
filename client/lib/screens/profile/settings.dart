import 'package:client/dummy_data.dart';
import 'package:client/elements/button.dart';
import 'package:client/elements/input.dart';
import 'package:client/tools/router.dart';
import 'package:client/tools/user.dart';
import 'package:client/tools/api_handler.dart';
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
  bool showOldPassword = false;
  bool showNewPassword = false;

  Map<String, dynamic> profile = {
    "username": "",
    "email": "",
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

  // Show the logout confirmation dialog
  Future<bool> _showLogoutDialog(BuildContext context) async {
    final navigator = Navigator.of(context);

    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Logout Required"),
          content: const Text(
            "You need to log out for changes to take effect. Press 'Confirm' to log out or 'Cancel' to discard changes.",
          ),
          actions: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Confirm button
                SizedTextButton(
                  text: "Confirm",
                  onPressed: () {
                    navigator.pop(true); // Close dialog and return true
                  },
                  height: 40,
                  textStyle:
                      const TextStyle(fontSize: 16, color: Colors.white),
                ),
                const SizedBox(height: 10),
                // Cancel button
                SizedTextButton(
                  text: "Cancel",
                  onPressed: () {
                    navigator.pop(false); // Close dialog and return false
                  },
                  height: 40,
                  textStyle:
                      const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ],
            ),
          ],
        );
      },
    ).then((value) => value ?? false); // Default to false if null
  }

  // Handle username change
  Future<void> _handleUsernameChange() async {
    final previousUsername = profile["username"]; // Store previous value
    final confirm = await _showLogoutDialog(context);
    if (confirm) {
      await _updateUsername(); // Call API if confirmed
    } else {
      setState(() {
        newUsername = previousUsername; // Restore old username
      });
    }
  }

  // Handle email change
  Future<void> _handleEmailChange() async {
    final previousEmail = profile["email"]; // Store previous value
    final confirm = await _showLogoutDialog(context);
    if (confirm) {
      await _updateEmail(); // Call API if confirmed
    } else {
      setState(() {
        newEmail = previousEmail; // Restore old email
      });
    }
  }

  // Handle password change
  Future<void> _handlePasswordChange() async {
    final confirm = await _showLogoutDialog(context);
    if (confirm) {
      await _updatePassword(); // Call API if confirmed
    }
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

      user.logout(context, router); // Logout user
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

      user.logout(context, router); // Logout user
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

      user.logout(context, router); // Logout user
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
                  hintText: profile["username"],
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
                      onPressed: _handleUsernameChange,
                      height: 50,
                      width: 75,
                      textStyle:
                          const TextStyle(fontSize: 16, color: Colors.white),
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
          Column(
            children: [
              Row(
                children: [
                  Flexible(
                    child: Input(
                      labelText: "Old Password",
                      obscureText: !showOldPassword,
                      icon: Icons.lock,
                      onChanged: (value) {
                        setState(() {
                          oldPassword = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedTextButton(
                    text: showOldPassword ? "Hide" : "Show",
                    onPressed: () {
                      setState(() {
                        showOldPassword = !showOldPassword;
                      });
                    },
                    height: 40,
                    width: 75,
                    textStyle:
                        const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Flexible(
                    child: Input(
                      labelText: "New Password",
                      obscureText: !showNewPassword,
                      icon: Icons.lock,
                      onChanged: (value) {
                        setState(() {
                          newPassword = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedTextButton(
                    text: showNewPassword ? "Hide" : "Show",
                    onPressed: () {
                      setState(() {
                        showNewPassword = !showNewPassword;
                      });
                    },
                    height: 40,
                    width: 75,
                    textStyle:
                        const TextStyle(fontSize: 16, color: Colors.white),
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
                      onChanged: (value) {
                        setState(() {
                          confirmPassword = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  isUpdatingPassword
                      ? const CircularProgressIndicator()
                      : SizedTextButton(
                          text: "Update",
                          onPressed: _handlePasswordChange,
                          height: 50,
                          width: 75,
                          textStyle:
                              const TextStyle(fontSize: 16, color: Colors.white),
                        ),
                ],
              ),
            ],
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
                  hintText: profile["email"],
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
                      onPressed: _handleEmailChange,
                      height: 50,
                      width: 75,
                      textStyle:
                          const TextStyle(fontSize: 16, color: Colors.white),
                    ),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }
}
