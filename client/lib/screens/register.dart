import 'package:client/elements/input.dart';
import 'package:client/elements/button.dart';
import 'package:client/tools/router_provider.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {

  const Register({super.key});

  @override
  State<StatefulWidget> createState() {
    return RegisterScreenState();
  }
}

class RegisterScreenState extends State<Register> {
  
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool loading = false;  
  
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> onPressed(BuildContext context) async {
    toggleLoading();
/*     widget.switchScreen(context, 'home'); */
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
    final router = RouterProvider.of(context);

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

              Input(labelText: "Username", controller: usernameController),

              const SizedBox(height: 24),

              Input(labelText: "Email", controller: emailController),
              
              const SizedBox(height: 24),

              Input(labelText: "Password", controller: passwordController, obscureText: true),

              const SizedBox(height: 24),

              Input(labelText: "Confirm Password", controller: confirmPasswordController, obscureText: true),
              
              const SizedBox(height: 24),

              SmallTextButton(text: "Sign up", loading: loading, onPressed: () => onPressed(context)),
              
              const SizedBox(height: 24),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? ", style: TextStyle(color: Colors.grey)),
                  InkWell(
                    onTap: () => router.switchScreen(context, ''),
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