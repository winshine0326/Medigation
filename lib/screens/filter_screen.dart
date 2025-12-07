import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/badge.dart';
import '../providers/filter_provider.dart';
import '../widgets/badge_chip.dart';

/// 필터 화면
/// 병원 검색 필터 및 역필터링 설정
class FilterScreen extends ConsumerStatefulWidget {
  const FilterScreen({super.key});

  @override
  ConsumerState<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends ConsumerState<FilterScreen> {
  late List<String> _selectedBadgeTypes;
  late double? _minRating;
  late int? _minReviewCount;
  late List<String> _excludeGrades;
  late double? _maxDistance;

  @override
  void initState() {
    super.initState();
    // 현재 필터 상태 로드
    final condition = ref.read(filterNotifierProvider).condition;
    _selectedBadgeTypes = List.from(condition.selectedBadgeTypes);
    _minRating = condition.minRating;
    _minReviewCount = condition.minReviewCount;
    _excludeGrades = List.from(condition.excludeGrades ?? []);
    _maxDistance = condition.maxDistance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('필터'),
        actions: [
          // 초기화 버튼
          TextButton(
            onPressed: _resetFilters,
            child: const Text('초기화'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 전문 분야 선택
            _buildBadgeFilterSection(),
            const Divider(height: 1),

            // 역필터링 섹션
            _buildReverseFilterSection(),
            const Divider(height: 1),

            // 거리 필터 섹션
            _buildDistanceFilterSection(),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: _applyFilters,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text(
              '필터 적용',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  /// 전문 분야 필터 섹션
  Widget _buildBadgeFilterSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '전문 분야 선택',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '원하는 전문 분야를 선택하세요 (다중 선택 가능)',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),

          // 배지 타입 선택
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: BadgeType.values.map((badgeType) {
              final isSelected =
                  _selectedBadgeTypes.contains(badgeType.toString());
              return BadgeChip(
                badgeType: badgeType,
                isSelected: isSelected,
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedBadgeTypes.remove(badgeType.toString());
                    } else {
                      _selectedBadgeTypes.add(badgeType.toString());
                    }
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  /// 역필터링 섹션
  Widget _buildReverseFilterSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                '역필터링',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Tooltip(
                message: '피해야 할 병원을 걸러내는 기준을 설정합니다',
                child: Icon(
                  Icons.info_outline,
                  size: 20,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '피해야 할 병원 기준을 설정하세요',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),

          // 최소 평점 필터
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '최소 평점',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        _minRating != null ? '${_minRating!.toStringAsFixed(1)}점 이상' : '제한 없음',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: _minRating ?? 0.0,
                    min: 0.0,
                    max: 5.0,
                    divisions: 10,
                    label: _minRating?.toStringAsFixed(1) ?? '제한 없음',
                    onChanged: (value) {
                      setState(() {
                        _minRating = value > 0 ? value : null;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // 최소 리뷰 수 필터
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '최소 리뷰 수',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        _minReviewCount != null ? '$_minReviewCount개 이상' : '제한 없음',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: (_minReviewCount ?? 0).toDouble(),
                    min: 0,
                    max: 100,
                    divisions: 20,
                    label: _minReviewCount?.toString() ?? '제한 없음',
                    onChanged: (value) {
                      setState(() {
                        _minReviewCount = value > 0 ? value.toInt() : null;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // 제외할 등급 선택
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '제외할 평가 등급',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ['1등급', '2등급', '3등급', '4등급', '5등급'].map((grade) {
                      final isSelected = _excludeGrades.contains(grade);
                      return FilterChip(
                        label: Text(grade),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _excludeGrades.add(grade);
                            } else {
                              _excludeGrades.remove(grade);
                            }
                          });
                        },
                        selectedColor: Colors.red[100],
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 거리 필터 섹션
  Widget _buildDistanceFilterSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '거리 제한',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '최대 거리',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        _maxDistance != null ? '${_maxDistance!.toStringAsFixed(1)}km 이내' : '제한 없음',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: _maxDistance ?? 0,
                    min: 0,
                    max: 50,
                    divisions: 50,
                    label: _maxDistance != null ? '${_maxDistance!.toStringAsFixed(1)}km' : '제한 없음',
                    onChanged: (value) {
                      setState(() {
                        _maxDistance = value > 0 ? value : null;
                      });
                    },
                  ),
                  Text(
                    '현재 위치에서의 거리를 기준으로 필터링합니다',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 필터 적용
  void _applyFilters() {
    ref.read(filterNotifierProvider.notifier).setBadgeTypes(_selectedBadgeTypes);
    ref.read(filterNotifierProvider.notifier).setMinRating(_minRating);
    ref.read(filterNotifierProvider.notifier).setMinReviewCount(_minReviewCount);
    ref.read(filterNotifierProvider.notifier).setExcludeGrades(_excludeGrades);
    ref.read(filterNotifierProvider.notifier).setMaxDistance(_maxDistance);

    Navigator.pop(context);
  }

  /// 필터 초기화
  void _resetFilters() {
    setState(() {
      _selectedBadgeTypes = [];
      _minRating = null;
      _minReviewCount = null;
      _excludeGrades = [];
      _maxDistance = null;
    });

    ref.read(filterNotifierProvider.notifier).clearFilter();
  }
}
