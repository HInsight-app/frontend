import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../decisions_providers.dart';
import '../../domain/usecases/decision_usecases.dart';
import '../decision_providers.dart';
import '../widgets/confidence_slider.dart';

/// Looking back at a committed decision (paper III-F step 5).
class EvaluateDecisionPage extends ConsumerStatefulWidget {
  const EvaluateDecisionPage({super.key, required this.decisionId});

  final int decisionId;

  @override
  ConsumerState<EvaluateDecisionPage> createState() =>
      _EvaluateDecisionPageState();
}

class _EvaluateDecisionPageState extends ConsumerState<EvaluateDecisionPage> {
  final _notes = TextEditingController();
  int _satisfaction = 50;
  int? _confidence; // Starts at the confidence felt before deciding
  bool _saving = false;

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  Future<void> _save(int confidence) async {
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _saving = true);
    try {
      await EvaluateDecisionUseCase(ref.read(decisionRepositoryProvider)).execute(
        widget.decisionId,
        satisfactionAfter: _satisfaction,
        confidenceAfter: confidence,
        hindsightNotes: _notes.text,
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
    final decision = ref.watch(decisionProvider(widget.decisionId)).valueOrNull;
    final textTheme = Theme.of(context).textTheme;
    if (decision == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Evaluate')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    final before = decision.confidenceBefore;
    final confidence = _confidence ?? before ?? 50;

    return Scaffold(
      appBar: AppBar(title: const Text('Evaluate')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(decision.title, style: textTheme.headlineSmall),
          if (decision.chosenOption != null) ...[
            const SizedBox(height: 4),
            Text('You chose: ${decision.chosenOption!.title}',
                style: textTheme.bodySmall),
          ],
          const SizedBox(height: 24),
          ConfidenceSlider(
            label: 'How satisfied are you with how it turned out',
            value: _satisfaction,
            onChanged: (v) => setState(() => _satisfaction = v),
          ),
          const SizedBox(height: 8),
          ConfidenceSlider(
            label: 'Looking back, how sure are you it was the right choice',
            value: confidence,
            onChanged: (v) => setState(() => _confidence = v),
          ),
          if (before != null)
            Text('Before deciding you were $before% sure.',
                style: textTheme.bodySmall),
          const SizedBox(height: 16),
          AppTextField(
            label: 'What do you know now that you didn\'t then? (optional)',
            hint: 'Your reflections',
            controller: _notes,
            maxLines: 4,
          ),
          const SizedBox(height: 32),
          AppButton(
            text: 'Save evaluation',
            isLoading: _saving,
            onPressed: () => _save(confidence),
          ),
        ],
      ),
    );
  }
}
