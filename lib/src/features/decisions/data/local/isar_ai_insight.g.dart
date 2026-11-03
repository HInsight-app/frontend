// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'isar_ai_insight.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetIsarAiInsightCollection on Isar {
  IsarCollection<IsarAiInsight> get isarAiInsights => this.collection();
}

const IsarAiInsightSchema = CollectionSchema(
  name: r'IsarAiInsight',
  id: -2909583827479676326,
  properties: {
    r'actionabilityScore': PropertySchema(
      id: 0,
      name: r'actionabilityScore',
      type: IsarType.long,
    ),
    r'decisionLocalId': PropertySchema(
      id: 1,
      name: r'decisionLocalId',
      type: IsarType.long,
    ),
    r'decisionServerId': PropertySchema(
      id: 2,
      name: r'decisionServerId',
      type: IsarType.string,
    ),
    r'emotionalTone': PropertySchema(
      id: 3,
      name: r'emotionalTone',
      type: IsarType.string,
      enumMap: _IsarAiInsightemotionalToneEnumValueMap,
    ),
    r'generatedAt': PropertySchema(
      id: 4,
      name: r'generatedAt',
      type: IsarType.dateTime,
    ),
    r'insightText': PropertySchema(
      id: 5,
      name: r'insightText',
      type: IsarType.string,
    ),
    r'modelConfidence': PropertySchema(
      id: 6,
      name: r'modelConfidence',
      type: IsarType.double,
    ),
    r'modelVersion': PropertySchema(
      id: 7,
      name: r'modelVersion',
      type: IsarType.string,
    ),
    r'primaryBias': PropertySchema(
      id: 8,
      name: r'primaryBias',
      type: IsarType.string,
      enumMap: _IsarAiInsightprimaryBiasEnumValueMap,
    ),
    r'riskLevel': PropertySchema(
      id: 9,
      name: r'riskLevel',
      type: IsarType.string,
      enumMap: _IsarAiInsightriskLevelEnumValueMap,
    ),
    r'serverId': PropertySchema(
      id: 10,
      name: r'serverId',
      type: IsarType.string,
    ),
    r'suggestedAlternative': PropertySchema(
      id: 11,
      name: r'suggestedAlternative',
      type: IsarType.string,
    ),
    r'triggerContext': PropertySchema(
      id: 12,
      name: r'triggerContext',
      type: IsarType.string,
      enumMap: _IsarAiInsighttriggerContextEnumValueMap,
    )
  },
  estimateSize: _isarAiInsightEstimateSize,
  serialize: _isarAiInsightSerialize,
  deserialize: _isarAiInsightDeserialize,
  deserializeProp: _isarAiInsightDeserializeProp,
  idName: r'localId',
  indexes: {
    r'serverId': IndexSchema(
      id: -7950187970872907662,
      name: r'serverId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'serverId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'decisionLocalId_triggerContext': IndexSchema(
      id: -3507288870879503336,
      name: r'decisionLocalId_triggerContext',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'decisionLocalId',
          type: IndexType.value,
          caseSensitive: false,
        ),
        IndexPropertySchema(
          name: r'triggerContext',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _isarAiInsightGetId,
  getLinks: _isarAiInsightGetLinks,
  attach: _isarAiInsightAttach,
  version: '3.1.0+1',
);

int _isarAiInsightEstimateSize(
  IsarAiInsight object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.decisionServerId.length * 3;
  {
    final value = object.emotionalTone;
    if (value != null) {
      bytesCount += 3 + value.name.length * 3;
    }
  }
  bytesCount += 3 + object.insightText.length * 3;
  bytesCount += 3 + object.modelVersion.length * 3;
  {
    final value = object.primaryBias;
    if (value != null) {
      bytesCount += 3 + value.name.length * 3;
    }
  }
  {
    final value = object.riskLevel;
    if (value != null) {
      bytesCount += 3 + value.name.length * 3;
    }
  }
  bytesCount += 3 + object.serverId.length * 3;
  {
    final value = object.suggestedAlternative;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.triggerContext.name.length * 3;
  return bytesCount;
}

void _isarAiInsightSerialize(
  IsarAiInsight object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.actionabilityScore);
  writer.writeLong(offsets[1], object.decisionLocalId);
  writer.writeString(offsets[2], object.decisionServerId);
  writer.writeString(offsets[3], object.emotionalTone?.name);
  writer.writeDateTime(offsets[4], object.generatedAt);
  writer.writeString(offsets[5], object.insightText);
  writer.writeDouble(offsets[6], object.modelConfidence);
  writer.writeString(offsets[7], object.modelVersion);
  writer.writeString(offsets[8], object.primaryBias?.name);
  writer.writeString(offsets[9], object.riskLevel?.name);
  writer.writeString(offsets[10], object.serverId);
  writer.writeString(offsets[11], object.suggestedAlternative);
  writer.writeString(offsets[12], object.triggerContext.name);
}

IsarAiInsight _isarAiInsightDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IsarAiInsight();
  object.actionabilityScore = reader.readLongOrNull(offsets[0]);
  object.decisionLocalId = reader.readLong(offsets[1]);
  object.decisionServerId = reader.readString(offsets[2]);
  object.emotionalTone = _IsarAiInsightemotionalToneValueEnumMap[
      reader.readStringOrNull(offsets[3])];
  object.generatedAt = reader.readDateTime(offsets[4]);
  object.insightText = reader.readString(offsets[5]);
  object.localId = id;
  object.modelConfidence = reader.readDoubleOrNull(offsets[6]);
  object.modelVersion = reader.readString(offsets[7]);
  object.primaryBias = _IsarAiInsightprimaryBiasValueEnumMap[
      reader.readStringOrNull(offsets[8])];
  object.riskLevel =
      _IsarAiInsightriskLevelValueEnumMap[reader.readStringOrNull(offsets[9])];
  object.serverId = reader.readString(offsets[10]);
  object.suggestedAlternative = reader.readStringOrNull(offsets[11]);
  object.triggerContext = _IsarAiInsighttriggerContextValueEnumMap[
          reader.readStringOrNull(offsets[12])] ??
      TriggerContext.preDecision;
  return object;
}

P _isarAiInsightDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (_IsarAiInsightemotionalToneValueEnumMap[
          reader.readStringOrNull(offset)]) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readDoubleOrNull(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (_IsarAiInsightprimaryBiasValueEnumMap[
          reader.readStringOrNull(offset)]) as P;
    case 9:
      return (_IsarAiInsightriskLevelValueEnumMap[
          reader.readStringOrNull(offset)]) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readStringOrNull(offset)) as P;
    case 12:
      return (_IsarAiInsighttriggerContextValueEnumMap[
              reader.readStringOrNull(offset)] ??
          TriggerContext.preDecision) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _IsarAiInsightemotionalToneEnumValueMap = {
  r'neutral': r'neutral',
  r'anxious': r'anxious',
  r'confident': r'confident',
  r'uncertain': r'uncertain',
  r'regretful': r'regretful',
};
const _IsarAiInsightemotionalToneValueEnumMap = {
  r'neutral': EmotionalTone.neutral,
  r'anxious': EmotionalTone.anxious,
  r'confident': EmotionalTone.confident,
  r'uncertain': EmotionalTone.uncertain,
  r'regretful': EmotionalTone.regretful,
};
const _IsarAiInsightprimaryBiasEnumValueMap = {
  r'confirmation': r'confirmation',
  r'lossAversion': r'lossAversion',
  r'sunkCost': r'sunkCost',
  r'overconfidence': r'overconfidence',
  r'recency': r'recency',
};
const _IsarAiInsightprimaryBiasValueEnumMap = {
  r'confirmation': BiasType.confirmation,
  r'lossAversion': BiasType.lossAversion,
  r'sunkCost': BiasType.sunkCost,
  r'overconfidence': BiasType.overconfidence,
  r'recency': BiasType.recency,
};
const _IsarAiInsightriskLevelEnumValueMap = {
  r'low': r'low',
  r'medium': r'medium',
  r'high': r'high',
};
const _IsarAiInsightriskLevelValueEnumMap = {
  r'low': RiskLevel.low,
  r'medium': RiskLevel.medium,
  r'high': RiskLevel.high,
};
const _IsarAiInsighttriggerContextEnumValueMap = {
  r'preDecision': r'preDecision',
  r'postEvaluation': r'postEvaluation',
};
const _IsarAiInsighttriggerContextValueEnumMap = {
  r'preDecision': TriggerContext.preDecision,
  r'postEvaluation': TriggerContext.postEvaluation,
};

Id _isarAiInsightGetId(IsarAiInsight object) {
  return object.localId;
}

List<IsarLinkBase<dynamic>> _isarAiInsightGetLinks(IsarAiInsight object) {
  return [];
}

void _isarAiInsightAttach(
    IsarCollection<dynamic> col, Id id, IsarAiInsight object) {
  object.localId = id;
}

extension IsarAiInsightByIndex on IsarCollection<IsarAiInsight> {
  Future<IsarAiInsight?> getByServerId(String serverId) {
    return getByIndex(r'serverId', [serverId]);
  }

  IsarAiInsight? getByServerIdSync(String serverId) {
    return getByIndexSync(r'serverId', [serverId]);
  }

  Future<bool> deleteByServerId(String serverId) {
    return deleteByIndex(r'serverId', [serverId]);
  }

  bool deleteByServerIdSync(String serverId) {
    return deleteByIndexSync(r'serverId', [serverId]);
  }

  Future<List<IsarAiInsight?>> getAllByServerId(List<String> serverIdValues) {
    final values = serverIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'serverId', values);
  }

  List<IsarAiInsight?> getAllByServerIdSync(List<String> serverIdValues) {
    final values = serverIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'serverId', values);
  }

  Future<int> deleteAllByServerId(List<String> serverIdValues) {
    final values = serverIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'serverId', values);
  }

  int deleteAllByServerIdSync(List<String> serverIdValues) {
    final values = serverIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'serverId', values);
  }

  Future<Id> putByServerId(IsarAiInsight object) {
    return putByIndex(r'serverId', object);
  }

  Id putByServerIdSync(IsarAiInsight object, {bool saveLinks = true}) {
    return putByIndexSync(r'serverId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByServerId(List<IsarAiInsight> objects) {
    return putAllByIndex(r'serverId', objects);
  }

  List<Id> putAllByServerIdSync(List<IsarAiInsight> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'serverId', objects, saveLinks: saveLinks);
  }
}

