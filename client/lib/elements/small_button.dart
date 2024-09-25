import 'package:flutter/material.dart';

/// A small button with text.
/// The button can be in loading state where the button is disabled and loading symbol is shown.
class SmallTextButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool loading;

  const SmallTextButton({
    required this.text,
    required this.onPressed,
    this.loading = false,
    super.key,
  });

  @override
  SmallTextButtonState createState() => SmallTextButtonState();
}

/// The state of the [SmallTextButton] widget.
class SmallTextButtonState extends State<SmallTextButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(

      onPressed: widget.loading ? null : widget.onPressed, // Disable the button when loading

      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return Colors.orange; // Color when the button is disabled
            }
            return Colors.orange; // Color when the button is enabled
          },
        ),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6), // Set the border radius
          ),
        ),
      ),
      child: widget.loading // Show a loading indicator if loading is true
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.0,
              ),
            )
          : Text(widget.text, style: const TextStyle(color: Colors.white)),
    );
  }
}