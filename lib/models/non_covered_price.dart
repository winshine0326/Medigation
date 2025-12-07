import 'package:freezed_annotation/freezed_annotation.dart';

part 'non_covered_price.freezed.dart';
part 'non_covered_price.g.dart';

/// 비급여 가격 모델
/// 비급여 항목과 가격 정보를 포함
@freezed
class NonCoveredPrice with _$NonCoveredPrice {
  const factory NonCoveredPrice({
    required String item, // 비급여 항목 (예: "MRI 검사")
    required int price, // 가격 (원)
  }) = _NonCoveredPrice;

  factory NonCoveredPrice.fromJson(Map<String, dynamic> json) =>
      _$NonCoveredPriceFromJson(json);
}
