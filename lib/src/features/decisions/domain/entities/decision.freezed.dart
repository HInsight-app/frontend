// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'decision.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Decision {
  int? get localId =>
      throw _privateConstructorUsedError; // Null until first saved on the device
  String? get serverId =>
      throw _privateConstructorUsedError; // Null until synced
  String get userId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get context => throw _privateConstructorUsedError;
  int? get confidenceBefore => throw _privateConstructorUsedError; // 1–100
  DateTime? get scheduledReviewDate => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  DateTime? get deletedAt => throw _privateConstructorUsedError;
  List<DecisionOption> get options => throw _privateConstructorUsedError;
  DecisionOutcome? get outcome => throw _privateConstructorUsedError;
  List<int> get tagLocalIds => throw _privateConstructorUsedError;
  DecisionStatus get status => throw _privateConstructorUsedError;
  SyncStatus get syncStatus => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DecisionCopyWith<Decision> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DecisionCopyWith<$Res> {
  factory $DecisionCopyWith(Decision value, $Res Function(Decision) then) =
      _$DecisionCopyWithImpl<$Res, Decision>;
  @useResult
  $Res call(
      {int? localId,
      String? serverId,
      String userId,
      String title,
      String? context,
      int? confidenceBefore,
      DateTime? scheduledReviewDate,
      DateTime createdAt,
      DateTime updatedAt,
      DateTime? deletedAt,
      List<DecisionOption> options,
      DecisionOutcome? outcome,
      List<int> tagLocalIds,
      DecisionStatus status,
      SyncStatus syncStatus});

  $DecisionOutcomeCopyWith<$Res>? get outcome;
}

