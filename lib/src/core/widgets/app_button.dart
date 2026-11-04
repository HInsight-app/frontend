import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum ButtonType { primary, secondary, outline }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonType type;
  final bool isLoading;
  final FaIconData? icon;

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
    // Define colors based on the requested type, using the AppTheme colour scheme
    final colors = Theme.of(context).colorScheme;
    Color bgColor;
    Color fgColor;
    BorderSide border = BorderSide.none;

    switch (type) {
      case ButtonType.primary:
        bgColor = colors.primaryContainer; // CTA lavender
        fgColor = colors.onPrimaryContainer; // Dark text for contrast
        break;
      case ButtonType.secondary:
        bgColor = colors.secondary; // Dark purple fill
        fgColor = colors.onSecondary; // White text
        break;
      case ButtonType.outline:
        bgColor = Colors.transparent;
        fgColor = colors.onSurface; // White text
        border = BorderSide(color: colors.outline); // Border colour
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
                    FaIcon(icon, size: 20),
                    const SizedBox(width: 8),
                  ],
                  // Font, size (16) and weight (bold) come from the button theme.
                  // Flexible lets a long label (or large system text) wrap
                  // instead of overflowing the button.
                  Flexible(child: Text(text, textAlign: TextAlign.center)),
                ],
              ),
      ),
    );
  }
}
