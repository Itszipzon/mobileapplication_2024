import 'package:flutter/material.dart';

/// A text input field.
class Input extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final bool obscureText;

  const Input({
    super.key,
    required this.labelText,
    required this.controller,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.orange, // The color of the cursor
          selectionColor: Colors.orange, // The color of text when marked
        ),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText, // Hide the text if true (for passwords)
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.black), // Set the color of the label
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(6)), // Set the border radius
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(6)), // Set the border radius when focused
            borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0)), // Set the border color when focused
          ),
          floatingLabelStyle: const TextStyle(color: Colors.black), // Set the color of the label when floating
        ),
      ),
    );
  }
}