import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/hospital.dart';
import '../providers/bookmark_provider.dart';
import '../providers/location_provider.dart';
import '../widgets/badge_chip.dart';
import '../widgets/rating_display.dart';

/// 병원 상세 화면
/// 병원의 종합 리포트 (평가 + 가격 + 리뷰)를 표시
class HospitalDetailScreen extends ConsumerWidget {
  final Hospital hospital;

  const HospitalDetailScreen({
    super.key,
    required this.hospital,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarkState = ref.watch(bookmarkNotifierProvider);
    final locationState = ref.watch(locationNotifierProvider);
    final isBookmarked = bookmarkState.isBookmarked(hospital.id);

    final distance = locationState.hasLocation
        ? ref
            .read(locationNotifierProvider.notifier)
            .getDistanceToHospital(hospital)
        : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('병원 정보'),
        actions: [
          // 북마크 버튼
          IconButton(
            icon: Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            ),
            onPressed: () {
              ref
                  .read(bookmarkNotifierProvider.notifier)
                  .toggleBookmark(hospital.id);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 병원 기본 정보
            _buildBasicInfo(context, distance),
            const Divider(height: 1),

            // 배지 섹션
            if (hospital.evaluations.isNotEmpty) ...[
              _buildBadgeSection(context),
              const Divider(height: 1),
            ],

            // 리뷰 통계 섹션
            if (hospital.reviewStatistics != null) ...[
              _buildReviewSection(context),
              const Divider(height: 1),
            ],

            // 평가 데이터 섹션
            if (hospital.evaluations.isNotEmpty) ...[
              _buildEvaluationSection(context),
              const Divider(height: 1),
            ],

            // 비급여 가격 섹션
            if (hospital.nonCoveredPrices.isNotEmpty) ...[
              _buildPriceSection(context),
              const Divider(height: 1),
            ],

            // 외부 리뷰 링크 섹션
            _buildExternalLinksSection(context),
          ],
        ),
      ),
    );
  }

  /// 병원 기본 정보
  Widget _buildBasicInfo(BuildContext context, double? distance) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 병원 이름
          Text(
            hospital.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          // 주소
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 20,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  hospital.address,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ],
          ),

          // 거리 정보
          if (distance != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.directions_walk,
                  size: 20,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 8),
                Text(
                  '현재 위치에서 ${distance.toStringAsFixed(1)}km',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  /// 배지 섹션
  Widget _buildBadgeSection(BuildContext context) {
    final badges = <String>[];
    for (final evaluation in hospital.evaluations) {
      badges.addAll(evaluation.badges);
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '전문 분야',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: badges
                .map((badge) => SimpleBadgeChip(label: badge))
                .toList(),
          ),
        ],
      ),
    );
  }

  /// 리뷰 통계 섹션
  Widget _buildReviewSection(BuildContext context) {
    final review = hospital.reviewStatistics!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '리뷰 통계',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          // 평점
          RatingDisplay(
            rating: review.averageRating,
            reviewCount: review.totalReviewCount,
            starSize: 24,
            ratingTextStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          // 주요 키워드
          if (review.keywords.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text(
              '주요 키워드',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: review.keywords
                  .map(
                    (keyword) => Chip(
                      label: Text(keyword),
                      backgroundColor: Colors.grey[100],
                      labelStyle: const TextStyle(fontSize: 12),
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  /// 평가 데이터 섹션
  Widget _buildEvaluationSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '병원 평가 정보',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...hospital.evaluations.map((evaluation) {
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 평가 항목명
                    Text(
                      evaluation.evaluationItem,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // 평가 등급
                    Row(
                      children: [
                        const Text(
                          '등급: ',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getGradeColor(evaluation.grade),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            evaluation.grade,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // 배지
                    if (evaluation.badges.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: evaluation.badges
                            .map((badge) => SimpleBadgeChip(label: badge))
                            .toList(),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  /// 비급여 가격 섹션
  Widget _buildPriceSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '비급여 가격 정보',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                for (var entry in hospital.nonCoveredPrices.asMap().entries) ...[
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    title: Text(
                      entry.value.item,
                      style: const TextStyle(fontSize: 14),
                    ),
                    trailing: Text(
                      '${_formatPrice(entry.value.price)}원',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  if (entry.key != hospital.nonCoveredPrices.length - 1)
                    const Divider(height: 1, indent: 16, endIndent: 16),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 외부 리뷰 링크 섹션
  Widget _buildExternalLinksSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '외부 리뷰 보기',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          // 네이버 지도 버튼
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _openNaverMap(),
              icon: const Icon(Icons.map),
              label: const Text('네이버 지도에서 보기'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // 카카오맵 버튼
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _openKakaoMap(),
              icon: const Icon(Icons.location_on),
              label: const Text('카카오맵에서 보기'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 등급에 따른 색상 반환
  Color _getGradeColor(String grade) {
    if (grade.contains('1등급')) {
      return Colors.green;
    } else if (grade.contains('2등급')) {
      return Colors.lightGreen;
    } else if (grade.contains('3등급')) {
      return Colors.orange;
    } else if (grade.contains('4등급')) {
      return Colors.deepOrange;
    } else if (grade.contains('5등급')) {
      return Colors.red;
    }
    return Colors.grey;
  }

  /// 가격 포맷팅 (천 단위 구분)
  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }

  /// 네이버 지도 열기
  Future<void> _openNaverMap() async {
    // 네이버 지도 URL 생성 (병원 이름으로 검색)
    final query = Uri.encodeComponent(hospital.name);
    final url = Uri.parse('https://map.naver.com/v5/search/$query');

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  /// 카카오맵 열기
  Future<void> _openKakaoMap() async {
    // 카카오맵 URL 생성 (병원 이름으로 검색)
    final query = Uri.encodeComponent(hospital.name);
    final url = Uri.parse('https://map.kakao.com/?q=$query');

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }
}
