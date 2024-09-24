import 'package:client/elements/input.dart';
import 'package:client/elements/small_button.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.switchScreen});

  final Function(BuildContext, String) switchScreen;

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

  void _login() {
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

  @override
  Widget build(BuildContext context) {
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
                onPressed: () => widget.switchScreen(
                    context, 'test?message=Hello World&second=Whats up'),
                text: 'Login',
              ),
              const SizedBox(height: 24),
              InkWell(
                onTap: () => widget.switchScreen(context, 'test'),
                child: const Text(
                  'Forgot password?',
                  style: TextStyle(color: Colors.orange),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? ", style: TextStyle(color: Colors.grey)),
                  InkWell(
                    onTap: () => widget.switchScreen(context, 'register'),
                    child: const Text(
                      'Sign up here.',
                      style: TextStyle(color: Colors.orange),
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
