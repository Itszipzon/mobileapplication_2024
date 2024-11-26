import 'package:flutter/material.dart';

class ResetPassword extends StatelessWidget {
  final String token;

  const ResetPassword({required this.token, super.key});

  @override
  Widget build(BuildContext context) {
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    bool loading = false;

    Future<void> handleResetPassword() async {
      // Implement API logic to reset the password using the provided token and new password
      // Example: await ApiHandler.resetPassword(token, newPasswordController.text);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Reset Password"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Enter your new password',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "New Password",
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Confirm Password",
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: loading ? null : handleResetPassword,
                child: loading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text("Reset Password"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
