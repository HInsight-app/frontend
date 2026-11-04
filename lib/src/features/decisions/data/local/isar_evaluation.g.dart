// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'isar_evaluation.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetIsarEvaluationCollection on Isar {
  IsarCollection<IsarEvaluation> get isarEvaluations => this.collection();
}

const IsarEvaluationSchema = CollectionSchema(
  name: r'IsarEvaluation',
  id: 8409739834359877288,
  properties: {
    r'confidenceAfter': PropertySchema(
      id: 0,
      name: r'confidenceAfter',
      type: IsarType.long,
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'decisionLocalId': PropertySchema(
      id: 2,
      name: r'decisionLocalId',
      type: IsarType.long,
    ),
    r'decisionServerId': PropertySchema(
      id: 3,
      name: r'decisionServerId',
      type: IsarType.string,
    ),
    r'hindsightNotes': PropertySchema(
      id: 4,
      name: r'hindsightNotes',
      type: IsarType.string,
    ),
    r'satisfactionAfter': PropertySchema(
      id: 5,
      name: r'satisfactionAfter',
      type: IsarType.long,
    ),
    r'serverId': PropertySchema(
      id: 6,
      name: r'serverId',
      type: IsarType.string,
    ),
    r'syncStatus': PropertySchema(
      id: 7,
      name: r'syncStatus',
      type: IsarType.string,
      enumMap: _IsarEvaluationsyncStatusEnumValueMap,
    )
  },
  estimateSize: _isarEvaluationEstimateSize,
  serialize: _isarEvaluationSerialize,
  deserialize: _isarEvaluationDeserialize,
  deserializeProp: _isarEvaluationDeserializeProp,
  idName: r'localId',
  indexes: {
    r'serverId': IndexSchema(
      id: -7950187970872907662,
      name: r'serverId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'serverId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'decisionLocalId': IndexSchema(
      id: -8734928700530079227,
      name: r'decisionLocalId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'decisionLocalId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'syncStatus': IndexSchema(
      id: 8239539375045684509,
      name: r'syncStatus',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'syncStatus',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _isarEvaluationGetId,
  getLinks: _isarEvaluationGetLinks,
  attach: _isarEvaluationAttach,
  version: '3.1.0+1',
);

int _isarEvaluationEstimateSize(
  IsarEvaluation object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.decisionServerId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.hindsightNotes;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.serverId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.syncStatus.name.length * 3;
  return bytesCount;
}

void _isarEvaluationSerialize(
  IsarEvaluation object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.confidenceAfter);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeLong(offsets[2], object.decisionLocalId);
  writer.writeString(offsets[3], object.decisionServerId);
  writer.writeString(offsets[4], object.hindsightNotes);
  writer.writeLong(offsets[5], object.satisfactionAfter);
  writer.writeString(offsets[6], object.serverId);
  writer.writeString(offsets[7], object.syncStatus.name);
}

IsarEvaluation _isarEvaluationDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IsarEvaluation();
  object.confidenceAfter = reader.readLongOrNull(offsets[0]);
  object.createdAt = reader.readDateTime(offsets[1]);
  object.decisionLocalId = reader.readLong(offsets[2]);
  object.decisionServerId = reader.readStringOrNull(offsets[3]);
  object.hindsightNotes = reader.readStringOrNull(offsets[4]);
  object.localId = id;
  object.satisfactionAfter = reader.readLongOrNull(offsets[5]);
  object.serverId = reader.readStringOrNull(offsets[6]);
  object.syncStatus = _IsarEvaluationsyncStatusValueEnumMap[
          reader.readStringOrNull(offsets[7])] ??
      SyncStatus.pendingCreate;
  return object;
}

P _isarEvaluationDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readLongOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (_IsarEvaluationsyncStatusValueEnumMap[
              reader.readStringOrNull(offset)] ??
          SyncStatus.pendingCreate) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _IsarEvaluationsyncStatusEnumValueMap = {
  r'pendingCreate': r'pendingCreate',
  r'pendingUpdate': r'pendingUpdate',
  r'pendingDelete': r'pendingDelete',
  r'synced': r'synced',
};
const _IsarEvaluationsyncStatusValueEnumMap = {
  r'pendingCreate': SyncStatus.pendingCreate,
  r'pendingUpdate': SyncStatus.pendingUpdate,
  r'pendingDelete': SyncStatus.pendingDelete,
  r'synced': SyncStatus.synced,
};

Id _isarEvaluationGetId(IsarEvaluation object) {
  return object.localId;
}

List<IsarLinkBase<dynamic>> _isarEvaluationGetLinks(IsarEvaluation object) {
  return [];
}

void _isarEvaluationAttach(
    IsarCollection<dynamic> col, Id id, IsarEvaluation object) {
  object.localId = id;
}

extension IsarEvaluationByIndex on IsarCollection<IsarEvaluation> {
  Future<IsarEvaluation?> getByDecisionLocalId(int decisionLocalId) {
    return getByIndex(r'decisionLocalId', [decisionLocalId]);
  }

  IsarEvaluation? getByDecisionLocalIdSync(int decisionLocalId) {
    return getByIndexSync(r'decisionLocalId', [decisionLocalId]);
  }

  Future<bool> deleteByDecisionLocalId(int decisionLocalId) {
    return deleteByIndex(r'decisionLocalId', [decisionLocalId]);
  }

  bool deleteByDecisionLocalIdSync(int decisionLocalId) {
    return deleteByIndexSync(r'decisionLocalId', [decisionLocalId]);
  }

  Future<List<IsarEvaluation?>> getAllByDecisionLocalId(
      List<int> decisionLocalIdValues) {
    final values = decisionLocalIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'decisionLocalId', values);
  }

  List<IsarEvaluation?> getAllByDecisionLocalIdSync(
      List<int> decisionLocalIdValues) {
    final values = decisionLocalIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'decisionLocalId', values);
  }

  Future<int> deleteAllByDecisionLocalId(List<int> decisionLocalIdValues) {
    final values = decisionLocalIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'decisionLocalId', values);
  }

  int deleteAllByDecisionLocalIdSync(List<int> decisionLocalIdValues) {
    final values = decisionLocalIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'decisionLocalId', values);
  }

  Future<Id> putByDecisionLocalId(IsarEvaluation object) {
    return putByIndex(r'decisionLocalId', object);
  }

  Id putByDecisionLocalIdSync(IsarEvaluation object, {bool saveLinks = true}) {
    return putByIndexSync(r'decisionLocalId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByDecisionLocalId(List<IsarEvaluation> objects) {
    return putAllByIndex(r'decisionLocalId', objects);
  }

  List<Id> putAllByDecisionLocalIdSync(List<IsarEvaluation> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'decisionLocalId', objects, saveLinks: saveLinks);
  }
}

