import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../tags/domain/entities/tag.dart';
import '../decisions_providers.dart';
import '../domain/entities/ai_insight.dart';
import '../domain/entities/decision.dart';
import '../domain/entities/decision_enums.dart';
import '../domain/entities/evaluation.dart';

// Live data for the screens. Each re-emits when the stored data changes, so
// screens update by themselves after a save.

/// Decisions filtered by status (null for all) and a search text.
final decisionListProvider = StreamProvider.autoDispose
    .family<List<Decision>, ({DecisionStatus? status, String search})>(
  (ref, query) => ref
      .watch(decisionRepositoryProvider)
      .watchDecisions(status: query.status, search: query.search),
);

/// All decisions, newest first.
final allDecisionsProvider = StreamProvider.autoDispose<List<Decision>>(
  (ref) => ref.watch(decisionRepositoryProvider).watchDecisions(),
);

final decisionProvider = StreamProvider.autoDispose.family<Decision?, int>(
  (ref, localId) => ref.watch(decisionRepositoryProvider).watchDecision(localId),
);

final evaluationProvider = StreamProvider.autoDispose.family<Evaluation?, int>(
  (ref, localId) =>
      ref.watch(decisionRepositoryProvider).watchEvaluation(localId),
);

final insightsProvider = StreamProvider.autoDispose.family<List<AiInsight>, int>(
  (ref, localId) => ref.watch(decisionRepositoryProvider).watchInsights(localId),
);

/// Insights across all the user's decisions, newest first.
final allInsightsProvider = StreamProvider.autoDispose<List<AiInsight>>(
  (ref) => ref.watch(decisionRepositoryProvider).watchAllInsights(),
);

final tagsProvider = StreamProvider.autoDispose<List<Tag>>(
  (ref) => ref.watch(decisionRepositoryProvider).watchTags(),
);
