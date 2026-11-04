// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'evaluation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Evaluation {
  int? get localId => throw _privateConstructorUsedError;
  String? get serverId => throw _privateConstructorUsedError;
  int get decisionLocalId => throw _privateConstructorUsedError;
  String? get decisionServerId => throw _privateConstructorUsedError;
  int? get satisfactionAfter => throw _privateConstructorUsedError; // 1–100
  int? get confidenceAfter =>
      throw _privateConstructorUsedError; // 1–100, compared with Decision.confidenceBefore
  String? get hindsightNotes => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  SyncStatus get syncStatus => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $EvaluationCopyWith<Evaluation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EvaluationCopyWith<$Res> {
  factory $EvaluationCopyWith(
          Evaluation value, $Res Function(Evaluation) then) =
      _$EvaluationCopyWithImpl<$Res, Evaluation>;
  @useResult
  $Res call(
      {int? localId,
      String? serverId,
      int decisionLocalId,
      String? decisionServerId,
      int? satisfactionAfter,
      int? confidenceAfter,
      String? hindsightNotes,
      DateTime createdAt,
      SyncStatus syncStatus});
}

/// @nodoc
class _$EvaluationCopyWithImpl<$Res, $Val extends Evaluation>
    implements $EvaluationCopyWith<$Res> {
  _$EvaluationCopyWithImpl(this._value, this._then);

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
    Object? decisionServerId = freezed,
    Object? satisfactionAfter = freezed,
    Object? confidenceAfter = freezed,
    Object? hindsightNotes = freezed,
    Object? createdAt = null,
    Object? syncStatus = null,
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
      decisionServerId: freezed == decisionServerId
          ? _value.decisionServerId
          : decisionServerId // ignore: cast_nullable_to_non_nullable
              as String?,
      satisfactionAfter: freezed == satisfactionAfter
          ? _value.satisfactionAfter
          : satisfactionAfter // ignore: cast_nullable_to_non_nullable
              as int?,
      confidenceAfter: freezed == confidenceAfter
          ? _value.confidenceAfter
          : confidenceAfter // ignore: cast_nullable_to_non_nullable
              as int?,
      hindsightNotes: freezed == hindsightNotes
          ? _value.hindsightNotes
          : hindsightNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      syncStatus: null == syncStatus
          ? _value.syncStatus
          : syncStatus // ignore: cast_nullable_to_non_nullable
              as SyncStatus,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EvaluationImplCopyWith<$Res>
    implements $EvaluationCopyWith<$Res> {
  factory _$$EvaluationImplCopyWith(
          _$EvaluationImpl value, $Res Function(_$EvaluationImpl) then) =
      __$$EvaluationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? localId,
      String? serverId,
      int decisionLocalId,
      String? decisionServerId,
      int? satisfactionAfter,
      int? confidenceAfter,
      String? hindsightNotes,
      DateTime createdAt,
      SyncStatus syncStatus});
}

/// @nodoc
class __$$EvaluationImplCopyWithImpl<$Res>
    extends _$EvaluationCopyWithImpl<$Res, _$EvaluationImpl>
    implements _$$EvaluationImplCopyWith<$Res> {
  __$$EvaluationImplCopyWithImpl(
      _$EvaluationImpl _value, $Res Function(_$EvaluationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? localId = freezed,
    Object? serverId = freezed,
    Object? decisionLocalId = null,
    Object? decisionServerId = freezed,
    Object? satisfactionAfter = freezed,
    Object? confidenceAfter = freezed,
    Object? hindsightNotes = freezed,
    Object? createdAt = null,
    Object? syncStatus = null,
  }) {
    return _then(_$EvaluationImpl(
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
      decisionServerId: freezed == decisionServerId
          ? _value.decisionServerId
          : decisionServerId // ignore: cast_nullable_to_non_nullable
              as String?,
      satisfactionAfter: freezed == satisfactionAfter
          ? _value.satisfactionAfter
          : satisfactionAfter // ignore: cast_nullable_to_non_nullable
              as int?,
      confidenceAfter: freezed == confidenceAfter
          ? _value.confidenceAfter
          : confidenceAfter // ignore: cast_nullable_to_non_nullable
              as int?,
      hindsightNotes: freezed == hindsightNotes
          ? _value.hindsightNotes
          : hindsightNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      syncStatus: null == syncStatus
          ? _value.syncStatus
          : syncStatus // ignore: cast_nullable_to_non_nullable
              as SyncStatus,
    ));
  }
}

