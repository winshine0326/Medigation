// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'review_statistics.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ReviewStatistics _$ReviewStatisticsFromJson(Map<String, dynamic> json) {
  return _ReviewStatistics.fromJson(json);
}

/// @nodoc
mixin _$ReviewStatistics {
  double get averageRating =>
      throw _privateConstructorUsedError; // 평균 별점 (0.0 ~ 5.0)
  int get totalReviewCount => throw _privateConstructorUsedError; // 총 리뷰 개수
  List<String> get keywords => throw _privateConstructorUsedError;

  /// Serializes this ReviewStatistics to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReviewStatistics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReviewStatisticsCopyWith<ReviewStatistics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReviewStatisticsCopyWith<$Res> {
  factory $ReviewStatisticsCopyWith(
    ReviewStatistics value,
    $Res Function(ReviewStatistics) then,
  ) = _$ReviewStatisticsCopyWithImpl<$Res, ReviewStatistics>;
  @useResult
  $Res call({
    double averageRating,
    int totalReviewCount,
    List<String> keywords,
  });
}

/// @nodoc
class _$ReviewStatisticsCopyWithImpl<$Res, $Val extends ReviewStatistics>
    implements $ReviewStatisticsCopyWith<$Res> {
  _$ReviewStatisticsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReviewStatistics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? averageRating = null,
    Object? totalReviewCount = null,
    Object? keywords = null,
  }) {
    return _then(
      _value.copyWith(
            averageRating:
                null == averageRating
                    ? _value.averageRating
                    : averageRating // ignore: cast_nullable_to_non_nullable
                        as double,
            totalReviewCount:
                null == totalReviewCount
                    ? _value.totalReviewCount
                    : totalReviewCount // ignore: cast_nullable_to_non_nullable
                        as int,
            keywords:
                null == keywords
                    ? _value.keywords
                    : keywords // ignore: cast_nullable_to_non_nullable
                        as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ReviewStatisticsImplCopyWith<$Res>
    implements $ReviewStatisticsCopyWith<$Res> {
  factory _$$ReviewStatisticsImplCopyWith(
    _$ReviewStatisticsImpl value,
    $Res Function(_$ReviewStatisticsImpl) then,
  ) = __$$ReviewStatisticsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    double averageRating,
    int totalReviewCount,
    List<String> keywords,
  });
}

/// @nodoc
class __$$ReviewStatisticsImplCopyWithImpl<$Res>
    extends _$ReviewStatisticsCopyWithImpl<$Res, _$ReviewStatisticsImpl>
    implements _$$ReviewStatisticsImplCopyWith<$Res> {
  __$$ReviewStatisticsImplCopyWithImpl(
    _$ReviewStatisticsImpl _value,
    $Res Function(_$ReviewStatisticsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReviewStatistics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? averageRating = null,
    Object? totalReviewCount = null,
    Object? keywords = null,
  }) {
    return _then(
      _$ReviewStatisticsImpl(
        averageRating:
            null == averageRating
                ? _value.averageRating
                : averageRating // ignore: cast_nullable_to_non_nullable
                    as double,
        totalReviewCount:
            null == totalReviewCount
                ? _value.totalReviewCount
                : totalReviewCount // ignore: cast_nullable_to_non_nullable
                    as int,
        keywords:
            null == keywords
                ? _value._keywords
                : keywords // ignore: cast_nullable_to_non_nullable
                    as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ReviewStatisticsImpl implements _ReviewStatistics {
  const _$ReviewStatisticsImpl({
    required this.averageRating,
    required this.totalReviewCount,
    required final List<String> keywords,
  }) : _keywords = keywords;

  factory _$ReviewStatisticsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReviewStatisticsImplFromJson(json);

  @override
  final double averageRating;
  // 평균 별점 (0.0 ~ 5.0)
  @override
  final int totalReviewCount;
  // 총 리뷰 개수
  final List<String> _keywords;
  // 총 리뷰 개수
  @override
  List<String> get keywords {
    if (_keywords is EqualUnmodifiableListView) return _keywords;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_keywords);
  }

  @override
  String toString() {
    return 'ReviewStatistics(averageRating: $averageRating, totalReviewCount: $totalReviewCount, keywords: $keywords)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReviewStatisticsImpl &&
            (identical(other.averageRating, averageRating) ||
                other.averageRating == averageRating) &&
            (identical(other.totalReviewCount, totalReviewCount) ||
                other.totalReviewCount == totalReviewCount) &&
            const DeepCollectionEquality().equals(other._keywords, _keywords));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    averageRating,
    totalReviewCount,
    const DeepCollectionEquality().hash(_keywords),
  );

  /// Create a copy of ReviewStatistics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReviewStatisticsImplCopyWith<_$ReviewStatisticsImpl> get copyWith =>
      __$$ReviewStatisticsImplCopyWithImpl<_$ReviewStatisticsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ReviewStatisticsImplToJson(this);
  }
}

abstract class _ReviewStatistics implements ReviewStatistics {
  const factory _ReviewStatistics({
    required final double averageRating,
    required final int totalReviewCount,
    required final List<String> keywords,
  }) = _$ReviewStatisticsImpl;

  factory _ReviewStatistics.fromJson(Map<String, dynamic> json) =
      _$ReviewStatisticsImpl.fromJson;

  @override
  double get averageRating; // 평균 별점 (0.0 ~ 5.0)
  @override
  int get totalReviewCount; // 총 리뷰 개수
  @override
  List<String> get keywords;

  /// Create a copy of ReviewStatistics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReviewStatisticsImplCopyWith<_$ReviewStatisticsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
