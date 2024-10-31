import 'package:client/elements/input.dart';
import 'package:client/elements/button.dart';
import 'package:client/tools/api_handler.dart';
import 'package:client/tools/router.dart';
import 'package:client/tools/router_provider.dart';
import 'package:client/tools/user.dart';
import 'package:client/tools/user_provider.dart';
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
  late final RouterState router;
  late final User user;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
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
    if (await user.inSession()) {
      router.setPath(context, 'home');
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

    await Future.delayed(const Duration(seconds: 2));

    final response =
        await ApiHandler.login(emailController.text, passwordController.text);
    

    if (response.statusCode == 200) {
      user.setToken(response.body);

      if (mounted) {
        router.setPath(context, "home");
      }
    } else {
      print("Error");
    }

    toggleLoading();
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
                'Sign in',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 24),
              Input(
                labelText: "Username or Email",
                enabled: !loading,
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
                enabled: !loading,
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
