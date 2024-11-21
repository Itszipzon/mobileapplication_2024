import 'package:flutter/material.dart';
import 'package:client/tools/api_handler.dart';
import 'package:client/tools/router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForgotPassword extends ConsumerStatefulWidget {
  const ForgotPassword({super.key});

  @override
  ForgotPasswordScreenState createState() => ForgotPasswordScreenState();
}

class ForgotPasswordScreenState extends ConsumerState<ForgotPassword> {
  final emailController = TextEditingController();
  bool loading = false;
  String? successMessage;
  String? errorMessage;

  void toggleLoading() {
    setState(() {
      loading = !loading;
    });
  }

  Future<void> handleForgotPassword() async {
    toggleLoading();
    successMessage = null;
    errorMessage = null;

    try {
      //await ApiHandler.requestPasswordReset(emailController.text);
      setState(() {
        successMessage = "A password reset link has been sent to your email.";
      });
    } catch (e) {
      setState(() {
        errorMessage = "Failed to send password reset email. Please try again.";
      });
    }

    toggleLoading();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Forgot Password"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Reset Your Password',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: emailController,
                enabled: !loading,
                decoration: InputDecoration(
                  labelText: "Enter your email",
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: loading ? null : handleForgotPassword,
                child: loading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text("Send Reset Link"),
              ),
              if (successMessage != null) ...[
                const SizedBox(height: 16),
                Text(
                  successMessage!,
                  style: const TextStyle(color: Colors.green),
                ),
              ],
              if (errorMessage != null) ...[
                const SizedBox(height: 16),
                Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
