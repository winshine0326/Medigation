// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hospital_evaluation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

HospitalEvaluation _$HospitalEvaluationFromJson(Map<String, dynamic> json) {
  return _HospitalEvaluation.fromJson(json);
}

/// @nodoc
mixin _$HospitalEvaluation {
  String get evaluationItem =>
      throw _privateConstructorUsedError; // 평가 항목 (예: "급성기 뇌졸중 적정성 평가")
  String get grade =>
      throw _privateConstructorUsedError; // 평가 등급 (예: "1등급", "2등급")
  List<String> get badges => throw _privateConstructorUsedError;

  /// Serializes this HospitalEvaluation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HospitalEvaluation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HospitalEvaluationCopyWith<HospitalEvaluation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HospitalEvaluationCopyWith<$Res> {
  factory $HospitalEvaluationCopyWith(
    HospitalEvaluation value,
    $Res Function(HospitalEvaluation) then,
  ) = _$HospitalEvaluationCopyWithImpl<$Res, HospitalEvaluation>;
  @useResult
  $Res call({String evaluationItem, String grade, List<String> badges});
}

/// @nodoc
class _$HospitalEvaluationCopyWithImpl<$Res, $Val extends HospitalEvaluation>
    implements $HospitalEvaluationCopyWith<$Res> {
  _$HospitalEvaluationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HospitalEvaluation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? evaluationItem = null,
    Object? grade = null,
    Object? badges = null,
  }) {
    return _then(
      _value.copyWith(
            evaluationItem:
                null == evaluationItem
                    ? _value.evaluationItem
                    : evaluationItem // ignore: cast_nullable_to_non_nullable
                        as String,
            grade:
                null == grade
                    ? _value.grade
                    : grade // ignore: cast_nullable_to_non_nullable
                        as String,
            badges:
                null == badges
                    ? _value.badges
                    : badges // ignore: cast_nullable_to_non_nullable
                        as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$HospitalEvaluationImplCopyWith<$Res>
    implements $HospitalEvaluationCopyWith<$Res> {
  factory _$$HospitalEvaluationImplCopyWith(
    _$HospitalEvaluationImpl value,
    $Res Function(_$HospitalEvaluationImpl) then,
  ) = __$$HospitalEvaluationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String evaluationItem, String grade, List<String> badges});
}

/// @nodoc
class __$$HospitalEvaluationImplCopyWithImpl<$Res>
    extends _$HospitalEvaluationCopyWithImpl<$Res, _$HospitalEvaluationImpl>
    implements _$$HospitalEvaluationImplCopyWith<$Res> {
  __$$HospitalEvaluationImplCopyWithImpl(
    _$HospitalEvaluationImpl _value,
    $Res Function(_$HospitalEvaluationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HospitalEvaluation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? evaluationItem = null,
    Object? grade = null,
    Object? badges = null,
  }) {
    return _then(
      _$HospitalEvaluationImpl(
        evaluationItem:
            null == evaluationItem
                ? _value.evaluationItem
                : evaluationItem // ignore: cast_nullable_to_non_nullable
                    as String,
        grade:
            null == grade
                ? _value.grade
                : grade // ignore: cast_nullable_to_non_nullable
                    as String,
        badges:
            null == badges
                ? _value._badges
                : badges // ignore: cast_nullable_to_non_nullable
                    as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$HospitalEvaluationImpl implements _HospitalEvaluation {
  const _$HospitalEvaluationImpl({
    required this.evaluationItem,
    required this.grade,
    required final List<String> badges,
  }) : _badges = badges;

  factory _$HospitalEvaluationImpl.fromJson(Map<String, dynamic> json) =>
      _$$HospitalEvaluationImplFromJson(json);

  @override
  final String evaluationItem;
  // 평가 항목 (예: "급성기 뇌졸중 적정성 평가")
  @override
  final String grade;
  // 평가 등급 (예: "1등급", "2등급")
  final List<String> _badges;
  // 평가 등급 (예: "1등급", "2등급")
  @override
  List<String> get badges {
    if (_badges is EqualUnmodifiableListView) return _badges;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_badges);
  }

  @override
  String toString() {
    return 'HospitalEvaluation(evaluationItem: $evaluationItem, grade: $grade, badges: $badges)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HospitalEvaluationImpl &&
            (identical(other.evaluationItem, evaluationItem) ||
                other.evaluationItem == evaluationItem) &&
            (identical(other.grade, grade) || other.grade == grade) &&
            const DeepCollectionEquality().equals(other._badges, _badges));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    evaluationItem,
    grade,
    const DeepCollectionEquality().hash(_badges),
  );

  /// Create a copy of HospitalEvaluation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HospitalEvaluationImplCopyWith<_$HospitalEvaluationImpl> get copyWith =>
      __$$HospitalEvaluationImplCopyWithImpl<_$HospitalEvaluationImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$HospitalEvaluationImplToJson(this);
  }
}

abstract class _HospitalEvaluation implements HospitalEvaluation {
  const factory _HospitalEvaluation({
    required final String evaluationItem,
    required final String grade,
    required final List<String> badges,
  }) = _$HospitalEvaluationImpl;

  factory _HospitalEvaluation.fromJson(Map<String, dynamic> json) =
      _$HospitalEvaluationImpl.fromJson;

  @override
  String get evaluationItem; // 평가 항목 (예: "급성기 뇌졸중 적정성 평가")
  @override
  String get grade; // 평가 등급 (예: "1등급", "2등급")
  @override
  List<String> get badges;

  /// Create a copy of HospitalEvaluation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HospitalEvaluationImplCopyWith<_$HospitalEvaluationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
