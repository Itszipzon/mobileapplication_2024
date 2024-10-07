import 'package:flutter/material.dart';

/// A text input field.
class Input extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final bool obscureText;
  final void Function(String)? onReturn;
  final FocusNode? focusNode;

  const Input({
    super.key,
    required this.labelText,
    required this.controller,
    this.obscureText = false,
    this.onReturn,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Theme(
      data: Theme.of(context).copyWith(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: theme.primaryColor, // The color of the cursor
          selectionColor: theme.primaryColor, // The color of text when marked
        ),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        onSubmitted: onReturn, // Call the function when the user presses enter
        focusNode: focusNode,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(
              color: Colors.black), // Set the color of the label
          border: const OutlineInputBorder(
            borderRadius:
                BorderRadius.all(Radius.circular(6)), // Set the border radius
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
                Radius.circular(6)), // Set the border radius when focused
            borderSide: BorderSide(
                color: Color.fromARGB(
                    255, 0, 0, 0)), // Set the border color when focused
          ),
          floatingLabelStyle: const TextStyle(
              color: Colors.black), // Set the color of the label when floating
        ),
      ),
    );
  }
}
