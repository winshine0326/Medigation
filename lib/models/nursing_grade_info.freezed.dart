// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'nursing_grade_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

NursingGradeInfo _$NursingGradeInfoFromJson(Map<String, dynamic> json) {
  return _NursingGradeInfo.fromJson(json);
}

/// @nodoc
mixin _$NursingGradeInfo {
  String get typeCode => throw _privateConstructorUsedError; // 유형코드 (tyCd)
  String get typeName => throw _privateConstructorUsedError; // 유형명 (tyCdNm)
  String get careGrade => throw _privateConstructorUsedError;

  /// Serializes this NursingGradeInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NursingGradeInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NursingGradeInfoCopyWith<NursingGradeInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NursingGradeInfoCopyWith<$Res> {
  factory $NursingGradeInfoCopyWith(
    NursingGradeInfo value,
    $Res Function(NursingGradeInfo) then,
  ) = _$NursingGradeInfoCopyWithImpl<$Res, NursingGradeInfo>;
  @useResult
  $Res call({String typeCode, String typeName, String careGrade});
}

/// @nodoc
class _$NursingGradeInfoCopyWithImpl<$Res, $Val extends NursingGradeInfo>
    implements $NursingGradeInfoCopyWith<$Res> {
  _$NursingGradeInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NursingGradeInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? typeCode = null,
    Object? typeName = null,
    Object? careGrade = null,
  }) {
    return _then(
      _value.copyWith(
            typeCode:
                null == typeCode
                    ? _value.typeCode
                    : typeCode // ignore: cast_nullable_to_non_nullable
                        as String,
            typeName:
                null == typeName
                    ? _value.typeName
                    : typeName // ignore: cast_nullable_to_non_nullable
                        as String,
            careGrade:
                null == careGrade
                    ? _value.careGrade
                    : careGrade // ignore: cast_nullable_to_non_nullable
                        as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$NursingGradeInfoImplCopyWith<$Res>
    implements $NursingGradeInfoCopyWith<$Res> {
  factory _$$NursingGradeInfoImplCopyWith(
    _$NursingGradeInfoImpl value,
    $Res Function(_$NursingGradeInfoImpl) then,
  ) = __$$NursingGradeInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String typeCode, String typeName, String careGrade});
}

/// @nodoc
class __$$NursingGradeInfoImplCopyWithImpl<$Res>
    extends _$NursingGradeInfoCopyWithImpl<$Res, _$NursingGradeInfoImpl>
    implements _$$NursingGradeInfoImplCopyWith<$Res> {
  __$$NursingGradeInfoImplCopyWithImpl(
    _$NursingGradeInfoImpl _value,
    $Res Function(_$NursingGradeInfoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NursingGradeInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? typeCode = null,
    Object? typeName = null,
    Object? careGrade = null,
  }) {
    return _then(
      _$NursingGradeInfoImpl(
        typeCode:
            null == typeCode
                ? _value.typeCode
                : typeCode // ignore: cast_nullable_to_non_nullable
                    as String,
        typeName:
            null == typeName
                ? _value.typeName
                : typeName // ignore: cast_nullable_to_non_nullable
                    as String,
        careGrade:
            null == careGrade
                ? _value.careGrade
                : careGrade // ignore: cast_nullable_to_non_nullable
                    as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$NursingGradeInfoImpl implements _NursingGradeInfo {
  const _$NursingGradeInfoImpl({
    required this.typeCode,
    required this.typeName,
    required this.careGrade,
  });

  factory _$NursingGradeInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$NursingGradeInfoImplFromJson(json);

  @override
  final String typeCode;
  // 유형코드 (tyCd)
  @override
  final String typeName;
  // 유형명 (tyCdNm)
  @override
  final String careGrade;

  @override
  String toString() {
    return 'NursingGradeInfo(typeCode: $typeCode, typeName: $typeName, careGrade: $careGrade)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NursingGradeInfoImpl &&
            (identical(other.typeCode, typeCode) ||
                other.typeCode == typeCode) &&
            (identical(other.typeName, typeName) ||
                other.typeName == typeName) &&
            (identical(other.careGrade, careGrade) ||
                other.careGrade == careGrade));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, typeCode, typeName, careGrade);

  /// Create a copy of NursingGradeInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NursingGradeInfoImplCopyWith<_$NursingGradeInfoImpl> get copyWith =>
      __$$NursingGradeInfoImplCopyWithImpl<_$NursingGradeInfoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$NursingGradeInfoImplToJson(this);
  }
}

abstract class _NursingGradeInfo implements NursingGradeInfo {
  const factory _NursingGradeInfo({
    required final String typeCode,
    required final String typeName,
    required final String careGrade,
  }) = _$NursingGradeInfoImpl;

  factory _NursingGradeInfo.fromJson(Map<String, dynamic> json) =
      _$NursingGradeInfoImpl.fromJson;

  @override
  String get typeCode; // 유형코드 (tyCd)
  @override
  String get typeName; // 유형명 (tyCdNm)
  @override
  String get careGrade;

  /// Create a copy of NursingGradeInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NursingGradeInfoImplCopyWith<_$NursingGradeInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
