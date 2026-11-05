import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../decisions_providers.dart';
import '../../domain/entities/decision.dart';
import '../../domain/usecases/decision_usecases.dart';
import '../decision_providers.dart';
import '../widgets/missing_decision.dart';

/// Choosing one option and saying why (paper III-F step 4).
class CommitDecisionPage extends ConsumerStatefulWidget {
  const CommitDecisionPage({super.key, required this.decisionId});

  final int decisionId;

  @override
  ConsumerState<CommitDecisionPage> createState() => _CommitDecisionPageState();
}

class _CommitDecisionPageState extends ConsumerState<CommitDecisionPage> {
  final _note = TextEditingController();
  String? _chosenKey;
  bool _saving = false;

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<void> _commit() async {
    final messenger = ScaffoldMessenger.of(context);
    if (_chosenKey == null) {
      showAppSnackBar(messenger, 'Choose the option you are going with.',
          isError: true);
      return;
    }
    setState(() => _saving = true);
    try {
      await CommitDecisionUseCase(ref.read(decisionRepositoryProvider)).execute(
        widget.decisionId,
        chosenOptionKey: _chosenKey!,
        commitmentNote: _note.text,
      );
      if (mounted) context.pop();
    } catch (e) {
      showAppSnackBar(messenger, e.toString(), isError: true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loaded = ref.watch(decisionProvider(widget.decisionId));
    final decision = loaded.valueOrNull;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Commit to an option')),
      body: decision == null
          ? MissingDecision(loading: !loaded.hasValue && !loaded.hasError)
          // The decision page offers no commit button then, but a saved link
          // or options removed on another device can still lead here.
          : !decision.hasEnoughOptionsToCommit
          ? const _TooFewOptions()
          : ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Text(decision.title, style: textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text(
                  "Which option are you going with? After committing you "
                  "can't edit the decision; you'll evaluate how it went later.",
                  style: textTheme.bodySmall,
                ),
                const SizedBox(height: 16),
                RadioGroup<String>(
                  groupValue: _chosenKey,
                  onChanged: (key) => setState(() => _chosenKey = key),
                  child: Column(
                    children: [
                      for (final option in decision.options)
                        RadioListTile<String>(
                          value: option.key,
                          title: Text(option.title),
                          subtitle: _ReasonSummary(option: option),
                          contentPadding: EdgeInsets.zero,
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Why this option? (optional)',
                  hint: 'Your reason, in a sentence or two',
                  controller: _note,
                  maxLines: 3,
                ),
                const SizedBox(height: 32),
                AppButton(text: 'Commit', isLoading: _saving, onPressed: _commit),
              ],
            ),
    );
  }
}

/// Explains why there is nothing to choose between yet.
class _TooFewOptions extends StatelessWidget {
  const _TooFewOptions();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          'Add at least ${Decision.minOptionsToCommit} options to this '
          'decision before committing.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}

/// How many pros and cons an option has. An option with none is flagged
/// (without blocking the commit), since there is nothing to weigh it by.
class _ReasonSummary extends StatelessWidget {
  const _ReasonSummary({required this.option});

  final DecisionOption option;

  @override
  Widget build(BuildContext context) {
    if (option.pros.isEmpty && option.cons.isEmpty) {
      return Row(
        children: [
          const Icon(Icons.info_outline, size: 16, color: AppColors.warning),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              'No pros or cons listed',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColors.warning),
            ),
          ),
        ],
      );
    }
    String plural(int n, String word) => n == 1 ? '1 $word' : '$n ${word}s';
    return Text(
        '${plural(option.pros.length, 'pro')} · ${plural(option.cons.length, 'con')}');
  }
}