extension IsarEvaluationQueryWhereSort
    on QueryBuilder<IsarEvaluation, IsarEvaluation, QWhere> {
  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterWhere> anyLocalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterWhere>
      anyDecisionLocalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'decisionLocalId'),
      );
    });
  }
}

extension IsarEvaluationQueryWhere
    on QueryBuilder<IsarEvaluation, IsarEvaluation, QWhereClause> {
  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterWhereClause>
      localIdEqualTo(Id localId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: localId,
        upper: localId,
      ));
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterWhereClause>
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

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterWhereClause>
      localIdGreaterThan(Id localId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: localId, includeLower: include),
      );
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterWhereClause>
      localIdLessThan(Id localId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: localId, includeUpper: include),
      );
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterWhereClause>
      localIdBetween(
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

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterWhereClause>
      serverIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'serverId',
        value: [null],
      ));
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterWhereClause>
      serverIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'serverId',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterWhereClause>
      serverIdEqualTo(String? serverId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'serverId',
        value: [serverId],
      ));
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterWhereClause>
      serverIdNotEqualTo(String? serverId) {
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

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterWhereClause>
      decisionLocalIdEqualTo(int decisionLocalId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'decisionLocalId',
        value: [decisionLocalId],
      ));
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterWhereClause>
      decisionLocalIdNotEqualTo(int decisionLocalId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'decisionLocalId',
              lower: [],
              upper: [decisionLocalId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'decisionLocalId',
              lower: [decisionLocalId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'decisionLocalId',
              lower: [decisionLocalId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'decisionLocalId',
              lower: [],
              upper: [decisionLocalId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterWhereClause>
      decisionLocalIdGreaterThan(
    int decisionLocalId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'decisionLocalId',
        lower: [decisionLocalId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterWhereClause>
      decisionLocalIdLessThan(
    int decisionLocalId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'decisionLocalId',
        lower: [],
        upper: [decisionLocalId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterWhereClause>
      decisionLocalIdBetween(
    int lowerDecisionLocalId,
    int upperDecisionLocalId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'decisionLocalId',
        lower: [lowerDecisionLocalId],
        includeLower: includeLower,
        upper: [upperDecisionLocalId],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterWhereClause>
      syncStatusEqualTo(SyncStatus syncStatus) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'syncStatus',
        value: [syncStatus],
      ));
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterWhereClause>
      syncStatusNotEqualTo(SyncStatus syncStatus) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'syncStatus',
              lower: [],
              upper: [syncStatus],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'syncStatus',
              lower: [syncStatus],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'syncStatus',
              lower: [syncStatus],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'syncStatus',
              lower: [],
              upper: [syncStatus],
              includeUpper: false,
            ));
      }
    });
  }
}

extension IsarEvaluationQueryFilter
    on QueryBuilder<IsarEvaluation, IsarEvaluation, QFilterCondition> {
  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterFilterCondition>
      confidenceAfterIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'confidenceAfter',
      ));
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterFilterCondition>
      confidenceAfterIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'confidenceAfter',
      ));
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterFilterCondition>
      confidenceAfterEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'confidenceAfter',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterFilterCondition>
      confidenceAfterGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'confidenceAfter',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterFilterCondition>
      confidenceAfterLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'confidenceAfter',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterFilterCondition>
      confidenceAfterBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'confidenceAfter',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterFilterCondition>
      createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterFilterCondition>
      createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterFilterCondition>
      decisionLocalIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'decisionLocalId',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterFilterCondition>
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

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterFilterCondition>
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

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterFilterCondition>
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

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterFilterCondition>
      decisionServerIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'decisionServerId',
      ));
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterFilterCondition>
      decisionServerIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'decisionServerId',
      ));
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterFilterCondition>
      decisionServerIdEqualTo(
    String? value, {
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

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterFilterCondition>
      decisionServerIdGreaterThan(
    String? value, {
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

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterFilterCondition>
      decisionServerIdLessThan(
    String? value, {
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

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterFilterCondition>
      decisionServerIdBetween(
    String? lower,
    String? upper, {
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

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterFilterCondition>
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

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterFilterCondition>
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

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterFilterCondition>
      decisionServerIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'decisionServerId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterFilterCondition>
      decisionServerIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'decisionServerId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterFilterCondition>
      decisionServerIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'decisionServerId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterFilterCondition>
      decisionServerIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'decisionServerId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterFilterCondition>
      hindsightNotesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'hindsightNotes',
      ));
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterFilterCondition>
      hindsightNotesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'hindsightNotes',
      ));
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterFilterCondition>
      hindsightNotesEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hindsightNotes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterFilterCondition>
      hindsightNotesGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hindsightNotes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterFilterCondition>
      hindsightNotesLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hindsightNotes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterFilterCondition>
      hindsightNotesBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hindsightNotes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterFilterCondition>
      hindsightNotesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'hindsightNotes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterFilterCondition>
      hindsightNotesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'hindsightNotes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterFilterCondition>
      hindsightNotesContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'hindsightNotes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterFilterCondition>
      hindsightNotesMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'hindsightNotes',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterFilterCondition>
      hindsightNotesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hindsightNotes',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterFilterCondition>
      hindsightNotesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'hindsightNotes',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterFilterCondition>
      localIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'localId',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterFilterCondition>
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

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterFilterCondition>
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

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterFilterCondition>
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

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterFilterCondition>
      satisfactionAfterIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'satisfactionAfter',
      ));
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterFilterCondition>
      satisfactionAfterIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'satisfactionAfter',
      ));
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterFilterCondition>
      satisfactionAfterEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'satisfactionAfter',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterFilterCondition>
      satisfactionAfterGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'satisfactionAfter',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterFilterCondition>
      satisfactionAfterLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'satisfactionAfter',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterFilterCondition>
      satisfactionAfterBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'satisfactionAfter',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterFilterCondition>
      serverIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'serverId',
      ));
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterFilterCondition>
      serverIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'serverId',
      ));
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterFilterCondition>
      serverIdEqualTo(
    String? value, {
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

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterFilterCondition>
      serverIdGreaterThan(
    String? value, {
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

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterFilterCondition>
      serverIdLessThan(
    String? value, {
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

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterFilterCondition>
      serverIdBetween(
    String? lower,
    String? upper, {
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

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterFilterCondition>
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

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterFilterCondition>
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

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterFilterCondition>
      serverIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'serverId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterFilterCondition>
      serverIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'serverId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterFilterCondition>
      serverIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'serverId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterFilterCondition>
      serverIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'serverId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterFilterCondition>
      syncStatusEqualTo(
    SyncStatus value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'syncStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterFilterCondition>
      syncStatusGreaterThan(
    SyncStatus value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'syncStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterFilterCondition>
      syncStatusLessThan(
    SyncStatus value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'syncStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterFilterCondition>
      syncStatusBetween(
    SyncStatus lower,
    SyncStatus upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'syncStatus',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterFilterCondition>
      syncStatusStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'syncStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterFilterCondition>
      syncStatusEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'syncStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterFilterCondition>
      syncStatusContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'syncStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterFilterCondition>
      syncStatusMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'syncStatus',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterFilterCondition>
      syncStatusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'syncStatus',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterFilterCondition>
      syncStatusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'syncStatus',
        value: '',
      ));
    });
  }
}

extension IsarEvaluationQueryObject
    on QueryBuilder<IsarEvaluation, IsarEvaluation, QFilterCondition> {}

extension IsarEvaluationQueryLinks
    on QueryBuilder<IsarEvaluation, IsarEvaluation, QFilterCondition> {}

extension IsarEvaluationQuerySortBy
    on QueryBuilder<IsarEvaluation, IsarEvaluation, QSortBy> {
  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterSortBy>
      sortByConfidenceAfter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confidenceAfter', Sort.asc);
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterSortBy>
      sortByConfidenceAfterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confidenceAfter', Sort.desc);
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterSortBy>
      sortByDecisionLocalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'decisionLocalId', Sort.asc);
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterSortBy>
      sortByDecisionLocalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'decisionLocalId', Sort.desc);
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterSortBy>
      sortByDecisionServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'decisionServerId', Sort.asc);
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterSortBy>
      sortByDecisionServerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'decisionServerId', Sort.desc);
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterSortBy>
      sortByHindsightNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hindsightNotes', Sort.asc);
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterSortBy>
      sortByHindsightNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hindsightNotes', Sort.desc);
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterSortBy>
      sortBySatisfactionAfter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'satisfactionAfter', Sort.asc);
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterSortBy>
      sortBySatisfactionAfterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'satisfactionAfter', Sort.desc);
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterSortBy> sortByServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.asc);
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterSortBy>
      sortByServerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.desc);
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterSortBy>
      sortBySyncStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.asc);
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterSortBy>
      sortBySyncStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.desc);
    });
  }
}

