import 'package:hinsight/src/features/decisions/data/local/isar_ai_insight.dart';
import 'package:hinsight/src/features/decisions/data/local/isar_decision.dart';
import 'package:hinsight/src/features/decisions/data/local/isar_decision_local_data_source.dart';
import 'package:hinsight/src/features/decisions/data/local/isar_evaluation.dart';
import 'package:hinsight/src/features/decisions/data/local/memory_decision_local_data_source.dart';
import 'package:hinsight/src/features/tags/data/local/isar_tag.dart';
import 'package:isar/isar.dart';

import '../../helpers/isar_test_db.dart';
import 'decision_local_data_source_contract.dart';

void main() {
  runDecisionLocalDataSourceContract(
    'MemoryDecisionLocalDataSource',
    open: () async => MemoryDecisionLocalDataSource(),
    close: () async {},
  );

  late Isar isar;
  runDecisionLocalDataSourceContract(
    'IsarDecisionLocalDataSource',
    open: () async {
      isar = await openTestIsar([
        IsarDecisionSchema,
        IsarEvaluationSchema,
        IsarAiInsightSchema,
        IsarTagSchema,
      ]);
      return IsarDecisionLocalDataSource(isar);
    },
    close: () => closeTestIsar(isar),
  );
}