/// @nodoc
class _$DecisionCopyWithImpl<$Res, $Val extends Decision>
    implements $DecisionCopyWith<$Res> {
  _$DecisionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? localId = freezed,
    Object? serverId = freezed,
    Object? userId = null,
    Object? title = null,
    Object? context = freezed,
    Object? confidenceBefore = freezed,
    Object? scheduledReviewDate = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? deletedAt = freezed,
    Object? options = null,
    Object? outcome = freezed,
    Object? tagLocalIds = null,
    Object? status = null,
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
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      context: freezed == context
          ? _value.context
          : context // ignore: cast_nullable_to_non_nullable
              as String?,
      confidenceBefore: freezed == confidenceBefore
          ? _value.confidenceBefore
          : confidenceBefore // ignore: cast_nullable_to_non_nullable
              as int?,
      scheduledReviewDate: freezed == scheduledReviewDate
          ? _value.scheduledReviewDate
          : scheduledReviewDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      options: null == options
          ? _value.options
          : options // ignore: cast_nullable_to_non_nullable
              as List<DecisionOption>,
      outcome: freezed == outcome
          ? _value.outcome
          : outcome // ignore: cast_nullable_to_non_nullable
              as DecisionOutcome?,
      tagLocalIds: null == tagLocalIds
          ? _value.tagLocalIds
          : tagLocalIds // ignore: cast_nullable_to_non_nullable
              as List<int>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as DecisionStatus,
      syncStatus: null == syncStatus
          ? _value.syncStatus
          : syncStatus // ignore: cast_nullable_to_non_nullable
              as SyncStatus,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $DecisionOutcomeCopyWith<$Res>? get outcome {
    if (_value.outcome == null) {
      return null;
    }

    return $DecisionOutcomeCopyWith<$Res>(_value.outcome!, (value) {
      return _then(_value.copyWith(outcome: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DecisionImplCopyWith<$Res>
    implements $DecisionCopyWith<$Res> {
  factory _$$DecisionImplCopyWith(
          _$DecisionImpl value, $Res Function(_$DecisionImpl) then) =
      __$$DecisionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? localId,
      String? serverId,
      String userId,
      String title,
      String? context,
      int? confidenceBefore,
      DateTime? scheduledReviewDate,
      DateTime createdAt,
      DateTime updatedAt,
      DateTime? deletedAt,
      List<DecisionOption> options,
      DecisionOutcome? outcome,
      List<int> tagLocalIds,
      DecisionStatus status,
      SyncStatus syncStatus});

  @override
  $DecisionOutcomeCopyWith<$Res>? get outcome;
}

/// @nodoc
class __$$DecisionImplCopyWithImpl<$Res>
    extends _$DecisionCopyWithImpl<$Res, _$DecisionImpl>
    implements _$$DecisionImplCopyWith<$Res> {
  __$$DecisionImplCopyWithImpl(
      _$DecisionImpl _value, $Res Function(_$DecisionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? localId = freezed,
    Object? serverId = freezed,
    Object? userId = null,
    Object? title = null,
    Object? context = freezed,
    Object? confidenceBefore = freezed,
    Object? scheduledReviewDate = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? deletedAt = freezed,
    Object? options = null,
    Object? outcome = freezed,
    Object? tagLocalIds = null,
    Object? status = null,
    Object? syncStatus = null,
  }) {
    return _then(_$DecisionImpl(
      localId: freezed == localId
          ? _value.localId
          : localId // ignore: cast_nullable_to_non_nullable
              as int?,
      serverId: freezed == serverId
          ? _value.serverId
          : serverId // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      context: freezed == context
          ? _value.context
          : context // ignore: cast_nullable_to_non_nullable
              as String?,
      confidenceBefore: freezed == confidenceBefore
          ? _value.confidenceBefore
          : confidenceBefore // ignore: cast_nullable_to_non_nullable
              as int?,
      scheduledReviewDate: freezed == scheduledReviewDate
          ? _value.scheduledReviewDate
          : scheduledReviewDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      options: null == options
          ? _value._options
          : options // ignore: cast_nullable_to_non_nullable
              as List<DecisionOption>,
      outcome: freezed == outcome
          ? _value.outcome
          : outcome // ignore: cast_nullable_to_non_nullable
              as DecisionOutcome?,
      tagLocalIds: null == tagLocalIds
          ? _value._tagLocalIds
          : tagLocalIds // ignore: cast_nullable_to_non_nullable
              as List<int>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as DecisionStatus,
      syncStatus: null == syncStatus
          ? _value.syncStatus
          : syncStatus // ignore: cast_nullable_to_non_nullable
              as SyncStatus,
    ));
  }
}

/// @nodoc

class _$DecisionImpl extends _Decision {
  const _$DecisionImpl(
      {this.localId,
      this.serverId,
      required this.userId,
      required this.title,
      this.context,
      this.confidenceBefore,
      this.scheduledReviewDate,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt,
      final List<DecisionOption> options = const <DecisionOption>[],
      this.outcome,
      final List<int> tagLocalIds = const <int>[],
      this.status = DecisionStatus.pending,
      this.syncStatus = SyncStatus.pendingCreate})
      : _options = options,
        _tagLocalIds = tagLocalIds,
        super._();

  @override
  final int? localId;
// Null until first saved on the device
  @override
  final String? serverId;
// Null until synced
  @override
  final String userId;
  @override
  final String title;
  @override
  final String? context;
  @override
  final int? confidenceBefore;
// 1–100
  @override
  final DateTime? scheduledReviewDate;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final DateTime? deletedAt;
  final List<DecisionOption> _options;
  @override
  @JsonKey()
  List<DecisionOption> get options {
    if (_options is EqualUnmodifiableListView) return _options;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_options);
  }

  @override
  final DecisionOutcome? outcome;
  final List<int> _tagLocalIds;
  @override
  @JsonKey()
  List<int> get tagLocalIds {
    if (_tagLocalIds is EqualUnmodifiableListView) return _tagLocalIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tagLocalIds);
  }

  @override
  @JsonKey()
  final DecisionStatus status;
  @override
  @JsonKey()
  final SyncStatus syncStatus;

  @override
  String toString() {
    return 'Decision(localId: $localId, serverId: $serverId, userId: $userId, title: $title, context: $context, confidenceBefore: $confidenceBefore, scheduledReviewDate: $scheduledReviewDate, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, options: $options, outcome: $outcome, tagLocalIds: $tagLocalIds, status: $status, syncStatus: $syncStatus)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DecisionImpl &&
            (identical(other.localId, localId) || other.localId == localId) &&
            (identical(other.serverId, serverId) ||
                other.serverId == serverId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.context, context) || other.context == context) &&
            (identical(other.confidenceBefore, confidenceBefore) ||
                other.confidenceBefore == confidenceBefore) &&
            (identical(other.scheduledReviewDate, scheduledReviewDate) ||
                other.scheduledReviewDate == scheduledReviewDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt) &&
            const DeepCollectionEquality().equals(other._options, _options) &&
            (identical(other.outcome, outcome) || other.outcome == outcome) &&
            const DeepCollectionEquality()
                .equals(other._tagLocalIds, _tagLocalIds) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.syncStatus, syncStatus) ||
                other.syncStatus == syncStatus));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      localId,
      serverId,
      userId,
      title,
      context,
      confidenceBefore,
      scheduledReviewDate,
      createdAt,
      updatedAt,
      deletedAt,
      const DeepCollectionEquality().hash(_options),
      outcome,
      const DeepCollectionEquality().hash(_tagLocalIds),
      status,
      syncStatus);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DecisionImplCopyWith<_$DecisionImpl> get copyWith =>
      __$$DecisionImplCopyWithImpl<_$DecisionImpl>(this, _$identity);
}