extension IsarAiInsightQueryWhereSort
    on QueryBuilder<IsarAiInsight, IsarAiInsight, QWhere> {
  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterWhere> anyLocalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension IsarAiInsightQueryWhere
    on QueryBuilder<IsarAiInsight, IsarAiInsight, QWhereClause> {
  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterWhereClause> localIdEqualTo(
      Id localId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: localId,
        upper: localId,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterWhereClause>
      localIdNotEqualTo(Id localId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: localId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: localId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: localId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: localId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterWhereClause>
      localIdGreaterThan(Id localId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: localId, includeLower: include),
      );
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterWhereClause> localIdLessThan(
      Id localId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: localId, includeUpper: include),
      );
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterWhereClause> localIdBetween(
    Id lowerLocalId,
    Id upperLocalId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerLocalId,
        includeLower: includeLower,
        upper: upperLocalId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterWhereClause> serverIdEqualTo(
      String serverId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'serverId',
        value: [serverId],
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterWhereClause>
      serverIdNotEqualTo(String serverId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'serverId',
              lower: [],
              upper: [serverId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'serverId',
              lower: [serverId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'serverId',
              lower: [serverId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'serverId',
              lower: [],
              upper: [serverId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterWhereClause>
      decisionLocalIdEqualToAnyTriggerContext(int decisionLocalId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'decisionLocalId_triggerContext',
        value: [decisionLocalId],
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterWhereClause>
      decisionLocalIdNotEqualToAnyTriggerContext(int decisionLocalId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'decisionLocalId_triggerContext',
              lower: [],
              upper: [decisionLocalId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'decisionLocalId_triggerContext',
              lower: [decisionLocalId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'decisionLocalId_triggerContext',
              lower: [decisionLocalId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'decisionLocalId_triggerContext',
              lower: [],
              upper: [decisionLocalId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterWhereClause>
      decisionLocalIdGreaterThanAnyTriggerContext(
    int decisionLocalId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'decisionLocalId_triggerContext',
        lower: [decisionLocalId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterWhereClause>
      decisionLocalIdLessThanAnyTriggerContext(
    int decisionLocalId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'decisionLocalId_triggerContext',
        lower: [],
        upper: [decisionLocalId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterWhereClause>
      decisionLocalIdBetweenAnyTriggerContext(
    int lowerDecisionLocalId,
    int upperDecisionLocalId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'decisionLocalId_triggerContext',
        lower: [lowerDecisionLocalId],
        includeLower: includeLower,
        upper: [upperDecisionLocalId],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterWhereClause>
      decisionLocalIdTriggerContextEqualTo(
          int decisionLocalId, TriggerContext triggerContext) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'decisionLocalId_triggerContext',
        value: [decisionLocalId, triggerContext],
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterWhereClause>
      decisionLocalIdEqualToTriggerContextNotEqualTo(
          int decisionLocalId, TriggerContext triggerContext) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'decisionLocalId_triggerContext',
              lower: [decisionLocalId],
              upper: [decisionLocalId, triggerContext],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'decisionLocalId_triggerContext',
              lower: [decisionLocalId, triggerContext],
              includeLower: false,
              upper: [decisionLocalId],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'decisionLocalId_triggerContext',
              lower: [decisionLocalId, triggerContext],
              includeLower: false,
              upper: [decisionLocalId],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'decisionLocalId_triggerContext',
              lower: [decisionLocalId],
              upper: [decisionLocalId, triggerContext],
              includeUpper: false,
            ));
      }
    });
  }
}

extension IsarAiInsightQueryFilter
    on QueryBuilder<IsarAiInsight, IsarAiInsight, QFilterCondition> {
  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      actionabilityScoreIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'actionabilityScore',
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      actionabilityScoreIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'actionabilityScore',
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      actionabilityScoreEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'actionabilityScore',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      actionabilityScoreGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'actionabilityScore',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      actionabilityScoreLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'actionabilityScore',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      actionabilityScoreBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'actionabilityScore',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      decisionLocalIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'decisionLocalId',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      decisionLocalIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'decisionLocalId',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      decisionLocalIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'decisionLocalId',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      decisionLocalIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'decisionLocalId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      decisionServerIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'decisionServerId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      decisionServerIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'decisionServerId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      decisionServerIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'decisionServerId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      decisionServerIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'decisionServerId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      decisionServerIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'decisionServerId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      decisionServerIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'decisionServerId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      decisionServerIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'decisionServerId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      decisionServerIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'decisionServerId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      decisionServerIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'decisionServerId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      decisionServerIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'decisionServerId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      emotionalToneIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'emotionalTone',
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      emotionalToneIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'emotionalTone',
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      emotionalToneEqualTo(
    EmotionalTone? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'emotionalTone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      emotionalToneGreaterThan(
    EmotionalTone? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'emotionalTone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      emotionalToneLessThan(
    EmotionalTone? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'emotionalTone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      emotionalToneBetween(
    EmotionalTone? lower,
    EmotionalTone? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'emotionalTone',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      emotionalToneStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'emotionalTone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      emotionalToneEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'emotionalTone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      emotionalToneContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'emotionalTone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      emotionalToneMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'emotionalTone',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      emotionalToneIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'emotionalTone',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      emotionalToneIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'emotionalTone',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      generatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'generatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      generatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'generatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      generatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'generatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      generatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'generatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      insightTextEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'insightText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      insightTextGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'insightText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      insightTextLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'insightText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      insightTextBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'insightText',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      insightTextStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'insightText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      insightTextEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'insightText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      insightTextContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'insightText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      insightTextMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'insightText',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      insightTextIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'insightText',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      insightTextIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'insightText',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      localIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'localId',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      localIdGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'localId',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      localIdLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'localId',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      localIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'localId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      modelConfidenceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'modelConfidence',
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      modelConfidenceIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'modelConfidence',
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      modelConfidenceEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'modelConfidence',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      modelConfidenceGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'modelConfidence',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      modelConfidenceLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'modelConfidence',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      modelConfidenceBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'modelConfidence',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      modelVersionEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'modelVersion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      modelVersionGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'modelVersion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      modelVersionLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'modelVersion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      modelVersionBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'modelVersion',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      modelVersionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'modelVersion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      modelVersionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'modelVersion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      modelVersionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'modelVersion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      modelVersionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'modelVersion',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      modelVersionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'modelVersion',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      modelVersionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'modelVersion',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      primaryBiasIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'primaryBias',
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      primaryBiasIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'primaryBias',
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      primaryBiasEqualTo(
    BiasType? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'primaryBias',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      primaryBiasGreaterThan(
    BiasType? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'primaryBias',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      primaryBiasLessThan(
    BiasType? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'primaryBias',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      primaryBiasBetween(
    BiasType? lower,
    BiasType? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'primaryBias',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      primaryBiasStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'primaryBias',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      primaryBiasEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'primaryBias',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      primaryBiasContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'primaryBias',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      primaryBiasMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'primaryBias',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      primaryBiasIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'primaryBias',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      primaryBiasIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'primaryBias',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      riskLevelIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'riskLevel',
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      riskLevelIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'riskLevel',
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      riskLevelEqualTo(
    RiskLevel? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'riskLevel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      riskLevelGreaterThan(
    RiskLevel? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'riskLevel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      riskLevelLessThan(
    RiskLevel? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'riskLevel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      riskLevelBetween(
    RiskLevel? lower,
    RiskLevel? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'riskLevel',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      riskLevelStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'riskLevel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      riskLevelEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'riskLevel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      riskLevelContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'riskLevel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      riskLevelMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'riskLevel',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      riskLevelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'riskLevel',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      riskLevelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'riskLevel',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      serverIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'serverId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      serverIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'serverId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      serverIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'serverId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      serverIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'serverId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      serverIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'serverId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      serverIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'serverId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      serverIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'serverId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      serverIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'serverId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      serverIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'serverId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      serverIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'serverId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      suggestedAlternativeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'suggestedAlternative',
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      suggestedAlternativeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'suggestedAlternative',
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      suggestedAlternativeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'suggestedAlternative',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      suggestedAlternativeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'suggestedAlternative',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      suggestedAlternativeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'suggestedAlternative',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      suggestedAlternativeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'suggestedAlternative',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      suggestedAlternativeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'suggestedAlternative',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      suggestedAlternativeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'suggestedAlternative',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      suggestedAlternativeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'suggestedAlternative',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      suggestedAlternativeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'suggestedAlternative',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      suggestedAlternativeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'suggestedAlternative',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      suggestedAlternativeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'suggestedAlternative',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      triggerContextEqualTo(
    TriggerContext value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'triggerContext',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      triggerContextGreaterThan(
    TriggerContext value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'triggerContext',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      triggerContextLessThan(
    TriggerContext value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'triggerContext',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      triggerContextBetween(
    TriggerContext lower,
    TriggerContext upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'triggerContext',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      triggerContextStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'triggerContext',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      triggerContextEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'triggerContext',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      triggerContextContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'triggerContext',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      triggerContextMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'triggerContext',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      triggerContextIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'triggerContext',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterFilterCondition>
      triggerContextIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'triggerContext',
        value: '',
      ));
    });
  }
}

extension IsarAiInsightQueryObject
    on QueryBuilder<IsarAiInsight, IsarAiInsight, QFilterCondition> {}

extension IsarAiInsightQueryLinks
    on QueryBuilder<IsarAiInsight, IsarAiInsight, QFilterCondition> {}

extension IsarAiInsightQuerySortBy
    on QueryBuilder<IsarAiInsight, IsarAiInsight, QSortBy> {
  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterSortBy>
      sortByActionabilityScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actionabilityScore', Sort.asc);
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterSortBy>
      sortByActionabilityScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actionabilityScore', Sort.desc);
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterSortBy>
      sortByDecisionLocalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'decisionLocalId', Sort.asc);
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterSortBy>
      sortByDecisionLocalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'decisionLocalId', Sort.desc);
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterSortBy>
      sortByDecisionServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'decisionServerId', Sort.asc);
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterSortBy>
      sortByDecisionServerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'decisionServerId', Sort.desc);
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterSortBy>
      sortByEmotionalTone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emotionalTone', Sort.asc);
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterSortBy>
      sortByEmotionalToneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emotionalTone', Sort.desc);
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterSortBy> sortByGeneratedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'generatedAt', Sort.asc);
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterSortBy>
      sortByGeneratedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'generatedAt', Sort.desc);
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterSortBy> sortByInsightText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'insightText', Sort.asc);
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterSortBy>
      sortByInsightTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'insightText', Sort.desc);
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterSortBy>
      sortByModelConfidence() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modelConfidence', Sort.asc);
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterSortBy>
      sortByModelConfidenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modelConfidence', Sort.desc);
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterSortBy>
      sortByModelVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modelVersion', Sort.asc);
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterSortBy>
      sortByModelVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modelVersion', Sort.desc);
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterSortBy> sortByPrimaryBias() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'primaryBias', Sort.asc);
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterSortBy>
      sortByPrimaryBiasDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'primaryBias', Sort.desc);
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterSortBy> sortByRiskLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'riskLevel', Sort.asc);
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterSortBy>
      sortByRiskLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'riskLevel', Sort.desc);
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterSortBy> sortByServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.asc);
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterSortBy>
      sortByServerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.desc);
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterSortBy>
      sortBySuggestedAlternative() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'suggestedAlternative', Sort.asc);
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterSortBy>
      sortBySuggestedAlternativeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'suggestedAlternative', Sort.desc);
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterSortBy>
      sortByTriggerContext() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'triggerContext', Sort.asc);
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterSortBy>
      sortByTriggerContextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'triggerContext', Sort.desc);
    });
  }
}

