// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_insight.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AiInsight {
  int? get localId => throw _privateConstructorUsedError;
  String? get serverId =>
      throw _privateConstructorUsedError; // Null while processing
  int get decisionLocalId => throw _privateConstructorUsedError;
  String get decisionServerId => throw _privateConstructorUsedError;
  TriggerContext get triggerContext => throw _privateConstructorUsedError;
  InsightStatus get status => throw _privateConstructorUsedError;
  DateTime get requestedAt =>
      throw _privateConstructorUsedError; // The fields below are filled in once status is complete.
  String? get modelVersion => throw _privateConstructorUsedError;
  String? get insightText => throw _privateConstructorUsedError;
  BiasType? get primaryBias =>
      throw _privateConstructorUsedError; // Null when no bias was found
  EmotionalTone? get emotionalTone => throw _privateConstructorUsedError;
  RiskLevel? get riskLevel => throw _privateConstructorUsedError;
  int? get actionabilityScore => throw _privateConstructorUsedError; // 1–10
  String? get suggestedAlternative => throw _privateConstructorUsedError;
  double? get modelConfidence => throw _privateConstructorUsedError; // 0.0–1.0
  DateTime? get generatedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AiInsightCopyWith<AiInsight> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AiInsightCopyWith<$Res> {
  factory $AiInsightCopyWith(AiInsight value, $Res Function(AiInsight) then) =
      _$AiInsightCopyWithImpl<$Res, AiInsight>;
  @useResult
  $Res call(
      {int? localId,
      String? serverId,
      int decisionLocalId,
      String decisionServerId,
      TriggerContext triggerContext,
      InsightStatus status,
      DateTime requestedAt,
      String? modelVersion,
      String? insightText,
      BiasType? primaryBias,
      EmotionalTone? emotionalTone,
      RiskLevel? riskLevel,
      int? actionabilityScore,
      String? suggestedAlternative,
      double? modelConfidence,
      DateTime? generatedAt});
}

/// @nodoc
class _$AiInsightCopyWithImpl<$Res, $Val extends AiInsight>
    implements $AiInsightCopyWith<$Res> {
  _$AiInsightCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? localId = freezed,
    Object? serverId = freezed,
    Object? decisionLocalId = null,
    Object? decisionServerId = null,
    Object? triggerContext = null,
    Object? status = null,
    Object? requestedAt = null,
    Object? modelVersion = freezed,
    Object? insightText = freezed,
    Object? primaryBias = freezed,
    Object? emotionalTone = freezed,
    Object? riskLevel = freezed,
    Object? actionabilityScore = freezed,
    Object? suggestedAlternative = freezed,
    Object? modelConfidence = freezed,
    Object? generatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      localId: freezed == localId
          ? _value.localId
          : localId // ignore: cast_nullable_to_non_nullable
              as int?,
      serverId: freezed == serverId
          ? _value.serverId
          : serverId // ignore: cast_nullable_to_non_nullable
              as String?,
      decisionLocalId: null == decisionLocalId
          ? _value.decisionLocalId
          : decisionLocalId // ignore: cast_nullable_to_non_nullable
              as int,
      decisionServerId: null == decisionServerId
          ? _value.decisionServerId
          : decisionServerId // ignore: cast_nullable_to_non_nullable
              as String,
      triggerContext: null == triggerContext
          ? _value.triggerContext
          : triggerContext // ignore: cast_nullable_to_non_nullable
              as TriggerContext,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as InsightStatus,
      requestedAt: null == requestedAt
          ? _value.requestedAt
          : requestedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      modelVersion: freezed == modelVersion
          ? _value.modelVersion
          : modelVersion // ignore: cast_nullable_to_non_nullable
              as String?,
      insightText: freezed == insightText
          ? _value.insightText
          : insightText // ignore: cast_nullable_to_non_nullable
              as String?,
      primaryBias: freezed == primaryBias
          ? _value.primaryBias
          : primaryBias // ignore: cast_nullable_to_non_nullable
              as BiasType?,
      emotionalTone: freezed == emotionalTone
          ? _value.emotionalTone
          : emotionalTone // ignore: cast_nullable_to_non_nullable
              as EmotionalTone?,
      riskLevel: freezed == riskLevel
          ? _value.riskLevel
          : riskLevel // ignore: cast_nullable_to_non_nullable
              as RiskLevel?,
      actionabilityScore: freezed == actionabilityScore
          ? _value.actionabilityScore
          : actionabilityScore // ignore: cast_nullable_to_non_nullable
              as int?,
      suggestedAlternative: freezed == suggestedAlternative
          ? _value.suggestedAlternative
          : suggestedAlternative // ignore: cast_nullable_to_non_nullable
              as String?,
      modelConfidence: freezed == modelConfidence
          ? _value.modelConfidence
          : modelConfidence // ignore: cast_nullable_to_non_nullable
              as double?,
      generatedAt: freezed == generatedAt
          ? _value.generatedAt
          : generatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AiInsightImplCopyWith<$Res>
    implements $AiInsightCopyWith<$Res> {
  factory _$$AiInsightImplCopyWith(
          _$AiInsightImpl value, $Res Function(_$AiInsightImpl) then) =
      __$$AiInsightImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? localId,
      String? serverId,
      int decisionLocalId,
      String decisionServerId,
      TriggerContext triggerContext,
      InsightStatus status,
      DateTime requestedAt,
      String? modelVersion,
      String? insightText,
      BiasType? primaryBias,
      EmotionalTone? emotionalTone,
      RiskLevel? riskLevel,
      int? actionabilityScore,
      String? suggestedAlternative,
      double? modelConfidence,
      DateTime? generatedAt});
}