abstract class _Decision extends Decision {
  const factory _Decision(
      {final int? localId,
      final String? serverId,
      required final String userId,
      required final String title,
      final String? context,
      final int? confidenceBefore,
      final DateTime? scheduledReviewDate,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final DateTime? deletedAt,
      final List<DecisionOption> options,
      final DecisionOutcome? outcome,
      final List<int> tagLocalIds,
      final DecisionStatus status,
      final SyncStatus syncStatus}) = _$DecisionImpl;
  const _Decision._() : super._();

  @override
  int? get localId;
  @override // Null until first saved on the device
  String? get serverId;
  @override // Null until synced
  String get userId;
  @override
  String get title;
  @override
  String? get context;
  @override
  int? get confidenceBefore;
  @override // 1–100
  DateTime? get scheduledReviewDate;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  DateTime? get deletedAt;
  @override
  List<DecisionOption> get options;
  @override
  DecisionOutcome? get outcome;
  @override
  List<int> get tagLocalIds;
  @override
  DecisionStatus get status;
  @override
  SyncStatus get syncStatus;
  @override
  @JsonKey(ignore: true)
  _$$DecisionImplCopyWith<_$DecisionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$DecisionOption {
  String get key =>
      throw _privateConstructorUsedError; // Client-made UUID, stable before sync
  String? get serverId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  List<String> get pros => throw _privateConstructorUsedError;
  List<String> get cons => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DecisionOptionCopyWith<DecisionOption> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DecisionOptionCopyWith<$Res> {
  factory $DecisionOptionCopyWith(
          DecisionOption value, $Res Function(DecisionOption) then) =
      _$DecisionOptionCopyWithImpl<$Res, DecisionOption>;
  @useResult
  $Res call(
      {String key,
      String? serverId,
      String title,
      List<String> pros,
      List<String> cons,
      DateTime createdAt});
}

/// @nodoc
class _$DecisionOptionCopyWithImpl<$Res, $Val extends DecisionOption>
    implements $DecisionOptionCopyWith<$Res> {
  _$DecisionOptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? serverId = freezed,
    Object? title = null,
    Object? pros = null,
    Object? cons = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      serverId: freezed == serverId
          ? _value.serverId
          : serverId // ignore: cast_nullable_to_non_nullable
              as String?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      pros: null == pros
          ? _value.pros
          : pros // ignore: cast_nullable_to_non_nullable
              as List<String>,
      cons: null == cons
          ? _value.cons
          : cons // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DecisionOptionImplCopyWith<$Res>
    implements $DecisionOptionCopyWith<$Res> {
  factory _$$DecisionOptionImplCopyWith(_$DecisionOptionImpl value,
          $Res Function(_$DecisionOptionImpl) then) =
      __$$DecisionOptionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String key,
      String? serverId,
      String title,
      List<String> pros,
      List<String> cons,
      DateTime createdAt});
}

/// @nodoc
class __$$DecisionOptionImplCopyWithImpl<$Res>
    extends _$DecisionOptionCopyWithImpl<$Res, _$DecisionOptionImpl>
    implements _$$DecisionOptionImplCopyWith<$Res> {
  __$$DecisionOptionImplCopyWithImpl(
      _$DecisionOptionImpl _value, $Res Function(_$DecisionOptionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? serverId = freezed,
    Object? title = null,
    Object? pros = null,
    Object? cons = null,
    Object? createdAt = null,
  }) {
    return _then(_$DecisionOptionImpl(
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      serverId: freezed == serverId
          ? _value.serverId
          : serverId // ignore: cast_nullable_to_non_nullable
              as String?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      pros: null == pros
          ? _value._pros
          : pros // ignore: cast_nullable_to_non_nullable
              as List<String>,
      cons: null == cons
          ? _value._cons
          : cons // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$DecisionOptionImpl implements _DecisionOption {
  const _$DecisionOptionImpl(
      {required this.key,
      this.serverId,
      required this.title,
      final List<String> pros = const <String>[],
      final List<String> cons = const <String>[],
      required this.createdAt})
      : _pros = pros,
        _cons = cons;

  @override
  final String key;
// Client-made UUID, stable before sync
  @override
  final String? serverId;
  @override
  final String title;
  final List<String> _pros;
  @override
  @JsonKey()
  List<String> get pros {
    if (_pros is EqualUnmodifiableListView) return _pros;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pros);
  }

  final List<String> _cons;
  @override
  @JsonKey()
  List<String> get cons {
    if (_cons is EqualUnmodifiableListView) return _cons;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cons);
  }

  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'DecisionOption(key: $key, serverId: $serverId, title: $title, pros: $pros, cons: $cons, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DecisionOptionImpl &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.serverId, serverId) ||
                other.serverId == serverId) &&
            (identical(other.title, title) || other.title == title) &&
            const DeepCollectionEquality().equals(other._pros, _pros) &&
            const DeepCollectionEquality().equals(other._cons, _cons) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      key,
      serverId,
      title,
      const DeepCollectionEquality().hash(_pros),
      const DeepCollectionEquality().hash(_cons),
      createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DecisionOptionImplCopyWith<_$DecisionOptionImpl> get copyWith =>
      __$$DecisionOptionImplCopyWithImpl<_$DecisionOptionImpl>(
          this, _$identity);
}

abstract class _DecisionOption implements DecisionOption {
  const factory _DecisionOption(
      {required final String key,
      final String? serverId,
      required final String title,
      final List<String> pros,
      final List<String> cons,
      required final DateTime createdAt}) = _$DecisionOptionImpl;

