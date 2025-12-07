// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_statistics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReviewStatisticsImpl _$$ReviewStatisticsImplFromJson(
  Map<String, dynamic> json,
) => _$ReviewStatisticsImpl(
  averageRating: (json['averageRating'] as num).toDouble(),
  totalReviewCount: (json['totalReviewCount'] as num).toInt(),
  keywords:
      (json['keywords'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$$ReviewStatisticsImplToJson(
  _$ReviewStatisticsImpl instance,
) => <String, dynamic>{
  'averageRating': instance.averageRating,
  'totalReviewCount': instance.totalReviewCount,
  'keywords': instance.keywords,
};
