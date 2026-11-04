import 'package:flutter/material.dart';

/// Explains what the AI checks are, and aren't (paper I-C: the system only
/// flags biases; it doesn't decide or recommend).
class AiNotice extends StatelessWidget {
  const AiNotice({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.outline),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: colors.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'About AI insights',
                  style: textTheme.titleSmall?.copyWith(color: colors.primary),
                ),
                const SizedBox(height: 4),
                Text(
                  'The AI looks for signs of common cognitive biases in what '
                  'you wrote. Its findings are prompts for reflection, not '
                  'psychological diagnoses or advice on what to choose. The '
                  'decision is always yours.',
                  style: textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
