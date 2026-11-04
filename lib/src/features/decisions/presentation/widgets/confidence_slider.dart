import 'package:flutter/material.dart';

/// A 1–100 slider with its label and current value, used for confidence and
/// satisfaction (all 1–100 on the server).
class ConfidenceSlider extends StatelessWidget {
  const ConfidenceSlider({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: $value%', style: Theme.of(context).textTheme.titleSmall),
        Slider(
          value: value.toDouble(),
          min: 1,
          max: 100,
          divisions: 99,
          label: '$value%',
          onChanged: (v) => onChanged(v.round()),
        ),
      ],
    );
  }
}
