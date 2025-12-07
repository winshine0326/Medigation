// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'non_covered_price.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

NonCoveredPrice _$NonCoveredPriceFromJson(Map<String, dynamic> json) {
  return _NonCoveredPrice.fromJson(json);
}

/// @nodoc
mixin _$NonCoveredPrice {
  String get item => throw _privateConstructorUsedError; // 비급여 항목 (예: "MRI 검사")
  int get price => throw _privateConstructorUsedError;

  /// Serializes this NonCoveredPrice to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NonCoveredPrice
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NonCoveredPriceCopyWith<NonCoveredPrice> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NonCoveredPriceCopyWith<$Res> {
  factory $NonCoveredPriceCopyWith(
    NonCoveredPrice value,
    $Res Function(NonCoveredPrice) then,
  ) = _$NonCoveredPriceCopyWithImpl<$Res, NonCoveredPrice>;
  @useResult
  $Res call({String item, int price});
}

/// @nodoc
class _$NonCoveredPriceCopyWithImpl<$Res, $Val extends NonCoveredPrice>
    implements $NonCoveredPriceCopyWith<$Res> {
  _$NonCoveredPriceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NonCoveredPrice
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? item = null, Object? price = null}) {
    return _then(
      _value.copyWith(
            item:
                null == item
                    ? _value.item
                    : item // ignore: cast_nullable_to_non_nullable
                        as String,
            price:
                null == price
                    ? _value.price
                    : price // ignore: cast_nullable_to_non_nullable
                        as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$NonCoveredPriceImplCopyWith<$Res>
    implements $NonCoveredPriceCopyWith<$Res> {
  factory _$$NonCoveredPriceImplCopyWith(
    _$NonCoveredPriceImpl value,
    $Res Function(_$NonCoveredPriceImpl) then,
  ) = __$$NonCoveredPriceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String item, int price});
}

/// @nodoc
class __$$NonCoveredPriceImplCopyWithImpl<$Res>
    extends _$NonCoveredPriceCopyWithImpl<$Res, _$NonCoveredPriceImpl>
    implements _$$NonCoveredPriceImplCopyWith<$Res> {
  __$$NonCoveredPriceImplCopyWithImpl(
    _$NonCoveredPriceImpl _value,
    $Res Function(_$NonCoveredPriceImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NonCoveredPrice
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? item = null, Object? price = null}) {
    return _then(
      _$NonCoveredPriceImpl(
        item:
            null == item
                ? _value.item
                : item // ignore: cast_nullable_to_non_nullable
                    as String,
        price:
            null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                    as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$NonCoveredPriceImpl implements _NonCoveredPrice {
  const _$NonCoveredPriceImpl({required this.item, required this.price});

  factory _$NonCoveredPriceImpl.fromJson(Map<String, dynamic> json) =>
      _$$NonCoveredPriceImplFromJson(json);

  @override
  final String item;
  // 비급여 항목 (예: "MRI 검사")
  @override
  final int price;

  @override
  String toString() {
    return 'NonCoveredPrice(item: $item, price: $price)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NonCoveredPriceImpl &&
            (identical(other.item, item) || other.item == item) &&
            (identical(other.price, price) || other.price == price));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, item, price);

  /// Create a copy of NonCoveredPrice
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NonCoveredPriceImplCopyWith<_$NonCoveredPriceImpl> get copyWith =>
      __$$NonCoveredPriceImplCopyWithImpl<_$NonCoveredPriceImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$NonCoveredPriceImplToJson(this);
  }
}

abstract class _NonCoveredPrice implements NonCoveredPrice {
  const factory _NonCoveredPrice({
    required final String item,
    required final int price,
  }) = _$NonCoveredPriceImpl;

  factory _NonCoveredPrice.fromJson(Map<String, dynamic> json) =
      _$NonCoveredPriceImpl.fromJson;

  @override
  String get item; // 비급여 항목 (예: "MRI 검사")
  @override
  int get price;

  /// Create a copy of NonCoveredPrice
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NonCoveredPriceImplCopyWith<_$NonCoveredPriceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
