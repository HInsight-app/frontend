import 'decision_local_data_source.dart';
import 'memory_decision_local_data_source.dart';

/// Web (UI preview only): nothing is saved once the tab closes.
Future<DecisionLocalDataSource> openDecisionLocalDataSource() async =>
    MemoryDecisionLocalDataSource();
