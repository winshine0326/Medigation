// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hospital.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Hospital _$HospitalFromJson(Map<String, dynamic> json) {
  return _Hospital.fromJson(json);
}

/// @nodoc
mixin _$Hospital {
  String get id =>
      throw _privateConstructorUsedError; // 병원 ID (Firestore document ID 또는 공공데이터 API ID)
  String get name => throw _privateConstructorUsedError; // 병원 이름
  String get address => throw _privateConstructorUsedError; // 주소
  double get latitude => throw _privateConstructorUsedError; // 위도
  double get longitude => throw _privateConstructorUsedError; // 경도
  List<HospitalEvaluation> get evaluations =>
      throw _privateConstructorUsedError; // 병원 평가 목록
  List<NonCoveredPrice> get nonCoveredPrices =>
      throw _privateConstructorUsedError; // 비급여 가격 목록
  ReviewStatistics? get reviewStatistics =>
      throw _privateConstructorUsedError; // 리뷰 통계 (nullable - 리뷰가 없을 수 있음)
  List<SpecialistInfo> get specialistInfoList =>
      throw _privateConstructorUsedError; // 전문의 정보 목록
  List<NursingGradeInfo> get nursingGradeInfoList =>
      throw _privateConstructorUsedError; // 간호 등급 정보 목록
  List<SpecialDiagnosisInfo> get specialDiagnosisInfoList =>
      throw _privateConstructorUsedError;

  /// Serializes this Hospital to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Hospital
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HospitalCopyWith<Hospital> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HospitalCopyWith<$Res> {
  factory $HospitalCopyWith(Hospital value, $Res Function(Hospital) then) =
      _$HospitalCopyWithImpl<$Res, Hospital>;
  @useResult
  $Res call({
    String id,
    String name,
    String address,
    double latitude,
    double longitude,
    List<HospitalEvaluation> evaluations,
    List<NonCoveredPrice> nonCoveredPrices,
    ReviewStatistics? reviewStatistics,
    List<SpecialistInfo> specialistInfoList,
    List<NursingGradeInfo> nursingGradeInfoList,
    List<SpecialDiagnosisInfo> specialDiagnosisInfoList,
  });

  $ReviewStatisticsCopyWith<$Res>? get reviewStatistics;
}

/// @nodoc
class _$HospitalCopyWithImpl<$Res, $Val extends Hospital>
    implements $HospitalCopyWith<$Res> {
  _$HospitalCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Hospital
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? address = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? evaluations = null,
    Object? nonCoveredPrices = null,
    Object? reviewStatistics = freezed,
    Object? specialistInfoList = null,
    Object? nursingGradeInfoList = null,
    Object? specialDiagnosisInfoList = null,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            name:
                null == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String,
            address:
                null == address
                    ? _value.address
                    : address // ignore: cast_nullable_to_non_nullable
                        as String,
            latitude:
                null == latitude
                    ? _value.latitude
                    : latitude // ignore: cast_nullable_to_non_nullable
                        as double,
            longitude:
                null == longitude
                    ? _value.longitude
                    : longitude // ignore: cast_nullable_to_non_nullable
                        as double,
            evaluations:
                null == evaluations
                    ? _value.evaluations
                    : evaluations // ignore: cast_nullable_to_non_nullable
                        as List<HospitalEvaluation>,
            nonCoveredPrices:
                null == nonCoveredPrices
                    ? _value.nonCoveredPrices
                    : nonCoveredPrices // ignore: cast_nullable_to_non_nullable
                        as List<NonCoveredPrice>,
            reviewStatistics:
                freezed == reviewStatistics
                    ? _value.reviewStatistics
                    : reviewStatistics // ignore: cast_nullable_to_non_nullable
                        as ReviewStatistics?,
            specialistInfoList:
                null == specialistInfoList
                    ? _value.specialistInfoList
                    : specialistInfoList // ignore: cast_nullable_to_non_nullable
                        as List<SpecialistInfo>,
            nursingGradeInfoList:
                null == nursingGradeInfoList
                    ? _value.nursingGradeInfoList
                    : nursingGradeInfoList // ignore: cast_nullable_to_non_nullable
                        as List<NursingGradeInfo>,
            specialDiagnosisInfoList:
                null == specialDiagnosisInfoList
                    ? _value.specialDiagnosisInfoList
                    : specialDiagnosisInfoList // ignore: cast_nullable_to_non_nullable
                        as List<SpecialDiagnosisInfo>,
          )
          as $Val,
    );
  }

  /// Create a copy of Hospital
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ReviewStatisticsCopyWith<$Res>? get reviewStatistics {
    if (_value.reviewStatistics == null) {
      return null;
    }

    return $ReviewStatisticsCopyWith<$Res>(_value.reviewStatistics!, (value) {
      return _then(_value.copyWith(reviewStatistics: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$HospitalImplCopyWith<$Res>
    implements $HospitalCopyWith<$Res> {
  factory _$$HospitalImplCopyWith(
    _$HospitalImpl value,
    $Res Function(_$HospitalImpl) then,
  ) = __$$HospitalImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String address,
    double latitude,
    double longitude,
    List<HospitalEvaluation> evaluations,
    List<NonCoveredPrice> nonCoveredPrices,
    ReviewStatistics? reviewStatistics,
    List<SpecialistInfo> specialistInfoList,
    List<NursingGradeInfo> nursingGradeInfoList,
    List<SpecialDiagnosisInfo> specialDiagnosisInfoList,
  });

  @override
  $ReviewStatisticsCopyWith<$Res>? get reviewStatistics;
}

/// @nodoc
class __$$HospitalImplCopyWithImpl<$Res>
    extends _$HospitalCopyWithImpl<$Res, _$HospitalImpl>
    implements _$$HospitalImplCopyWith<$Res> {
  __$$HospitalImplCopyWithImpl(
    _$HospitalImpl _value,
    $Res Function(_$HospitalImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Hospital
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? address = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? evaluations = null,
    Object? nonCoveredPrices = null,
    Object? reviewStatistics = freezed,
    Object? specialistInfoList = null,
    Object? nursingGradeInfoList = null,
    Object? specialDiagnosisInfoList = null,
  }) {
    return _then(
      _$HospitalImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        name:
            null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String,
        address:
            null == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                    as String,
        latitude:
            null == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                    as double,
        longitude:
            null == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                    as double,
        evaluations:
            null == evaluations
                ? _value._evaluations
                : evaluations // ignore: cast_nullable_to_non_nullable
                    as List<HospitalEvaluation>,
        nonCoveredPrices:
            null == nonCoveredPrices
                ? _value._nonCoveredPrices
                : nonCoveredPrices // ignore: cast_nullable_to_non_nullable
                    as List<NonCoveredPrice>,
        reviewStatistics:
            freezed == reviewStatistics
                ? _value.reviewStatistics
                : reviewStatistics // ignore: cast_nullable_to_non_nullable
                    as ReviewStatistics?,
        specialistInfoList:
            null == specialistInfoList
                ? _value._specialistInfoList
                : specialistInfoList // ignore: cast_nullable_to_non_nullable
                    as List<SpecialistInfo>,
        nursingGradeInfoList:
            null == nursingGradeInfoList
                ? _value._nursingGradeInfoList
                : nursingGradeInfoList // ignore: cast_nullable_to_non_nullable
                    as List<NursingGradeInfo>,
        specialDiagnosisInfoList:
            null == specialDiagnosisInfoList
                ? _value._specialDiagnosisInfoList
                : specialDiagnosisInfoList // ignore: cast_nullable_to_non_nullable
                    as List<SpecialDiagnosisInfo>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$HospitalImpl implements _Hospital {
  const _$HospitalImpl({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    final List<HospitalEvaluation> evaluations = const [],
    final List<NonCoveredPrice> nonCoveredPrices = const [],
    this.reviewStatistics,
    final List<SpecialistInfo> specialistInfoList = const [],
    final List<NursingGradeInfo> nursingGradeInfoList = const [],
    final List<SpecialDiagnosisInfo> specialDiagnosisInfoList = const [],
  }) : _evaluations = evaluations,
       _nonCoveredPrices = nonCoveredPrices,
       _specialistInfoList = specialistInfoList,
       _nursingGradeInfoList = nursingGradeInfoList,
       _specialDiagnosisInfoList = specialDiagnosisInfoList;

  factory _$HospitalImpl.fromJson(Map<String, dynamic> json) =>
      _$$HospitalImplFromJson(json);

  @override
  final String id;
  // 병원 ID (Firestore document ID 또는 공공데이터 API ID)
  @override
  final String name;
  // 병원 이름
  @override
  final String address;
  // 주소
  @override
  final double latitude;
  // 위도
  @override
  final double longitude;
  // 경도
  final List<HospitalEvaluation> _evaluations;
  // 경도
  @override
  @JsonKey()
  List<HospitalEvaluation> get evaluations {
    if (_evaluations is EqualUnmodifiableListView) return _evaluations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_evaluations);
  }

  // 병원 평가 목록
  final List<NonCoveredPrice> _nonCoveredPrices;
  // 병원 평가 목록
  @override
  @JsonKey()
  List<NonCoveredPrice> get nonCoveredPrices {
    if (_nonCoveredPrices is EqualUnmodifiableListView)
      return _nonCoveredPrices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_nonCoveredPrices);
  }

  // 비급여 가격 목록
  @override
  final ReviewStatistics? reviewStatistics;
  // 리뷰 통계 (nullable - 리뷰가 없을 수 있음)
  final List<SpecialistInfo> _specialistInfoList;
  // 리뷰 통계 (nullable - 리뷰가 없을 수 있음)
  @override
  @JsonKey()
  List<SpecialistInfo> get specialistInfoList {
    if (_specialistInfoList is EqualUnmodifiableListView)
      return _specialistInfoList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_specialistInfoList);
  }

  // 전문의 정보 목록
  final List<NursingGradeInfo> _nursingGradeInfoList;
  // 전문의 정보 목록
  @override
  @JsonKey()
  List<NursingGradeInfo> get nursingGradeInfoList {
    if (_nursingGradeInfoList is EqualUnmodifiableListView)
      return _nursingGradeInfoList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_nursingGradeInfoList);
  }

  // 간호 등급 정보 목록
  final List<SpecialDiagnosisInfo> _specialDiagnosisInfoList;
  // 간호 등급 정보 목록
  @override
  @JsonKey()
  List<SpecialDiagnosisInfo> get specialDiagnosisInfoList {
    if (_specialDiagnosisInfoList is EqualUnmodifiableListView)
      return _specialDiagnosisInfoList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_specialDiagnosisInfoList);
  }

  @override
  String toString() {
    return 'Hospital(id: $id, name: $name, address: $address, latitude: $latitude, longitude: $longitude, evaluations: $evaluations, nonCoveredPrices: $nonCoveredPrices, reviewStatistics: $reviewStatistics, specialistInfoList: $specialistInfoList, nursingGradeInfoList: $nursingGradeInfoList, specialDiagnosisInfoList: $specialDiagnosisInfoList)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HospitalImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            const DeepCollectionEquality().equals(
              other._evaluations,
              _evaluations,
            ) &&
            const DeepCollectionEquality().equals(
              other._nonCoveredPrices,
              _nonCoveredPrices,
            ) &&
            (identical(other.reviewStatistics, reviewStatistics) ||
                other.reviewStatistics == reviewStatistics) &&
            const DeepCollectionEquality().equals(
              other._specialistInfoList,
              _specialistInfoList,
            ) &&
            const DeepCollectionEquality().equals(
              other._nursingGradeInfoList,
              _nursingGradeInfoList,
            ) &&
            const DeepCollectionEquality().equals(
              other._specialDiagnosisInfoList,
              _specialDiagnosisInfoList,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    address,
    latitude,
    longitude,
    const DeepCollectionEquality().hash(_evaluations),
    const DeepCollectionEquality().hash(_nonCoveredPrices),
    reviewStatistics,
    const DeepCollectionEquality().hash(_specialistInfoList),
    const DeepCollectionEquality().hash(_nursingGradeInfoList),
    const DeepCollectionEquality().hash(_specialDiagnosisInfoList),
  );

  /// Create a copy of Hospital
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HospitalImplCopyWith<_$HospitalImpl> get copyWith =>
      __$$HospitalImplCopyWithImpl<_$HospitalImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HospitalImplToJson(this);
  }
}