  @override
  String get key;
  @override // Client-made UUID, stable before sync
  String? get serverId;
  @override
  String get title;
  @override
  List<String> get pros;
  @override
  List<String> get cons;
  @override
  DateTime get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$DecisionOptionImplCopyWith<_$DecisionOptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$DecisionOutcome {
  String get chosenOptionKey => throw _privateConstructorUsedError;
  String? get commitmentNote => throw _privateConstructorUsedError;
  DateTime get decidedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DecisionOutcomeCopyWith<DecisionOutcome> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DecisionOutcomeCopyWith<$Res> {
  factory $DecisionOutcomeCopyWith(
          DecisionOutcome value, $Res Function(DecisionOutcome) then) =
      _$DecisionOutcomeCopyWithImpl<$Res, DecisionOutcome>;
  @useResult
  $Res call(
      {String chosenOptionKey, String? commitmentNote, DateTime decidedAt});
}

/// @nodoc
class _$DecisionOutcomeCopyWithImpl<$Res, $Val extends DecisionOutcome>
    implements $DecisionOutcomeCopyWith<$Res> {
  _$DecisionOutcomeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? chosenOptionKey = null,
    Object? commitmentNote = freezed,
    Object? decidedAt = null,
  }) {
    return _then(_value.copyWith(
      chosenOptionKey: null == chosenOptionKey
          ? _value.chosenOptionKey
          : chosenOptionKey // ignore: cast_nullable_to_non_nullable
              as String,
      commitmentNote: freezed == commitmentNote
          ? _value.commitmentNote
          : commitmentNote // ignore: cast_nullable_to_non_nullable
              as String?,
      decidedAt: null == decidedAt
          ? _value.decidedAt
          : decidedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DecisionOutcomeImplCopyWith<$Res>
    implements $DecisionOutcomeCopyWith<$Res> {
  factory _$$DecisionOutcomeImplCopyWith(_$DecisionOutcomeImpl value,
          $Res Function(_$DecisionOutcomeImpl) then) =
      __$$DecisionOutcomeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String chosenOptionKey, String? commitmentNote, DateTime decidedAt});
}

/// @nodoc
class __$$DecisionOutcomeImplCopyWithImpl<$Res>
    extends _$DecisionOutcomeCopyWithImpl<$Res, _$DecisionOutcomeImpl>
    implements _$$DecisionOutcomeImplCopyWith<$Res> {
  __$$DecisionOutcomeImplCopyWithImpl(
      _$DecisionOutcomeImpl _value, $Res Function(_$DecisionOutcomeImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? chosenOptionKey = null,
    Object? commitmentNote = freezed,
    Object? decidedAt = null,
  }) {
    return _then(_$DecisionOutcomeImpl(
      chosenOptionKey: null == chosenOptionKey
          ? _value.chosenOptionKey
          : chosenOptionKey // ignore: cast_nullable_to_non_nullable
              as String,
      commitmentNote: freezed == commitmentNote
          ? _value.commitmentNote
          : commitmentNote // ignore: cast_nullable_to_non_nullable
              as String?,
      decidedAt: null == decidedAt
          ? _value.decidedAt
          : decidedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$DecisionOutcomeImpl implements _DecisionOutcome {
  const _$DecisionOutcomeImpl(
      {required this.chosenOptionKey,
      this.commitmentNote,
      required this.decidedAt});

  @override
  final String chosenOptionKey;
  @override
  final String? commitmentNote;
  @override
  final DateTime decidedAt;

  @override
  String toString() {
    return 'DecisionOutcome(chosenOptionKey: $chosenOptionKey, commitmentNote: $commitmentNote, decidedAt: $decidedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DecisionOutcomeImpl &&
            (identical(other.chosenOptionKey, chosenOptionKey) ||
                other.chosenOptionKey == chosenOptionKey) &&
            (identical(other.commitmentNote, commitmentNote) ||
                other.commitmentNote == commitmentNote) &&
            (identical(other.decidedAt, decidedAt) ||
                other.decidedAt == decidedAt));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, chosenOptionKey, commitmentNote, decidedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DecisionOutcomeImplCopyWith<_$DecisionOutcomeImpl> get copyWith =>
      __$$DecisionOutcomeImplCopyWithImpl<_$DecisionOutcomeImpl>(
          this, _$identity);
}

abstract class _DecisionOutcome implements DecisionOutcome {
  const factory _DecisionOutcome(
      {required final String chosenOptionKey,
      final String? commitmentNote,
      required final DateTime decidedAt}) = _$DecisionOutcomeImpl;

  @override
  String get chosenOptionKey;
  @override
  String? get commitmentNote;
  @override
  DateTime get decidedAt;
  @override
  @JsonKey(ignore: true)
  _$$DecisionOutcomeImplCopyWith<_$DecisionOutcomeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$DecisionDraft {
  String get title => throw _privateConstructorUsedError;
  String? get context => throw _privateConstructorUsedError;
  int? get confidenceBefore => throw _privateConstructorUsedError;
  DateTime? get scheduledReviewDate => throw _privateConstructorUsedError;
  List<OptionDraft> get options => throw _privateConstructorUsedError;
  List<int> get tagLocalIds => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DecisionDraftCopyWith<DecisionDraft> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DecisionDraftCopyWith<$Res> {
  factory $DecisionDraftCopyWith(
          DecisionDraft value, $Res Function(DecisionDraft) then) =
      _$DecisionDraftCopyWithImpl<$Res, DecisionDraft>;
  @useResult
  $Res call(
      {String title,
      String? context,
      int? confidenceBefore,
      DateTime? scheduledReviewDate,
      List<OptionDraft> options,
      List<int> tagLocalIds});
}

/// @nodoc
class _$DecisionDraftCopyWithImpl<$Res, $Val extends DecisionDraft>
    implements $DecisionDraftCopyWith<$Res> {
  _$DecisionDraftCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? context = freezed,
    Object? confidenceBefore = freezed,
    Object? scheduledReviewDate = freezed,
    Object? options = null,
    Object? tagLocalIds = null,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      context: freezed == context
          ? _value.context
          : context // ignore: cast_nullable_to_non_nullable
              as String?,
      confidenceBefore: freezed == confidenceBefore
          ? _value.confidenceBefore
          : confidenceBefore // ignore: cast_nullable_to_non_nullable
              as int?,
      scheduledReviewDate: freezed == scheduledReviewDate
          ? _value.scheduledReviewDate
          : scheduledReviewDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      options: null == options
          ? _value.options
          : options // ignore: cast_nullable_to_non_nullable
              as List<OptionDraft>,
      tagLocalIds: null == tagLocalIds
          ? _value.tagLocalIds
          : tagLocalIds // ignore: cast_nullable_to_non_nullable
              as List<int>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DecisionDraftImplCopyWith<$Res>
    implements $DecisionDraftCopyWith<$Res> {
  factory _$$DecisionDraftImplCopyWith(
          _$DecisionDraftImpl value, $Res Function(_$DecisionDraftImpl) then) =
      __$$DecisionDraftImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String title,
      String? context,
      int? confidenceBefore,
      DateTime? scheduledReviewDate,
      List<OptionDraft> options,
      List<int> tagLocalIds});
}

/// @nodoc
class __$$DecisionDraftImplCopyWithImpl<$Res>
    extends _$DecisionDraftCopyWithImpl<$Res, _$DecisionDraftImpl>
    implements _$$DecisionDraftImplCopyWith<$Res> {
  __$$DecisionDraftImplCopyWithImpl(
      _$DecisionDraftImpl _value, $Res Function(_$DecisionDraftImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? context = freezed,
    Object? confidenceBefore = freezed,
    Object? scheduledReviewDate = freezed,
    Object? options = null,
    Object? tagLocalIds = null,
  }) {
    return _then(_$DecisionDraftImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      context: freezed == context
          ? _value.context
          : context // ignore: cast_nullable_to_non_nullable
              as String?,
      confidenceBefore: freezed == confidenceBefore
          ? _value.confidenceBefore
          : confidenceBefore // ignore: cast_nullable_to_non_nullable
              as int?,
      scheduledReviewDate: freezed == scheduledReviewDate
          ? _value.scheduledReviewDate
          : scheduledReviewDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      options: null == options
          ? _value._options
          : options // ignore: cast_nullable_to_non_nullable
              as List<OptionDraft>,
      tagLocalIds: null == tagLocalIds
          ? _value._tagLocalIds
          : tagLocalIds // ignore: cast_nullable_to_non_nullable
              as List<int>,
    ));
  }
}

/// @nodoc

class _$DecisionDraftImpl implements _DecisionDraft {
  const _$DecisionDraftImpl(
      {required this.title,
      this.context,
      this.confidenceBefore,
      this.scheduledReviewDate,
      final List<OptionDraft> options = const <OptionDraft>[],
      final List<int> tagLocalIds = const <int>[]})
      : _options = options,
        _tagLocalIds = tagLocalIds;

  @override
  final String title;
  @override
  final String? context;
  @override
  final int? confidenceBefore;
  @override
  final DateTime? scheduledReviewDate;
  final List<OptionDraft> _options;
  @override
  @JsonKey()
  List<OptionDraft> get options {
    if (_options is EqualUnmodifiableListView) return _options;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_options);
  }

  final List<int> _tagLocalIds;
  @override
  @JsonKey()
  List<int> get tagLocalIds {
    if (_tagLocalIds is EqualUnmodifiableListView) return _tagLocalIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tagLocalIds);
  }

  @override
  String toString() {
    return 'DecisionDraft(title: $title, context: $context, confidenceBefore: $confidenceBefore, scheduledReviewDate: $scheduledReviewDate, options: $options, tagLocalIds: $tagLocalIds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DecisionDraftImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.context, context) || other.context == context) &&
            (identical(other.confidenceBefore, confidenceBefore) ||
                other.confidenceBefore == confidenceBefore) &&
            (identical(other.scheduledReviewDate, scheduledReviewDate) ||
                other.scheduledReviewDate == scheduledReviewDate) &&
            const DeepCollectionEquality().equals(other._options, _options) &&
            const DeepCollectionEquality()
                .equals(other._tagLocalIds, _tagLocalIds));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      title,
      context,
      confidenceBefore,
      scheduledReviewDate,
      const DeepCollectionEquality().hash(_options),
      const DeepCollectionEquality().hash(_tagLocalIds));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DecisionDraftImplCopyWith<_$DecisionDraftImpl> get copyWith =>
      __$$DecisionDraftImplCopyWithImpl<_$DecisionDraftImpl>(this, _$identity);
}

abstract class _DecisionDraft implements DecisionDraft {
  const factory _DecisionDraft(
      {required final String title,
      final String? context,
      final int? confidenceBefore,
      final DateTime? scheduledReviewDate,
      final List<OptionDraft> options,
      final List<int> tagLocalIds}) = _$DecisionDraftImpl;

  @override
  String get title;
  @override
  String? get context;
  @override
  int? get confidenceBefore;
  @override
  DateTime? get scheduledReviewDate;
  @override
  List<OptionDraft> get options;
  @override
  List<int> get tagLocalIds;
  @override
  @JsonKey(ignore: true)
  _$$DecisionDraftImplCopyWith<_$DecisionDraftImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$OptionDraft {
  String? get key =>
      throw _privateConstructorUsedError; // Set when editing an existing option, so it keeps its id
  String get title => throw _privateConstructorUsedError;
  List<String> get pros => throw _privateConstructorUsedError;
  List<String> get cons => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $OptionDraftCopyWith<OptionDraft> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OptionDraftCopyWith<$Res> {
  factory $OptionDraftCopyWith(
          OptionDraft value, $Res Function(OptionDraft) then) =
      _$OptionDraftCopyWithImpl<$Res, OptionDraft>;
  @useResult
  $Res call({String? key, String title, List<String> pros, List<String> cons});
}

/// @nodoc
class _$OptionDraftCopyWithImpl<$Res, $Val extends OptionDraft>
    implements $OptionDraftCopyWith<$Res> {
  _$OptionDraftCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = freezed,
    Object? title = null,
    Object? pros = null,
    Object? cons = null,
  }) {
    return _then(_value.copyWith(
      key: freezed == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      pros: null == pros
          ? _value.pros
          : pros // ignore: cast_nullable_to_non_nullable
              as List<String>,
      cons: null == cons
          ? _value.cons
          : cons // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OptionDraftImplCopyWith<$Res>
    implements $OptionDraftCopyWith<$Res> {
  factory _$$OptionDraftImplCopyWith(
          _$OptionDraftImpl value, $Res Function(_$OptionDraftImpl) then) =
      __$$OptionDraftImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? key, String title, List<String> pros, List<String> cons});
}

/// @nodoc
class __$$OptionDraftImplCopyWithImpl<$Res>
    extends _$OptionDraftCopyWithImpl<$Res, _$OptionDraftImpl>
    implements _$$OptionDraftImplCopyWith<$Res> {
  __$$OptionDraftImplCopyWithImpl(
      _$OptionDraftImpl _value, $Res Function(_$OptionDraftImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = freezed,
    Object? title = null,
    Object? pros = null,
    Object? cons = null,
  }) {
    return _then(_$OptionDraftImpl(
      key: freezed == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      pros: null == pros
          ? _value._pros
          : pros // ignore: cast_nullable_to_non_nullable
              as List<String>,
      cons: null == cons
          ? _value._cons
          : cons // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc

class _$OptionDraftImpl implements _OptionDraft {
  const _$OptionDraftImpl(
      {this.key,
      required this.title,
      final List<String> pros = const <String>[],
      final List<String> cons = const <String>[]})
      : _pros = pros,
        _cons = cons;

  @override
  final String? key;
// Set when editing an existing option, so it keeps its id
  @override
  final String title;
  final List<String> _pros;
  @override
  @JsonKey()
  List<String> get pros {
    if (_pros is EqualUnmodifiableListView) return _pros;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pros);
  }

  final List<String> _cons;
  @override
  @JsonKey()
  List<String> get cons {
    if (_cons is EqualUnmodifiableListView) return _cons;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cons);
  }

  @override
  String toString() {
    return 'OptionDraft(key: $key, title: $title, pros: $pros, cons: $cons)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OptionDraftImpl &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.title, title) || other.title == title) &&
            const DeepCollectionEquality().equals(other._pros, _pros) &&
            const DeepCollectionEquality().equals(other._cons, _cons));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      key,
      title,
      const DeepCollectionEquality().hash(_pros),
      const DeepCollectionEquality().hash(_cons));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OptionDraftImplCopyWith<_$OptionDraftImpl> get copyWith =>
      __$$OptionDraftImplCopyWithImpl<_$OptionDraftImpl>(this, _$identity);
}

abstract class _OptionDraft implements OptionDraft {
  const factory _OptionDraft(
      {final String? key,
      required final String title,
      final List<String> pros,
      final List<String> cons}) = _$OptionDraftImpl;

  @override
  String? get key;
  @override // Set when editing an existing option, so it keeps its id
  String get title;
  @override
  List<String> get pros;
  @override
  List<String> get cons;
  @override
  @JsonKey(ignore: true)
  _$$OptionDraftImplCopyWith<_$OptionDraftImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
