import 'package:flutter/material.dart';

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

class SmallTextButtonState extends State<SmallTextButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.loading ? null : widget.onPressed,
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
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
      child: widget.loading
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