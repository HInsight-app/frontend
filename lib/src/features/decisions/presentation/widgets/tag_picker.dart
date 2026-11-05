import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/app_snack_bar.dart';
import '../../../tags/domain/entities/tag.dart';
import '../../decisions_providers.dart';
import '../decision_providers.dart';

/// Tags as chips to tick (long-press one to delete it), plus a chip to
/// create a new one. [onToggle] and [onDeleted] are only called while this
/// picker is still on screen, so callers can simply call setState.
class TagPicker extends ConsumerWidget {
  const TagPicker({
    super.key,
    required this.selected,
    required this.onToggle,
    required this.onDeleted,
  });

  final Set<int> selected;
  final ValueChanged<int> onToggle;
  final ValueChanged<int> onDeleted;

  Future<void> _deleteTag(BuildContext context, WidgetRef ref, Tag tag) async {
    final messenger = ScaffoldMessenger.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete the tag "${tag.name}"?'),
        content: const Text(
            'It is removed from every decision that uses it. '
            'The decisions themselves are kept.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    // The form may have closed while the dialog was open.
    if (confirmed != true || !context.mounted) return;

    try {
      await ref.read(decisionRepositoryProvider).deleteTag(tag.localId!);
      if (context.mounted) onDeleted(tag.localId!);
    } catch (e) {
      showAppSnackBar(messenger, e.toString(), isError: true);
    }
  }

  Future<void> _createTag(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    final name = await showDialog<String>(
      context: context,
      builder: (context) => const _NewTagDialog(),
    );
    if (name == null || !context.mounted) return;

    try {
      final tag = await ref.read(decisionRepositoryProvider).createTag(name);
      if (context.mounted) onToggle(tag.localId!);
    } catch (e) {
      showAppSnackBar(messenger, e.toString(), isError: true);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tags = ref.watch(tagsProvider).valueOrNull ?? const [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final tag in tags)
              GestureDetector(
                key: ValueKey(tag.localId),
                onLongPress: () => _deleteTag(context, ref, tag),
                child: FilterChip(
                  label: Text(tag.name),
                  selected: selected.contains(tag.localId),
                  onSelected: (_) => onToggle(tag.localId!),
                ),
              ),
            ActionChip(
              avatar: const Icon(Icons.add, size: 16),
              label: const Text('New tag'),
              onPressed: () => _createTag(context, ref),
            ),
          ],
        ),
        if (tags.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text('Long-press a tag to delete it.',
              style: Theme.of(context).textTheme.bodySmall),
        ],
      ],
    );
  }
}

/// Asks for a tag name. Owns its text controller, so it is disposed only
/// after the dialog has finished closing.
class _NewTagDialog extends StatefulWidget {
  const _NewTagDialog();

  @override
  State<_NewTagDialog> createState() => _NewTagDialogState();
}

class _NewTagDialogState extends State<_NewTagDialog> {
  final _name = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New tag'),
      content: TextField(
        controller: _name,
        autofocus: true,
        decoration: const InputDecoration(hintText: 'e.g. Academic'),
        onSubmitted: (value) => Navigator.pop(context, value),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, _name.text),
          child: const Text('Add'),
        ),
      ],
    );
  }
}
