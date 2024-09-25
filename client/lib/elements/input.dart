import 'package:flutter/material.dart';

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
          cursorColor: Colors.orange, // Change this to your desired caret color
          selectionColor: Colors.orange, // Change this to your desired selection color
        ),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(6)),
            borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
          ),
          floatingLabelStyle: const TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}