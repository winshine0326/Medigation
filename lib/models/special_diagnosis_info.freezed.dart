// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'special_diagnosis_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SpecialDiagnosisInfo _$SpecialDiagnosisInfoFromJson(Map<String, dynamic> json) {
  return _SpecialDiagnosisInfo.fromJson(json);
}

/// @nodoc
mixin _$SpecialDiagnosisInfo {
  String get searchCode => throw _privateConstructorUsedError; // 검색코드 (srchCd)
  String get searchCodeName => throw _privateConstructorUsedError;

  /// Serializes this SpecialDiagnosisInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SpecialDiagnosisInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SpecialDiagnosisInfoCopyWith<SpecialDiagnosisInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpecialDiagnosisInfoCopyWith<$Res> {
  factory $SpecialDiagnosisInfoCopyWith(
    SpecialDiagnosisInfo value,
    $Res Function(SpecialDiagnosisInfo) then,
  ) = _$SpecialDiagnosisInfoCopyWithImpl<$Res, SpecialDiagnosisInfo>;
  @useResult
  $Res call({String searchCode, String searchCodeName});
}

/// @nodoc
class _$SpecialDiagnosisInfoCopyWithImpl<
  $Res,
  $Val extends SpecialDiagnosisInfo
>
    implements $SpecialDiagnosisInfoCopyWith<$Res> {
  _$SpecialDiagnosisInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SpecialDiagnosisInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? searchCode = null, Object? searchCodeName = null}) {
    return _then(
      _value.copyWith(
            searchCode:
                null == searchCode
                    ? _value.searchCode
                    : searchCode // ignore: cast_nullable_to_non_nullable
                        as String,
            searchCodeName:
                null == searchCodeName
                    ? _value.searchCodeName
                    : searchCodeName // ignore: cast_nullable_to_non_nullable
                        as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SpecialDiagnosisInfoImplCopyWith<$Res>
    implements $SpecialDiagnosisInfoCopyWith<$Res> {
  factory _$$SpecialDiagnosisInfoImplCopyWith(
    _$SpecialDiagnosisInfoImpl value,
    $Res Function(_$SpecialDiagnosisInfoImpl) then,
  ) = __$$SpecialDiagnosisInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String searchCode, String searchCodeName});
}

/// @nodoc
class __$$SpecialDiagnosisInfoImplCopyWithImpl<$Res>
    extends _$SpecialDiagnosisInfoCopyWithImpl<$Res, _$SpecialDiagnosisInfoImpl>
    implements _$$SpecialDiagnosisInfoImplCopyWith<$Res> {
  __$$SpecialDiagnosisInfoImplCopyWithImpl(
    _$SpecialDiagnosisInfoImpl _value,
    $Res Function(_$SpecialDiagnosisInfoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SpecialDiagnosisInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? searchCode = null, Object? searchCodeName = null}) {
    return _then(
      _$SpecialDiagnosisInfoImpl(
        searchCode:
            null == searchCode
                ? _value.searchCode
                : searchCode // ignore: cast_nullable_to_non_nullable
                    as String,
        searchCodeName:
            null == searchCodeName
                ? _value.searchCodeName
                : searchCodeName // ignore: cast_nullable_to_non_nullable
                    as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SpecialDiagnosisInfoImpl implements _SpecialDiagnosisInfo {
  const _$SpecialDiagnosisInfoImpl({
    required this.searchCode,
    required this.searchCodeName,
  });

  factory _$SpecialDiagnosisInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$SpecialDiagnosisInfoImplFromJson(json);

  @override
  final String searchCode;
  // 검색코드 (srchCd)
  @override
  final String searchCodeName;

  @override
  String toString() {
    return 'SpecialDiagnosisInfo(searchCode: $searchCode, searchCodeName: $searchCodeName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpecialDiagnosisInfoImpl &&
            (identical(other.searchCode, searchCode) ||
                other.searchCode == searchCode) &&
            (identical(other.searchCodeName, searchCodeName) ||
                other.searchCodeName == searchCodeName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, searchCode, searchCodeName);

  /// Create a copy of SpecialDiagnosisInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpecialDiagnosisInfoImplCopyWith<_$SpecialDiagnosisInfoImpl>
  get copyWith =>
      __$$SpecialDiagnosisInfoImplCopyWithImpl<_$SpecialDiagnosisInfoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SpecialDiagnosisInfoImplToJson(this);
  }
}

abstract class _SpecialDiagnosisInfo implements SpecialDiagnosisInfo {
  const factory _SpecialDiagnosisInfo({
    required final String searchCode,
    required final String searchCodeName,
  }) = _$SpecialDiagnosisInfoImpl;

  factory _SpecialDiagnosisInfo.fromJson(Map<String, dynamic> json) =
      _$SpecialDiagnosisInfoImpl.fromJson;

  @override
  String get searchCode; // 검색코드 (srchCd)
  @override
  String get searchCodeName;

  /// Create a copy of SpecialDiagnosisInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpecialDiagnosisInfoImplCopyWith<_$SpecialDiagnosisInfoImpl>
  get copyWith => throw _privateConstructorUsedError;
}
