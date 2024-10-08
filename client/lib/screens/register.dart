import 'package:client/elements/input.dart';
import 'package:client/elements/button.dart';
import 'package:client/tools/router.dart';
import 'package:client/tools/router_provider.dart';
import 'package:client/tools/user.dart';
import 'package:client/tools/user_provider.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<StatefulWidget> createState() {
    return RegisterScreenState();
  }
}

class RegisterScreenState extends State<Register> {
  late final RouterState router;
  late final User user;

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final confirmPasswordFocusNode = FocusNode();

  bool loading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      router = RouterProvider.of(context);
      user = UserProvider.of(context);
      _checkUserSession();
    });
  }

  /// Check if the user is already logged in
  Future<void> _checkUserSession() async {
    if (!await user.inSession()) {
      if (mounted) {
        router.setPath(context, 'home');
      }
    }
  }

  Future<void> onPressed(BuildContext context) async {
    toggleLoading();
    await Future.delayed(const Duration(seconds: 5), () {});
    toggleLoading();
  }

  void toggleLoading() {
    setState(() {
      loading = !loading;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Sign up',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 24),
              Input(
                labelText: "Username",
                controller: usernameController,
                obscureText: false,
                onReturn: (_) {
                  emailFocusNode.requestFocus();
                },
                icon: Icons.person,
              ),
              const SizedBox(height: 24),
              Input(
                labelText: "Email",
                controller: emailController,
                obscureText: false,
                focusNode: emailFocusNode,
                onReturn: (_) {
                  passwordFocusNode.requestFocus();
                },
                icon: Icons.email,
              ),
              const SizedBox(height: 24),
              Input(
                labelText: "Password",
                controller: passwordController,
                obscureText: true,
                focusNode: passwordFocusNode,
                onReturn: (_) {
                  confirmPasswordFocusNode.requestFocus();
                },
                icon: Icons.lock,
              ),
              const SizedBox(height: 24),
              Input(
                labelText: "Confirm Password",
                controller: confirmPasswordController,
                obscureText: true,
                focusNode: confirmPasswordFocusNode,
                onReturn: (_) {
                  onPressed(context);
                },
                icon: Icons.lock,
              ),
              const SizedBox(height: 24),
              SmallTextButton(
                  text: "Sign up",
                  loading: loading,
                  onPressed: () => onPressed(context)),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? ",
                      style: TextStyle(color: Colors.grey)),
                  InkWell(
                    onTap: () => router.setPath(context, ''),
                    child: Text(
                      'Sign in here.',
                      style: TextStyle(color: theme.primaryColor),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
