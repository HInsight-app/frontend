import 'package:flutter/material.dart';

class AppTextField extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController? controller;
  final IconData? prefixIcon;
  final int maxLines;
  final TextInputType keyboardType;
  final bool isPassword;

  const AppTextField({
    super.key,
    required this.label,
    required this.hint,
    this.controller,
    this.prefixIcon,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.isPassword = false, // Defaults to false for normal fields
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  // Remembers if the text is currently hidden or showing
  late bool _isObscure;

  @override
  void initState() {
    super.initState();
    // Start hidden only if this is defined as a password field
    _isObscure = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: theme.textTheme.titleSmall),
        const SizedBox(height: 8),
        TextField(
          controller: widget.controller,
          maxLines: widget.maxLines,
          keyboardType: widget.keyboardType,
          obscureText: _isObscure,
          style: theme.textTheme.bodyLarge,
          // Fill, borders, hint and icon colours come from AppTheme's
          // inputDecorationTheme, so every field looks the same.
          decoration: InputDecoration(
            hintText: widget.hint,
            prefixIcon:
                widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,

            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _isObscure ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                  )
                : null, // Shows nothing if it's a normal text field
          ),
        ),
      ],
    );
  }
}
