import 'package:flutter/material.dart';
import '../models/hospital.dart';
import '../utils/hospital_warning_checker.dart';
import '../utils/hospital_score_calculator.dart';
import 'badge_chip.dart';
import 'rating_display.dart';

/// 병원 카드 위젯
/// 병원 목록에서 각 병원 정보를 표시하는 카드
class HospitalCard extends StatelessWidget {
  final Hospital hospital;
  final VoidCallback? onTap;
  final double? distance; // km 단위 거리
  final bool isBookmarked;
  final VoidCallback? onBookmarkTap;

  const HospitalCard({
    super.key,
    required this.hospital,
    this.onTap,
    this.distance,
    this.isBookmarked = false,
    this.onBookmarkTap,
  });

  @override
  Widget build(BuildContext context) {
    // 배지 목록 추출 (최대 3개만 표시)
    final badges = <String>[];
    for (final evaluation in hospital.evaluations) {
      badges.addAll(evaluation.badges);
      if (badges.length >= 3) break;
    }
    final displayBadges = badges.take(3).toList();

    // 경고 및 점수 계산
    final hasWarnings = HospitalWarningChecker.hasWarnings(hospital);
    final hasSevereWarnings = HospitalWarningChecker.hasSevereWarnings(hospital);
    final totalScore = HospitalScoreCalculator.calculateTotalScore(hospital);
    final scoreGrade = HospitalScoreCalculator.getScoreGrade(totalScore);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: hasSevereWarnings
            ? BorderSide(color: Colors.red[300]!, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 경고 배너 (심각한 경고가 있을 경우)
              if (hasSevereWarnings) ...[
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        size: 16,
                        color: Colors.red[700],
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          HospitalWarningChecker.getMostSevereWarning(hospital)
                                  ?.message ??
                              '주의가 필요합니다',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.red[700],
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],

              // 헤더: 병원 이름 + 종합 점수 + 북마크 버튼
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hospital.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        // 종합 점수 및 등급
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Color(int.parse(
                                    '0xFF${HospitalScoreCalculator.getScoreColor(totalScore).substring(1)}')),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '등급 $scoreGrade',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${totalScore.toStringAsFixed(1)}점',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            // 경고 아이콘 (경고가 있을 경우)
                            if (hasWarnings) ...[
                              const SizedBox(width: 8),
                              Icon(
                                Icons.error_outline,
                                size: 14,
                                color: hasSevereWarnings
                                    ? Colors.red[700]
                                    : Colors.orange[700],
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                      color: isBookmarked ? Colors.blue : Colors.grey,
                    ),
                    onPressed: onBookmarkTap,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // 주소 + 거리
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      hospital.address,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (distance != null) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${distance!.toStringAsFixed(1)}km',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue[700],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 12),

              // 배지 목록
              if (displayBadges.isNotEmpty) ...[
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: displayBadges
                      .map((badge) => SimpleBadgeChip(label: badge))
                      .toList(),
                ),
                const SizedBox(height: 12),
              ],

              // 평점 및 리뷰 개수
              if (hospital.reviewStatistics != null)
                Row(
                  children: [
                    RatingDisplay(
                      rating: hospital.reviewStatistics!.averageRating,
                      reviewCount: hospital.reviewStatistics!.totalReviewCount,
                    ),
                    const Spacer(),
                    // 평가 항목 개수
                    if (hospital.evaluations.isNotEmpty)
                      Text(
                        '평가 ${hospital.evaluations.length}개',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 간단한 병원 카드 (지도 마커 등에서 사용)
class CompactHospitalCard extends StatelessWidget {
  final Hospital hospital;
  final VoidCallback? onTap;

  const CompactHospitalCard({
    super.key,
    required this.hospital,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                hospital.name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              if (hospital.reviewStatistics != null)
                RatingDisplay(
                  rating: hospital.reviewStatistics!.averageRating,
                  reviewCount: hospital.reviewStatistics!.totalReviewCount,
                  starSize: 14,
                  ratingTextStyle: const TextStyle(fontSize: 12),
                  reviewCountTextStyle: const TextStyle(fontSize: 10),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