/// @nodoc
class __$$AiInsightImplCopyWithImpl<$Res>
    extends _$AiInsightCopyWithImpl<$Res, _$AiInsightImpl>
    implements _$$AiInsightImplCopyWith<$Res> {
  __$$AiInsightImplCopyWithImpl(
      _$AiInsightImpl _value, $Res Function(_$AiInsightImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? localId = freezed,
    Object? serverId = freezed,
    Object? decisionLocalId = null,
    Object? decisionServerId = null,
    Object? triggerContext = null,
    Object? status = null,
    Object? requestedAt = null,
    Object? modelVersion = freezed,
    Object? insightText = freezed,
    Object? primaryBias = freezed,
    Object? emotionalTone = freezed,
    Object? riskLevel = freezed,
    Object? actionabilityScore = freezed,
    Object? suggestedAlternative = freezed,
    Object? modelConfidence = freezed,
    Object? generatedAt = freezed,
  }) {
    return _then(_$AiInsightImpl(
      localId: freezed == localId
          ? _value.localId
          : localId // ignore: cast_nullable_to_non_nullable
              as int?,
      serverId: freezed == serverId
          ? _value.serverId
          : serverId // ignore: cast_nullable_to_non_nullable
              as String?,
      decisionLocalId: null == decisionLocalId
          ? _value.decisionLocalId
          : decisionLocalId // ignore: cast_nullable_to_non_nullable
              as int,
      decisionServerId: null == decisionServerId
          ? _value.decisionServerId
          : decisionServerId // ignore: cast_nullable_to_non_nullable
              as String,
      triggerContext: null == triggerContext
          ? _value.triggerContext
          : triggerContext // ignore: cast_nullable_to_non_nullable
              as TriggerContext,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as InsightStatus,
      requestedAt: null == requestedAt
          ? _value.requestedAt
          : requestedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      modelVersion: freezed == modelVersion
          ? _value.modelVersion
          : modelVersion // ignore: cast_nullable_to_non_nullable
              as String?,
      insightText: freezed == insightText
          ? _value.insightText
          : insightText // ignore: cast_nullable_to_non_nullable
              as String?,
      primaryBias: freezed == primaryBias
          ? _value.primaryBias
          : primaryBias // ignore: cast_nullable_to_non_nullable
              as BiasType?,
      emotionalTone: freezed == emotionalTone
          ? _value.emotionalTone
          : emotionalTone // ignore: cast_nullable_to_non_nullable
              as EmotionalTone?,
      riskLevel: freezed == riskLevel
          ? _value.riskLevel
          : riskLevel // ignore: cast_nullable_to_non_nullable
              as RiskLevel?,
      actionabilityScore: freezed == actionabilityScore
          ? _value.actionabilityScore
          : actionabilityScore // ignore: cast_nullable_to_non_nullable
              as int?,
      suggestedAlternative: freezed == suggestedAlternative
          ? _value.suggestedAlternative
          : suggestedAlternative // ignore: cast_nullable_to_non_nullable
              as String?,
      modelConfidence: freezed == modelConfidence
          ? _value.modelConfidence
          : modelConfidence // ignore: cast_nullable_to_non_nullable
              as double?,
      generatedAt: freezed == generatedAt
          ? _value.generatedAt
          : generatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$AiInsightImpl implements _AiInsight {
  const _$AiInsightImpl(
      {this.localId,
      this.serverId,
      required this.decisionLocalId,
      required this.decisionServerId,
      required this.triggerContext,
      required this.status,
      required this.requestedAt,
      this.modelVersion,
      this.insightText,
      this.primaryBias,
      this.emotionalTone,
      this.riskLevel,
      this.actionabilityScore,
      this.suggestedAlternative,
      this.modelConfidence,
      this.generatedAt});

  @override
  final int? localId;
  @override
  final String? serverId;
// Null while processing
  @override
  final int decisionLocalId;
  @override
  final String decisionServerId;
  @override
  final TriggerContext triggerContext;
  @override
  final InsightStatus status;
  @override
  final DateTime requestedAt;
// The fields below are filled in once status is complete.
  @override
  final String? modelVersion;
  @override
  final String? insightText;
  @override
  final BiasType? primaryBias;
// Null when no bias was found
  @override
  final EmotionalTone? emotionalTone;
  @override
  final RiskLevel? riskLevel;
  @override
  final int? actionabilityScore;
// 1–10
  @override
  final String? suggestedAlternative;
  @override
  final double? modelConfidence;
// 0.0–1.0
  @override
  final DateTime? generatedAt;

  @override
  String toString() {
    return 'AiInsight(localId: $localId, serverId: $serverId, decisionLocalId: $decisionLocalId, decisionServerId: $decisionServerId, triggerContext: $triggerContext, status: $status, requestedAt: $requestedAt, modelVersion: $modelVersion, insightText: $insightText, primaryBias: $primaryBias, emotionalTone: $emotionalTone, riskLevel: $riskLevel, actionabilityScore: $actionabilityScore, suggestedAlternative: $suggestedAlternative, modelConfidence: $modelConfidence, generatedAt: $generatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AiInsightImpl &&
            (identical(other.localId, localId) || other.localId == localId) &&
            (identical(other.serverId, serverId) ||
                other.serverId == serverId) &&
            (identical(other.decisionLocalId, decisionLocalId) ||
                other.decisionLocalId == decisionLocalId) &&
            (identical(other.decisionServerId, decisionServerId) ||
                other.decisionServerId == decisionServerId) &&
            (identical(other.triggerContext, triggerContext) ||
                other.triggerContext == triggerContext) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.requestedAt, requestedAt) ||
                other.requestedAt == requestedAt) &&
            (identical(other.modelVersion, modelVersion) ||
                other.modelVersion == modelVersion) &&
            (identical(other.insightText, insightText) ||
                other.insightText == insightText) &&
            (identical(other.primaryBias, primaryBias) ||
                other.primaryBias == primaryBias) &&
            (identical(other.emotionalTone, emotionalTone) ||
                other.emotionalTone == emotionalTone) &&
            (identical(other.riskLevel, riskLevel) ||
                other.riskLevel == riskLevel) &&
            (identical(other.actionabilityScore, actionabilityScore) ||
                other.actionabilityScore == actionabilityScore) &&
            (identical(other.suggestedAlternative, suggestedAlternative) ||
                other.suggestedAlternative == suggestedAlternative) &&
            (identical(other.modelConfidence, modelConfidence) ||
                other.modelConfidence == modelConfidence) &&
            (identical(other.generatedAt, generatedAt) ||
                other.generatedAt == generatedAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      localId,
      serverId,
      decisionLocalId,
      decisionServerId,
      triggerContext,
      status,
      requestedAt,
      modelVersion,
      insightText,
      primaryBias,
      emotionalTone,
      riskLevel,
      actionabilityScore,
      suggestedAlternative,
      modelConfidence,
      generatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AiInsightImplCopyWith<_$AiInsightImpl> get copyWith =>
      __$$AiInsightImplCopyWithImpl<_$AiInsightImpl>(this, _$identity);
}

abstract class _AiInsight implements AiInsight {
  const factory _AiInsight(
      {final int? localId,
      final String? serverId,
      required final int decisionLocalId,
      required final String decisionServerId,
      required final TriggerContext triggerContext,
      required final InsightStatus status,
      required final DateTime requestedAt,
      final String? modelVersion,
      final String? insightText,
      final BiasType? primaryBias,
      final EmotionalTone? emotionalTone,
      final RiskLevel? riskLevel,
      final int? actionabilityScore,
      final String? suggestedAlternative,
      final double? modelConfidence,
      final DateTime? generatedAt}) = _$AiInsightImpl;

  @override
  int? get localId;
  @override
  String? get serverId;
  @override // Null while processing
  int get decisionLocalId;
  @override
  String get decisionServerId;
  @override
  TriggerContext get triggerContext;
  @override
  InsightStatus get status;
  @override
  DateTime get requestedAt;
  @override // The fields below are filled in once status is complete.
  String? get modelVersion;
  @override
  String? get insightText;
  @override
  BiasType? get primaryBias;
  @override // Null when no bias was found
  EmotionalTone? get emotionalTone;
  @override
  RiskLevel? get riskLevel;
  @override
  int? get actionabilityScore;
  @override // 1–10
  String? get suggestedAlternative;
  @override
  double? get modelConfidence;
  @override // 0.0–1.0
  DateTime? get generatedAt;
  @override
  @JsonKey(ignore: true)
  _$$AiInsightImplCopyWith<_$AiInsightImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
