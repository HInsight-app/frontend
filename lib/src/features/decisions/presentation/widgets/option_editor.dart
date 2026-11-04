import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../domain/entities/decision.dart';

/// Disposes [disposable] once the current frame is done, so a text field
/// that is about to be removed never uses a disposed controller.
void disposeAfterFrame(Object disposable) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (disposable is OptionFields) disposable.dispose();
    if (disposable is TextEditingController) disposable.dispose();
  });
}

/// The text fields behind one option in the decision form.
class OptionFields {
  OptionFields({
    this.key,
    String title = '',
    List<String> pros = const [],
    List<String> cons = const [],
  })  : title = TextEditingController(text: title),
        pros = [for (final p in pros) TextEditingController(text: p)],
        cons = [for (final c in cons) TextEditingController(text: c)];

  /// The existing option's key when editing, so it keeps its identity.
  final String? key;
  final TextEditingController title;
  final List<TextEditingController> pros;
  final List<TextEditingController> cons;

  bool get isBlank =>
      title.text.trim().isEmpty &&
      [...pros, ...cons].every((c) => c.text.trim().isEmpty);

  OptionDraft toDraft() => OptionDraft(
        key: key,
        title: title.text,
        pros: [for (final c in pros) c.text],
        cons: [for (final c in cons) c.text],
      );

  void dispose() {
    title.dispose();
    for (final c in [...pros, ...cons]) {
      c.dispose();
    }
  }
}

/// One option card in the form: a title plus lists of pros and cons.
class OptionEditor extends StatelessWidget {
  const OptionEditor({
    super.key,
    required this.number,
    required this.fields,
    required this.onChanged,
    this.onRemove,
  });

  final int number;
  final OptionFields fields;

  /// Called after a pro or con is added or removed, to rebuild the form.
  final VoidCallback onChanged;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 8, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text('Option $number',
                      style: Theme.of(context).textTheme.titleSmall),
                ),
                if (onRemove != null)
                  IconButton(
                    tooltip: 'Remove option $number',
                    icon: const Icon(Icons.close),
                    onPressed: onRemove,
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: AppTextField(
                label: 'Option title',
                hint: 'e.g. Take the internship',
                controller: fields.title,
              ),
            ),
            const SizedBox(height: 12),
            _ItemList(
              label: 'Pros',
              hint: 'Add a pro',
              color: AppColors.success,
              items: fields.pros,
              onChanged: onChanged,
            ),
            const SizedBox(height: 8),
            _ItemList(
              label: 'Cons',
              hint: 'Add a con',
              color: AppColors.error,
              items: fields.cons,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}

class _ItemList extends StatelessWidget {
  const _ItemList({
    required this.label,
    required this.hint,
    required this.color,
    required this.items,
    required this.onChanged,
  });

  final String label;
  final String hint;
  final Color color;
  final List<TextEditingController> items;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(label,
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(color: color)),
            ),
            TextButton.icon(
              onPressed: () {
                items.add(TextEditingController());
                onChanged();
              },
              icon: const Icon(Icons.add, size: 18),
              label: Text(hint), // "Add a pro" / "Add a con"
            ),
          ],
        ),
        for (var i = 0; i < items.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Icon(Icons.circle, size: 8, color: color),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: items[i],
                    decoration: InputDecoration(
                      hintText: hint,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Remove',
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: () {
                    disposeAfterFrame(items.removeAt(i));
                    onChanged();
                  },
                ),
              ],
            ),
          ),
      ],
    );
  }
}
