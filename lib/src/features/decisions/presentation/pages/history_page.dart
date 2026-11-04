import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/brand_app_bar.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../domain/entities/decision.dart';
import '../../domain/entities/decision_enums.dart';
import '../decision_labels.dart';
import '../decision_providers.dart';
import '../widgets/decision_list_card.dart';

/// Every decision, searchable and filterable by status: the "cognitive
/// mirror" of past decisions (paper II-B).
class HistoryPage extends ConsumerStatefulWidget {
  const HistoryPage({super.key});

  @override
  ConsumerState<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends ConsumerState<HistoryPage> {
  final _search = TextEditingController();
  DecisionStatus? _status;

  // Each search or filter is a new query that starts out loading. Showing
  // the last results meanwhile stops the list flashing to a spinner (and
  // jumping back to the top) on every keystroke.
  List<Decision>? _lastResults;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = ref
        .watch(decisionListProvider((status: _status, search: _search.text)));
    final decisions =
        query.valueOrNull ?? (query.isLoading ? _lastResults : null);
    _lastResults = decisions;
    final filtering = _status != null || _search.text.trim().isNotEmpty;

    return Scaffold(
      appBar: const BrandAppBar(),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const PageHeading(
            title: 'Decision History',
            description: 'Look back at past decisions, see how they turned '
                'out, and compare that with how sure you felt at the start.',
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _search,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              hintText: 'Search decisions',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              ChoiceChip(
                label: const Text('All'),
                selected: _status == null,
                onSelected: (_) => setState(() => _status = null),
              ),
              for (final status in DecisionStatus.values)
                ChoiceChip(
                  label: Text(status.label),
                  selected: _status == status,
                  onSelected: (_) => setState(() => _status = status),
                ),
            ],
          ),
          const SizedBox(height: 16),
          if (decisions == null)
            const Center(child: CircularProgressIndicator())
          else if (decisions.isEmpty)
            EmptyState(
              icon: filtering ? Icons.search_off : Icons.history,
              title: filtering ? 'No matching decisions' : 'No decisions yet',
              message: filtering
                  ? 'Try another search or filter.'
                  : 'Decisions you record will appear here.',
            )
          else
            for (final d in decisions)
              DecisionListCard(
                decision: d,
                onTap: () => context.push('/decisions/${d.localId}'),
              ),
        ],
      ),
    );
  }
}
