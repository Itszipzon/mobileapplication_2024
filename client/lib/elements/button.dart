import 'package:flutter/material.dart';

/// A small button with text.
class SmallTextButton extends StatelessWidget {

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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ElevatedButton(
      onPressed: loading
          ? null
          : onPressed, // Disable the button when loading

      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return theme.primaryColor; // Color when the button is disabled
            }
            return theme.primaryColor; // Color when the button is enabled
          },
        ),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6), // Set the border radius
          ),
        ),
      ),
      child: loading // Show a loading indicator if loading is true
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.0,
              ),
            )
          : Text(text, style: const TextStyle(color: Colors.white)),
    );
  }
}

class LargeImageButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final String icon;

  const LargeImageButton({
    this.text = "",
    required this.onPressed,
    required this.icon,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 224,
      width: 166,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // The icon
        ],
      ),
    );
  }
}

class IconTextButton extends StatelessWidget {  
  final IconData icon;
  final VoidCallback onPressed;
  final String text;
  final bool active;

  const IconTextButton({
    required this.icon,
    required this.text,
    required this.onPressed,
    required this.active,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: double.infinity,
      width: 113,
      child: GestureDetector(
        onTap: active ? null : onPressed,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0), // Border radius
            border: Border.all(color: Colors.transparent), // Border color
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 24,
                  color: active ? theme.primaryColor : Colors.black),
              Text(text, style: const TextStyle(color: Colors.black)),
            ],
          ),
        ),
      ),
    );
  }
}

class BigIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final int? height;
  final int? width;

  const BigIconButton({
    required this.icon,
    required this.onPressed,
    this.height,
    this.width,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: height?.toDouble() ?? 48,
        decoration: BoxDecoration(
          color: theme.primaryColor,
          borderRadius: const BorderRadius.all(Radius.circular(6)),
        ),
        child: (height != null && width != null
            ? SizedBox(
                height: height!.toDouble(),
                width: width!.toDouble(),
                child: Icon(icon, color: Colors.white),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(icon, color: Colors.white),
              )),
      ),
    );
  }
}
