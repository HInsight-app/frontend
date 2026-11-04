import 'decision_local_data_source.dart';
import 'isar_decision_local_data_source.dart';

/// Android and iOS: the real Isar database.
Future<DecisionLocalDataSource> openDecisionLocalDataSource() async =>
    IsarDecisionLocalDataSource(await openHInsightIsar());
