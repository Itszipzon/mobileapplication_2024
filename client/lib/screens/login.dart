import 'package:client/elements/input.dart';
import 'package:client/elements/button.dart';
import 'package:client/tools/router.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.router});

  final RouterState router;

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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

    print('Entered email: $email\nEntered password: $password');
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
    
    final primary = Theme.of(context).primaryColor;

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
              Input(labelText: "Email", controller: emailController),
              const SizedBox(height: 24),
              Input(
                  labelText: "Password",
                  controller: passwordController,
                  obscureText: true),
              const SizedBox(height: 24),
            SmallTextButton(
              onPressed: () {
                handleLogin();
              },
              text: 'Login',
              loading: loading,
            ),
              const SizedBox(height: 24),
              InkWell(
                onTap: () => widget.router.switchScreen(context, 'home'),
                child: Text(
                  'Forgot password?',
                  style: TextStyle(color: primary),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? ", style: TextStyle(color: Colors.grey)),
                  InkWell(
                    onTap: () => widget.router.switchScreen(context, 'register'),
                    child: Text(
                      'Sign up here.',
                      style: TextStyle(color: primary),
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