extension IsarAiInsightQuerySortThenBy
    on QueryBuilder<IsarAiInsight, IsarAiInsight, QSortThenBy> {
  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterSortBy>
      thenByActionabilityScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actionabilityScore', Sort.asc);
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterSortBy>
      thenByActionabilityScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actionabilityScore', Sort.desc);
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterSortBy>
      thenByDecisionLocalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'decisionLocalId', Sort.asc);
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterSortBy>
      thenByDecisionLocalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'decisionLocalId', Sort.desc);
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterSortBy>
      thenByDecisionServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'decisionServerId', Sort.asc);
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterSortBy>
      thenByDecisionServerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'decisionServerId', Sort.desc);
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterSortBy>
      thenByEmotionalTone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emotionalTone', Sort.asc);
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterSortBy>
      thenByEmotionalToneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emotionalTone', Sort.desc);
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterSortBy> thenByGeneratedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'generatedAt', Sort.asc);
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterSortBy>
      thenByGeneratedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'generatedAt', Sort.desc);
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterSortBy> thenByInsightText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'insightText', Sort.asc);
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterSortBy>
      thenByInsightTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'insightText', Sort.desc);
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterSortBy> thenByLocalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localId', Sort.asc);
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterSortBy> thenByLocalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localId', Sort.desc);
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterSortBy>
      thenByModelConfidence() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modelConfidence', Sort.asc);
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterSortBy>
      thenByModelConfidenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modelConfidence', Sort.desc);
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterSortBy>
      thenByModelVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modelVersion', Sort.asc);
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterSortBy>
      thenByModelVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modelVersion', Sort.desc);
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterSortBy> thenByPrimaryBias() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'primaryBias', Sort.asc);
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterSortBy>
      thenByPrimaryBiasDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'primaryBias', Sort.desc);
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterSortBy> thenByRiskLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'riskLevel', Sort.asc);
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterSortBy>
      thenByRiskLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'riskLevel', Sort.desc);
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterSortBy> thenByServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.asc);
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterSortBy>
      thenByServerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.desc);
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterSortBy>
      thenBySuggestedAlternative() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'suggestedAlternative', Sort.asc);
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterSortBy>
      thenBySuggestedAlternativeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'suggestedAlternative', Sort.desc);
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterSortBy>
      thenByTriggerContext() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'triggerContext', Sort.asc);
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QAfterSortBy>
      thenByTriggerContextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'triggerContext', Sort.desc);
    });
  }
}

