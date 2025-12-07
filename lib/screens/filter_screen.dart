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
  late List<String> _selectedTotalGrades; // 선택된 종합 등급 목록
  late int? _minSpecialistCount;
  late int? _minDiagnosisCount;
  late double? _maxDistance;

  @override
  void initState() {
    super.initState();
    // 현재 필터 상태 로드
    final condition = ref.read(filterNotifierProvider).condition;
    _selectedBadgeTypes = List.from(condition.selectedBadgeTypes);
    _selectedTotalGrades = List.from(condition.selectedTotalGrades);
    _minSpecialistCount = condition.minSpecialistCount;
    _minDiagnosisCount = condition.minDiagnosisCount;
    _maxDistance = condition.maxDistance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('필터'),
        actions: [
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
            _buildTotalGradeFilter(),
            const Divider(height: 1),
            _buildCapacityFilter(),
            const Divider(height: 1),
            _buildBadgeFilterSection(),
            const Divider(height: 1),
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

  Widget _buildTotalGradeFilter() {
    final grades = ['S', 'A', 'B', 'C', 'D'];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '종합 등급 선택',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            '원하는 종합 평가 등급의 병원만 표시합니다 (다중 선택 가능)',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: grades.map((grade) {
              final isSelected = _selectedTotalGrades.contains(grade);
              return FilterChip(
                label: Text('${grade}등급'),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedTotalGrades.add(grade);
                    } else {
                      _selectedTotalGrades.remove(grade);
                    }
                  });
                },
                selectedColor: _getGradeColor(grade).withOpacity(0.3),
                checkmarkColor: _getGradeColor(grade),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Color _getGradeColor(String grade) {
    switch (grade) {
      case 'S': return const Color(0xFFFFD700); // Gold
      case 'A': return const Color(0xFF4CAF50); // Green
      case 'B': return const Color(0xFF2196F3); // Blue
      case 'C': return const Color(0xFFFF9800); // Orange
      case 'D': return const Color(0xFFF44336); // Red
      default: return Colors.grey;
    }
  }

  Widget _buildCapacityFilter() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '의료 규모/인프라',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          // 전문의 수
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('최소 전문의 수', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              Text(_minSpecialistCount != null ? '$_minSpecialistCount명 이상' : '제한 없음'),
            ],
          ),
          Slider(
            value: (_minSpecialistCount ?? 0).toDouble(),
            min: 0,
            max: 50,
            divisions: 10,
            label: _minSpecialistCount?.toString() ?? '0',
            onChanged: (value) {
              setState(() {
                _minSpecialistCount = value > 0 ? value.toInt() : null;
              });
            },
          ),

          const SizedBox(height: 16),

          // 특수 진료 수
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('최소 특수 진료 수', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              Text(_minDiagnosisCount != null ? '$_minDiagnosisCount개 이상' : '제한 없음'),
            ],
          ),
          Slider(
            value: (_minDiagnosisCount ?? 0).toDouble(),
            min: 0,
            max: 10,
            divisions: 10,
            label: _minDiagnosisCount?.toString() ?? '0',
            onChanged: (value) {
              setState(() {
                _minDiagnosisCount = value > 0 ? value.toInt() : null;
              });
            },
          ),
        ],
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
            '전문 분야 선택 (배지)',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('최대 거리', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              Text(_maxDistance != null ? '${_maxDistance!.toStringAsFixed(1)}km 이내' : '제한 없음'),
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
        ],
      ),
    );
  }

  /// 필터 적용
  void _applyFilters() {
    final notifier = ref.read(filterNotifierProvider.notifier);
    notifier.setBadgeTypes(_selectedBadgeTypes);
    notifier.setSelectedTotalGrades(_selectedTotalGrades);
    notifier.setMinSpecialistCount(_minSpecialistCount);
    notifier.setMinDiagnosisCount(_minDiagnosisCount);
    notifier.setMaxDistance(_maxDistance);

    Navigator.pop(context);
  }

  /// 필터 초기화
  void _resetFilters() {
    setState(() {
      _selectedBadgeTypes = [];
      _selectedTotalGrades = [];
      _minSpecialistCount = null;
      _minDiagnosisCount = null;
      _maxDistance = null;
    });

    ref.read(filterNotifierProvider.notifier).clearFilter();
  }
}
