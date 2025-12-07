import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/hospital.dart';
import '../providers/bookmark_provider.dart';
import '../providers/location_provider.dart';
import '../repositories/hospital_repository.dart';
import '../widgets/badge_chip.dart';
import '../utils/hospital_score_calculator.dart';
import '../utils/review_link_generator.dart';

/// 병원 상세 화면
/// 병원의 종합 리포트 (평가 + 가격 + 리뷰)를 표시
class HospitalDetailScreen extends ConsumerStatefulWidget {
  final Hospital hospital;

  const HospitalDetailScreen({
    super.key,
    required this.hospital,
  });

  @override
  ConsumerState<HospitalDetailScreen> createState() => _HospitalDetailScreenState();
}

class _HospitalDetailScreenState extends ConsumerState<HospitalDetailScreen> {
  late Hospital _hospital;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _hospital = widget.hospital;
    _fetchDetailedInfo();
  }

  Future<void> _fetchDetailedInfo() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // 상세 정보 조회 (캐시 확인 및 API 호출)
      final enrichedHospital = await ref
          .read(hospitalRepositoryProvider)
          .getHospitalById(_hospital.id);

      if (enrichedHospital != null && mounted) {
        setState(() {
          _hospital = enrichedHospital;
        });
      }
    } catch (e) {
      debugPrint('병원 상세 정보 로드 실패: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookmarkState = ref.watch(bookmarkNotifierProvider);
    final locationState = ref.watch(locationNotifierProvider);
    final isBookmarked = bookmarkState.isBookmarked(_hospital.id);

    final distance = locationState.hasLocation
        ? ref
            .read(locationNotifierProvider.notifier)
            .getDistanceToHospital(_hospital)
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
                  .toggleBookmark(_hospital.id);
            },
          ),
        ],
      ),
      body: _isLoading && _hospital.specialistInfoList.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 병원 기본 정보
                  _buildBasicInfo(context, distance),
                  const Divider(height: 1),

                  // 데이터 융합 리포트 섹션
                  _buildScoreReportSection(context),
                  const Divider(height: 1),

                  // 배지 섹션
                  if (_hospital.evaluations.isNotEmpty) ...[
                    _buildBadgeSection(context),
                    const Divider(height: 1),
                  ],

                  // 상세 정보 섹션 (전문의, 간호등급, 특수진료)
                  if (_hospital.specialistInfoList.isNotEmpty ||
                      _hospital.nursingGradeInfoList.isNotEmpty ||
                      _hospital.specialDiagnosisInfoList.isNotEmpty) ...[
                    _buildDetailInfoSection(context),
                    const Divider(height: 1),
                  ],

                  // 비급여 가격 섹션
                  if (_hospital.nonCoveredPrices.isNotEmpty) ...[
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
            _hospital.name,
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
                  _hospital.address,
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
    for (final evaluation in _hospital.evaluations) {
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

  /// 상세 정보 섹션 (전문의, 간호등급, 특수진료)
  Widget _buildDetailInfoSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '간호등급 및 전문정보',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // 1. 간호 등급 정보 (우선순위 상향)
          if (_hospital.nursingGradeInfoList.isNotEmpty) ...[
            const Text(
              '간호 등급',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Column(
              children: _hospital.nursingGradeInfoList.map((info) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle_outline,
                          size: 16, color: Colors.green),
                      const SizedBox(width: 8),
                      Text(
                        '${info.typeName}: ',
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(
                        info.careGrade,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
          ],

          // 2. 전문의 정보
          if (_hospital.specialistInfoList.isNotEmpty) ...[
            const Text(
              '전문의 현황',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _hospital.specialistInfoList.map((info) {
                return Chip(
                  label: Text('${info.specialtyName} ${info.specialistCount}명'),
                  backgroundColor: Colors.blue[50],
                  labelStyle: TextStyle(
                    color: Colors.blue[900],
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  padding: const EdgeInsets.all(0),
                  visualDensity: VisualDensity.compact,
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
          ],

          // 3. 특수 진료 정보
          if (_hospital.specialDiagnosisInfoList.isNotEmpty) ...[
            const Text(
              '특수 진료 가능 분야',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _hospital.specialDiagnosisInfoList.map((info) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    info.searchCodeName,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[800],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
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
                for (var entry in _hospital.nonCoveredPrices.asMap().entries) ...[
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
                  if (entry.key != _hospital.nonCoveredPrices.length - 1)
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

  /// 가격 포맷팅 (천 단위 구분)
  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }

  /// 데이터 융합 리포트 섹션
  Widget _buildScoreReportSection(BuildContext context) {
    final report = HospitalScoreCalculator.generateReport(_hospital);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '종합 리포트',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // 종합 점수 카드
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // 종합 점수 및 등급
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        report.totalScore.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Color(
                            int.parse(
                                '0xFF${report.scoreColor.substring(1)}'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '등급 ${report.grade}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '/ 100점',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 데이터 완성도
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '데이터 완성도: ',
                        style: TextStyle(fontSize: 14),
                      ),
                      Text(
                        report.dataCompletenessText,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${report.dataCompleteness.toStringAsFixed(0)}%)',
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
          const SizedBox(height: 16),

          // 점수 구성 상세
          const Text(
            '점수 구성',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),

          // 1. 간호 등급
          if (report.nursingWeight > 0.05) ...[
            _buildScoreItem(
              '간호 등급 (의료 질)',
              report.nursingScore,
              report.nursingContribution,
              Icons.health_and_safety,
              Colors.blue,
              report.nursingWeight,
            ),
            const SizedBox(height: 8),
          ],

          // 2. 의료 규모/인프라
          if (report.capacityWeight > 0.05) ...[
            _buildScoreItem(
              '의료 규모/인프라 (전문의/특수진료)',
              report.capacityScore,
              report.capacityContribution,
              Icons.domain,
              Colors.purple,
              report.capacityWeight,
            ),
            const SizedBox(height: 8),
          ],

          // 3. 전문 분야 (배지)
          if (report.badgeWeight > 0.05) ...[
            _buildScoreItem(
              '전문 분야 (특화)',
              report.badgeScore,
              report.badgeContribution,
              Icons.verified,
              Colors.green,
              report.badgeWeight,
            ),
            const SizedBox(height: 8),
          ],

          // 4. 리뷰 통계
          if (report.reviewWeight > 0.05) ...[
            _buildScoreItem(
              '사용자 리뷰 (만족도)',
              report.reviewScore,
              report.reviewContribution,
              Icons.star,
              Colors.orange,
              report.reviewWeight,
            ),
          ],
        ],
      ),
    );
  }

  /// 점수 구성 항목
  Widget _buildScoreItem(
    String label,
    double score,
    double contribution,
    IconData icon,
    Color color,
    double weight,
  ) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${(weight * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              LinearProgressIndicator(
                value: score / 100.0,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 6,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              score.toStringAsFixed(1),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '(${contribution.toStringAsFixed(1)}점)',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// 네이버 지도 열기
  Future<void> _openNaverMap() async {
    final success = await ReviewLinkGenerator.openNaverMap(_hospital);
    if (!success) {
      // 에러 처리 (optional)
      debugPrint('네이버 지도를 열 수 없습니다.');
    }
  }

  /// 카카오맵 열기
  Future<void> _openKakaoMap() async {
    final success = await ReviewLinkGenerator.openKakaoMap(_hospital);
    if (!success) {
      // 에러 처리 (optional)
      debugPrint('카카오맵을 열 수 없습니다.');
    }
  }
}

