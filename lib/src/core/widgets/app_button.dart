import 'package:flutter/material.dart';

enum ButtonType { primary, secondary, outline }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonType type;
  final bool isLoading;
  final IconData? icon;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = ButtonType.primary,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Define colors based on the requested type
    Color bgColor;
    Color fgColor;
    BorderSide border = BorderSide.none;

    switch (type) {
      case ButtonType.primary:
        bgColor = colorScheme.primary;
        fgColor = colorScheme.onPrimary;
        break;
      case ButtonType.secondary:
        bgColor = colorScheme.primaryContainer;
        fgColor = colorScheme.onPrimaryContainer;
        break;
      case ButtonType.outline:
        bgColor = Colors.transparent;
        fgColor = colorScheme.primary;
        border = BorderSide(color: colorScheme.primary, width: 1.5);
        break;
    }

    return SizedBox(
      width:
          double.infinity, // Buttons stretch to fill their container by default
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: fgColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: border,
          ),
        ),
        // Disable the button if it's loading
        onPressed: isLoading ? () {} : onPressed,
        child: isLoading
            ? SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: fgColor,
                  strokeWidth: 2.5,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
