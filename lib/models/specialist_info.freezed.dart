// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'specialist_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SpecialistInfo _$SpecialistInfoFromJson(Map<String, dynamic> json) {
  return _SpecialistInfo.fromJson(json);
}

/// @nodoc
mixin _$SpecialistInfo {
  String get specialtyCode =>
      throw _privateConstructorUsedError; // 진료과목코드 (dgsbjtCd)
  String get specialtyName =>
      throw _privateConstructorUsedError; // 진료과목명 (dgsbjtCdNm)
  int get specialistCount => throw _privateConstructorUsedError;

  /// Serializes this SpecialistInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SpecialistInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SpecialistInfoCopyWith<SpecialistInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpecialistInfoCopyWith<$Res> {
  factory $SpecialistInfoCopyWith(
    SpecialistInfo value,
    $Res Function(SpecialistInfo) then,
  ) = _$SpecialistInfoCopyWithImpl<$Res, SpecialistInfo>;
  @useResult
  $Res call({String specialtyCode, String specialtyName, int specialistCount});
}

/// @nodoc
class _$SpecialistInfoCopyWithImpl<$Res, $Val extends SpecialistInfo>
    implements $SpecialistInfoCopyWith<$Res> {
  _$SpecialistInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SpecialistInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? specialtyCode = null,
    Object? specialtyName = null,
    Object? specialistCount = null,
  }) {
    return _then(
      _value.copyWith(
            specialtyCode:
                null == specialtyCode
                    ? _value.specialtyCode
                    : specialtyCode // ignore: cast_nullable_to_non_nullable
                        as String,
            specialtyName:
                null == specialtyName
                    ? _value.specialtyName
                    : specialtyName // ignore: cast_nullable_to_non_nullable
                        as String,
            specialistCount:
                null == specialistCount
                    ? _value.specialistCount
                    : specialistCount // ignore: cast_nullable_to_non_nullable
                        as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SpecialistInfoImplCopyWith<$Res>
    implements $SpecialistInfoCopyWith<$Res> {
  factory _$$SpecialistInfoImplCopyWith(
    _$SpecialistInfoImpl value,
    $Res Function(_$SpecialistInfoImpl) then,
  ) = __$$SpecialistInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String specialtyCode, String specialtyName, int specialistCount});
}

/// @nodoc
class __$$SpecialistInfoImplCopyWithImpl<$Res>
    extends _$SpecialistInfoCopyWithImpl<$Res, _$SpecialistInfoImpl>
    implements _$$SpecialistInfoImplCopyWith<$Res> {
  __$$SpecialistInfoImplCopyWithImpl(
    _$SpecialistInfoImpl _value,
    $Res Function(_$SpecialistInfoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SpecialistInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? specialtyCode = null,
    Object? specialtyName = null,
    Object? specialistCount = null,
  }) {
    return _then(
      _$SpecialistInfoImpl(
        specialtyCode:
            null == specialtyCode
                ? _value.specialtyCode
                : specialtyCode // ignore: cast_nullable_to_non_nullable
                    as String,
        specialtyName:
            null == specialtyName
                ? _value.specialtyName
                : specialtyName // ignore: cast_nullable_to_non_nullable
                    as String,
        specialistCount:
            null == specialistCount
                ? _value.specialistCount
                : specialistCount // ignore: cast_nullable_to_non_nullable
                    as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SpecialistInfoImpl implements _SpecialistInfo {
  const _$SpecialistInfoImpl({
    required this.specialtyCode,
    required this.specialtyName,
    required this.specialistCount,
  });

  factory _$SpecialistInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$SpecialistInfoImplFromJson(json);

  @override
  final String specialtyCode;
  // 진료과목코드 (dgsbjtCd)
  @override
  final String specialtyName;
  // 진료과목명 (dgsbjtCdNm)
  @override
  final int specialistCount;

  @override
  String toString() {
    return 'SpecialistInfo(specialtyCode: $specialtyCode, specialtyName: $specialtyName, specialistCount: $specialistCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpecialistInfoImpl &&
            (identical(other.specialtyCode, specialtyCode) ||
                other.specialtyCode == specialtyCode) &&
            (identical(other.specialtyName, specialtyName) ||
                other.specialtyName == specialtyName) &&
            (identical(other.specialistCount, specialistCount) ||
                other.specialistCount == specialistCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, specialtyCode, specialtyName, specialistCount);

  /// Create a copy of SpecialistInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpecialistInfoImplCopyWith<_$SpecialistInfoImpl> get copyWith =>
      __$$SpecialistInfoImplCopyWithImpl<_$SpecialistInfoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SpecialistInfoImplToJson(this);
  }
}

abstract class _SpecialistInfo implements SpecialistInfo {
  const factory _SpecialistInfo({
    required final String specialtyCode,
    required final String specialtyName,
    required final int specialistCount,
  }) = _$SpecialistInfoImpl;

  factory _SpecialistInfo.fromJson(Map<String, dynamic> json) =
      _$SpecialistInfoImpl.fromJson;

  @override
  String get specialtyCode; // 진료과목코드 (dgsbjtCd)
  @override
  String get specialtyName; // 진료과목명 (dgsbjtCdNm)
  @override
  int get specialistCount;

  /// Create a copy of SpecialistInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpecialistInfoImplCopyWith<_$SpecialistInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