/// @nodoc

class _$EvaluationImpl implements _Evaluation {
  const _$EvaluationImpl(
      {this.localId,
      this.serverId,
      required this.decisionLocalId,
      this.decisionServerId,
      this.satisfactionAfter,
      this.confidenceAfter,
      this.hindsightNotes,
      required this.createdAt,
      this.syncStatus = SyncStatus.pendingCreate});

  @override
  final int? localId;
  @override
  final String? serverId;
  @override
  final int decisionLocalId;
  @override
  final String? decisionServerId;
  @override
  final int? satisfactionAfter;
// 1–100
  @override
  final int? confidenceAfter;
// 1–100, compared with Decision.confidenceBefore
  @override
  final String? hindsightNotes;
  @override
  final DateTime createdAt;
  @override
  @JsonKey()
  final SyncStatus syncStatus;

  @override
  String toString() {
    return 'Evaluation(localId: $localId, serverId: $serverId, decisionLocalId: $decisionLocalId, decisionServerId: $decisionServerId, satisfactionAfter: $satisfactionAfter, confidenceAfter: $confidenceAfter, hindsightNotes: $hindsightNotes, createdAt: $createdAt, syncStatus: $syncStatus)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EvaluationImpl &&
            (identical(other.localId, localId) || other.localId == localId) &&
            (identical(other.serverId, serverId) ||
                other.serverId == serverId) &&
            (identical(other.decisionLocalId, decisionLocalId) ||
                other.decisionLocalId == decisionLocalId) &&
            (identical(other.decisionServerId, decisionServerId) ||
                other.decisionServerId == decisionServerId) &&
            (identical(other.satisfactionAfter, satisfactionAfter) ||
                other.satisfactionAfter == satisfactionAfter) &&
            (identical(other.confidenceAfter, confidenceAfter) ||
                other.confidenceAfter == confidenceAfter) &&
            (identical(other.hindsightNotes, hindsightNotes) ||
                other.hindsightNotes == hindsightNotes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.syncStatus, syncStatus) ||
                other.syncStatus == syncStatus));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      localId,
      serverId,
      decisionLocalId,
      decisionServerId,
      satisfactionAfter,
      confidenceAfter,
      hindsightNotes,
      createdAt,
      syncStatus);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EvaluationImplCopyWith<_$EvaluationImpl> get copyWith =>
      __$$EvaluationImplCopyWithImpl<_$EvaluationImpl>(this, _$identity);
}

abstract class _Evaluation implements Evaluation {
  const factory _Evaluation(
      {final int? localId,
      final String? serverId,
      required final int decisionLocalId,
      final String? decisionServerId,
      final int? satisfactionAfter,
      final int? confidenceAfter,
      final String? hindsightNotes,
      required final DateTime createdAt,
      final SyncStatus syncStatus}) = _$EvaluationImpl;

  @override
  int? get localId;
  @override
  String? get serverId;
  @override
  int get decisionLocalId;
  @override
  String? get decisionServerId;
  @override
  int? get satisfactionAfter;
  @override // 1–100
  int? get confidenceAfter;
  @override // 1–100, compared with Decision.confidenceBefore
  String? get hindsightNotes;
  @override
  DateTime get createdAt;
  @override
  SyncStatus get syncStatus;
  @override
  @JsonKey(ignore: true)
  _$$EvaluationImplCopyWith<_$EvaluationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
