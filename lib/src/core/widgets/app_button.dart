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
    // Define colors based on the requested type using your specific dark palette
    Color bgColor;
    Color fgColor;
    BorderSide border = BorderSide.none;

    switch (type) {
      case ButtonType.primary:
        bgColor = const Color(0xFFBB86FC); // Primary Purple
        fgColor = const Color(0xFF1E1E1E); // Dark text for contrast
        break;
      case ButtonType.secondary:
        bgColor = const Color(0xFF2C2C2C); // Surface Dark grey
        fgColor = const Color(0xFFEEEEEE); // White text
        break;
      case ButtonType.outline:
        bgColor = Colors.transparent;
        fgColor = const Color(0xFFEEEEEE); // White text
        border = const BorderSide(
            color: Color(0xFF2C2C2C), width: 2.0); // Surface Dark border
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