extension IsarEvaluationQuerySortThenBy
    on QueryBuilder<IsarEvaluation, IsarEvaluation, QSortThenBy> {
  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterSortBy>
      thenByConfidenceAfter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confidenceAfter', Sort.asc);
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterSortBy>
      thenByConfidenceAfterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confidenceAfter', Sort.desc);
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterSortBy>
      thenByDecisionLocalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'decisionLocalId', Sort.asc);
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterSortBy>
      thenByDecisionLocalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'decisionLocalId', Sort.desc);
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterSortBy>
      thenByDecisionServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'decisionServerId', Sort.asc);
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterSortBy>
      thenByDecisionServerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'decisionServerId', Sort.desc);
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterSortBy>
      thenByHindsightNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hindsightNotes', Sort.asc);
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterSortBy>
      thenByHindsightNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hindsightNotes', Sort.desc);
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterSortBy> thenByLocalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localId', Sort.asc);
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterSortBy>
      thenByLocalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localId', Sort.desc);
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterSortBy>
      thenBySatisfactionAfter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'satisfactionAfter', Sort.asc);
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterSortBy>
      thenBySatisfactionAfterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'satisfactionAfter', Sort.desc);
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterSortBy> thenByServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.asc);
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterSortBy>
      thenByServerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.desc);
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterSortBy>
      thenBySyncStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.asc);
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QAfterSortBy>
      thenBySyncStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.desc);
    });
  }
}