extension IsarAiInsightQueryWhereDistinct
    on QueryBuilder<IsarAiInsight, IsarAiInsight, QDistinct> {
  QueryBuilder<IsarAiInsight, IsarAiInsight, QDistinct>
      distinctByActionabilityScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'actionabilityScore');
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QDistinct>
      distinctByDecisionLocalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'decisionLocalId');
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QDistinct>
      distinctByDecisionServerId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'decisionServerId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QDistinct> distinctByEmotionalTone(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'emotionalTone',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QDistinct>
      distinctByGeneratedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'generatedAt');
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QDistinct> distinctByInsightText(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'insightText', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QDistinct>
      distinctByModelConfidence() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'modelConfidence');
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QDistinct> distinctByModelVersion(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'modelVersion', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QDistinct> distinctByPrimaryBias(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'primaryBias', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QDistinct> distinctByRiskLevel(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'riskLevel', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QDistinct> distinctByServerId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'serverId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QDistinct>
      distinctBySuggestedAlternative({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'suggestedAlternative',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarAiInsight, IsarAiInsight, QDistinct>
      distinctByTriggerContext({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'triggerContext',
          caseSensitive: caseSensitive);
    });
  }
}

extension IsarAiInsightQueryProperty
    on QueryBuilder<IsarAiInsight, IsarAiInsight, QQueryProperty> {
  QueryBuilder<IsarAiInsight, int, QQueryOperations> localIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'localId');
    });
  }

  QueryBuilder<IsarAiInsight, int?, QQueryOperations>
      actionabilityScoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'actionabilityScore');
    });
  }

  QueryBuilder<IsarAiInsight, int, QQueryOperations> decisionLocalIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'decisionLocalId');
    });
  }

  QueryBuilder<IsarAiInsight, String, QQueryOperations>
      decisionServerIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'decisionServerId');
    });
  }

  QueryBuilder<IsarAiInsight, EmotionalTone?, QQueryOperations>
      emotionalToneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'emotionalTone');
    });
  }

  QueryBuilder<IsarAiInsight, DateTime, QQueryOperations>
      generatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'generatedAt');
    });
  }

  QueryBuilder<IsarAiInsight, String, QQueryOperations> insightTextProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'insightText');
    });
  }

  QueryBuilder<IsarAiInsight, double?, QQueryOperations>
      modelConfidenceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'modelConfidence');
    });
  }

  QueryBuilder<IsarAiInsight, String, QQueryOperations> modelVersionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'modelVersion');
    });
  }

  QueryBuilder<IsarAiInsight, BiasType?, QQueryOperations>
      primaryBiasProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'primaryBias');
    });
  }

  QueryBuilder<IsarAiInsight, RiskLevel?, QQueryOperations>
      riskLevelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'riskLevel');
    });
  }

  QueryBuilder<IsarAiInsight, String, QQueryOperations> serverIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'serverId');
    });
  }

  QueryBuilder<IsarAiInsight, String?, QQueryOperations>
      suggestedAlternativeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'suggestedAlternative');
    });
  }

  QueryBuilder<IsarAiInsight, TriggerContext, QQueryOperations>
      triggerContextProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'triggerContext');
    });
  }
}
