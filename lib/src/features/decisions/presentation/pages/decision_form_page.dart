import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/date_format.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/section_header.dart';
import '../../decisions_providers.dart';
import '../../domain/entities/decision.dart';
import '../../domain/usecases/decision_usecases.dart';
import '../decision_providers.dart';
import '../widgets/confidence_slider.dart';
import '../widgets/option_editor.dart';

/// Creates a decision, or edits one that hasn't been committed yet
/// (paper III-F steps 1 and 2: the decision, then its options).
class DecisionFormPage extends ConsumerStatefulWidget {
  const DecisionFormPage({super.key, this.decisionId});

  /// Null for a new decision.
  final int? decisionId;

  @override
  ConsumerState<DecisionFormPage> createState() => _DecisionFormPageState();
}

class _DecisionFormPageState extends ConsumerState<DecisionFormPage> {
  final _title = TextEditingController();
  final _context = TextEditingController();
  int _confidence = 50;
  DateTime? _reviewDate;
  final _tagIds = <int>{};
  // A decision is a choice between alternatives, so start with two.
  final _options = [OptionFields(), OptionFields()];

  bool get _isEditing => widget.decisionId != null;
  bool _loading = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    if (_isEditing) _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final d = await ref
        .read(decisionRepositoryProvider)
        .watchDecision(widget.decisionId!)
        .first;
    if (!mounted) return;
    if (d == null) {
      context.pop();
      return;
    }
    // The starting empty options are on screen until this rebuild.
    _options.forEach(disposeAfterFrame);
    setState(() {
      _title.text = d.title;
      _context.text = d.context ?? '';
      _confidence = d.confidenceBefore ?? 50;
      _reviewDate = d.scheduledReviewDate;
      _tagIds.addAll(d.tagLocalIds);
      _options
        ..clear()
        ..addAll([
          for (final o in d.options)
            OptionFields(key: o.key, title: o.title, pros: o.pros, cons: o.cons),
        ]);
      _loading = false;
    });
  }

  @override
  void dispose() {
    _title.dispose();
    _context.dispose();
    for (final o in _options) {
      o.dispose();
    }
    super.dispose();
  }

  Future<void> _pickReviewDate() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastDate = today.add(const Duration(days: 730));
    // A review date saved earlier may have passed by now (or, after the
    // phone's date changed, be beyond the range). The picker refuses an
    // initial date outside its range, so start from today instead.
    var initialDate = _reviewDate ?? today.add(const Duration(days: 7));
    if (initialDate.isBefore(today) || initialDate.isAfter(lastDate)) {
      initialDate = today;
    }
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: today,
      lastDate: lastDate,
      helpText: 'When should you look back at this decision?',
    );
    if (picked != null) setState(() => _reviewDate = picked);
  }

  Future<void> _save() async {
    final messenger = ScaffoldMessenger.of(context);
    final draft = DecisionDraft(
      title: _title.text,
      context: _context.text,
      confidenceBefore: _confidence,
      scheduledReviewDate: _reviewDate,
      // Options left completely empty are ignored rather than refused.
      options: [
        for (final o in _options)
          if (!o.isBlank) o.toDraft(),
      ],
      tagLocalIds: _tagIds.toList(),
    );

    setState(() => _saving = true);
    try {
      final repository = ref.read(decisionRepositoryProvider);
      if (_isEditing) {
        await UpdateDecisionUseCase(repository).execute(widget.decisionId!, draft);
        if (mounted) context.pop();
      } else {
        final saved = await CreateDecisionUseCase(repository).execute(draft);
        if (mounted) context.pushReplacement('/decisions/${saved.localId}');
      }
    } catch (e) {
      // DecisionException messages are written for the student
      showAppSnackBar(messenger, e.toString(), isError: true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Edit decision' : 'New decision')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(24),
              children: [
                AppTextField(
                  label: 'Decision title',
                  hint: 'What decision are you facing?',
                  controller: _title,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Context & background',
                  hint: 'What is the situation, and what matters to you?',
                  controller: _context,
                  maxLines: 4,
                ),
                const SizedBox(height: 24),
                Text('Tags', style: textTheme.titleSmall),
                const SizedBox(height: 8),
                _TagPicker(
                  selected: _tagIds,
                  onToggle: (id) => setState(() {
                    if (!_tagIds.remove(id)) _tagIds.add(id);
                  }),
                ),
                const SizedBox(height: 24),
                ConfidenceSlider(
                  label: 'How sure are you right now',
                  value: _confidence,
                  onChanged: (v) => setState(() => _confidence = v),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _reviewDate == null
                            ? 'No review date'
                            : 'Look back on ${formatDate(_reviewDate!)}',
                        style: textTheme.bodySmall,
                      ),
                    ),
                    TextButton(
                      onPressed: _pickReviewDate,
                      child: Text(_reviewDate == null ? 'Set review date' : 'Change'),
                    ),
                    if (_reviewDate != null)
                      IconButton(
                        tooltip: 'Clear review date',
                        icon: const Icon(Icons.close, size: 18),
                        onPressed: () => setState(() => _reviewDate = null),
                      ),
                  ],
                ),
                const SectionHeader(title: 'Options & alternatives'),
                for (var i = 0; i < _options.length; i++)
                  OptionEditor(
                    key: ObjectKey(_options[i]),
                    number: i + 1,
                    fields: _options[i],
                    onChanged: () => setState(() {}),
                    onRemove: () =>
                        setState(() => disposeAfterFrame(_options.removeAt(i))),
                  ),
                OutlinedButton.icon(
                  onPressed: () => setState(() => _options.add(OptionFields())),
                  icon: const Icon(Icons.add),
                  label: const Text('Add an option'),
                ),
                const SizedBox(height: 32),
                AppButton(
                  text: _isEditing ? 'Save changes' : 'Save decision',
                  isLoading: _saving,
                  onPressed: _save,
                ),
              ],
            ),
    );
  }
}

/// Tags as chips to tick, plus a chip to create a new one.
class _TagPicker extends ConsumerWidget {
  const _TagPicker({required this.selected, required this.onToggle});

  final Set<int> selected;
  final ValueChanged<int> onToggle;

  Future<void> _createTag(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    final name = await showDialog<String>(
      context: context,
      builder: (context) => const _NewTagDialog(),
    );
    if (name == null) return;

    try {
      final tag = await ref.read(decisionRepositoryProvider).createTag(name);
      onToggle(tag.localId!);
    } catch (e) {
      showAppSnackBar(messenger, e.toString(), isError: true);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tags = ref.watch(tagsProvider).valueOrNull ?? const [];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final tag in tags)
          FilterChip(
            label: Text(tag.name),
            selected: selected.contains(tag.localId),
            onSelected: (_) => onToggle(tag.localId!),
          ),
        ActionChip(
          avatar: const Icon(Icons.add, size: 16),
          label: const Text('New tag'),
          onPressed: () => _createTag(context, ref),
        ),
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