extension IsarEvaluationQueryWhereDistinct
    on QueryBuilder<IsarEvaluation, IsarEvaluation, QDistinct> {
  QueryBuilder<IsarEvaluation, IsarEvaluation, QDistinct>
      distinctByConfidenceAfter() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'confidenceAfter');
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QDistinct>
      distinctByDecisionLocalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'decisionLocalId');
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QDistinct>
      distinctByDecisionServerId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'decisionServerId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QDistinct>
      distinctByHindsightNotes({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hindsightNotes',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QDistinct>
      distinctBySatisfactionAfter() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'satisfactionAfter');
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QDistinct> distinctByServerId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'serverId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarEvaluation, IsarEvaluation, QDistinct> distinctBySyncStatus(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'syncStatus', caseSensitive: caseSensitive);
    });
  }
}

extension IsarEvaluationQueryProperty
    on QueryBuilder<IsarEvaluation, IsarEvaluation, QQueryProperty> {
  QueryBuilder<IsarEvaluation, int, QQueryOperations> localIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'localId');
    });
  }

  QueryBuilder<IsarEvaluation, int?, QQueryOperations>
      confidenceAfterProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'confidenceAfter');
    });
  }

  QueryBuilder<IsarEvaluation, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<IsarEvaluation, int, QQueryOperations>
      decisionLocalIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'decisionLocalId');
    });
  }

  QueryBuilder<IsarEvaluation, String?, QQueryOperations>
      decisionServerIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'decisionServerId');
    });
  }

  QueryBuilder<IsarEvaluation, String?, QQueryOperations>
      hindsightNotesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hindsightNotes');
    });
  }

  QueryBuilder<IsarEvaluation, int?, QQueryOperations>
      satisfactionAfterProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'satisfactionAfter');
    });
  }

  QueryBuilder<IsarEvaluation, String?, QQueryOperations> serverIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'serverId');
    });
  }

  QueryBuilder<IsarEvaluation, SyncStatus, QQueryOperations>
      syncStatusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'syncStatus');
    });
  }
}
