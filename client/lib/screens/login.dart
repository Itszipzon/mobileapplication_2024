import 'package:client/elements/input.dart';
import 'package:client/elements/button.dart';
import 'package:client/tools/router_provider.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final passwordFocusNode = FocusNode();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void login() {
    String email = emailController.text;
    String password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in both fields.')),
      );
      return;
    }
  }

  bool loading = false;

  void toggleLoading() {
    setState(() {
      loading = !loading;
    });
  }

  Future<void> handleLogin() async {
    toggleLoading();
    await Future.delayed(const Duration(seconds: 5));
    toggleLoading();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final router = RouterProvider.of(context);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Sign in',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 24),
              Input(
                labelText: "Username or Email",
                controller: emailController,
                onReturn: (_) {
                  passwordFocusNode.requestFocus();
                },
                icon: Icons.login,
              ),
              const SizedBox(height: 24),
              Input(
                labelText: "Password",
                controller: passwordController,
                obscureText: true,
                focusNode: passwordFocusNode,
                onReturn: (_) {
                  handleLogin();
                },
                icon: Icons.lock,
              ),
              const SizedBox(height: 24),
              SmallTextButton(
                onPressed: () {
                  handleLogin();
                },
                text: 'Sign In',
                loading: loading,
              ),
              const SizedBox(height: 24),
              InkWell(
                onTap: () => router.setPath(context, 'home'),
                child: Text(
                  'Forgot password?',
                  style: TextStyle(color: theme.primaryColor),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? ",
                      style: TextStyle(color: Colors.grey)),
                  InkWell(
                    onTap: () => router.setPath(context, 'register'),
                    child: Text(
                      'Sign up here.',
                      style: TextStyle(color: theme.primaryColor),
                    ),
                  )
                ],
              ),
              InkWell(
                onTap: () => router.setPath(
                    context, 'test?id=This is id from path variable',
                    values: {"id": "This is id from query parameter"}),
                child: const Text('Test'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
