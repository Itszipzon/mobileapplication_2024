import 'package:flutter/material.dart';
import 'package:client/tools/api_handler.dart';

class ResetPassword extends StatelessWidget {
  final String token;

  const ResetPassword({required this.token, super.key});

  @override
  Widget build(BuildContext context) {
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    bool loading = false;
    //String? errorMessage;

    Future<void> handleResetPassword() async {
      if (newPasswordController.text != confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Passwords do not match")),
        );
        return;
      }

      if (newPasswordController.text.length < 8) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Password must be at least 8 characters long")),
        );
        return;
      }

      try {
        loading = true;

        await ApiHandler.resetPassword(token, newPasswordController.text);

        // On success, navigate to the login screen or success message
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Password reset successfully")),
          );
          Navigator.pushNamedAndRemoveUntil(context, "login", (route) => false);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to reset password: $e")),
        );
      } finally {
        loading = false;
      }
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