abstract class _Hospital implements Hospital {
  const factory _Hospital({
    required final String id,
    required final String name,
    required final String address,
    required final double latitude,
    required final double longitude,
    final List<HospitalEvaluation> evaluations,
    final List<NonCoveredPrice> nonCoveredPrices,
    final ReviewStatistics? reviewStatistics,
    final List<SpecialistInfo> specialistInfoList,
    final List<NursingGradeInfo> nursingGradeInfoList,
    final List<SpecialDiagnosisInfo> specialDiagnosisInfoList,
  }) = _$HospitalImpl;

  factory _Hospital.fromJson(Map<String, dynamic> json) =
      _$HospitalImpl.fromJson;

  @override
  String get id; // 병원 ID (Firestore document ID 또는 공공데이터 API ID)
  @override
  String get name; // 병원 이름
  @override
  String get address; // 주소
  @override
  double get latitude; // 위도
  @override
  double get longitude; // 경도
  @override
  List<HospitalEvaluation> get evaluations; // 병원 평가 목록
  @override
  List<NonCoveredPrice> get nonCoveredPrices; // 비급여 가격 목록
  @override
  ReviewStatistics? get reviewStatistics; // 리뷰 통계 (nullable - 리뷰가 없을 수 있음)
  @override
  List<SpecialistInfo> get specialistInfoList; // 전문의 정보 목록
  @override
  List<NursingGradeInfo> get nursingGradeInfoList; // 간호 등급 정보 목록
  @override
  List<SpecialDiagnosisInfo> get specialDiagnosisInfoList;

  /// Create a copy of Hospital
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HospitalImplCopyWith<_$HospitalImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
