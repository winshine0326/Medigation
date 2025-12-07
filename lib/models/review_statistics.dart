import 'package:freezed_annotation/freezed_annotation.dart';

part 'review_statistics.freezed.dart';
part 'review_statistics.g.dart';

/// 리뷰 통계 모델
/// 평균 별점, 총 리뷰 개수, 주요 리뷰 키워드 목록을 포함
@freezed
class ReviewStatistics with _$ReviewStatistics {
  const factory ReviewStatistics({
    required double averageRating, // 평균 별점 (0.0 ~ 5.0)
    required int totalReviewCount, // 총 리뷰 개수
    required List<String> keywords, // 주요 리뷰 키워드 목록 (예: ["친절", "깨끗", "대기시간 긴"])
  }) = _ReviewStatistics;

  factory ReviewStatistics.fromJson(Map<String, dynamic> json) =>
      _$ReviewStatisticsFromJson(json);
}
