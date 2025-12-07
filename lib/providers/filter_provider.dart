import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/hospital.dart';
import '../repositories/hospital_repository.dart';

part 'filter_provider.g.dart';

/// 필터 조건
class FilterCondition {
  final List<String> selectedBadgeTypes;
  final int? minReviewCount;
  final double? minRating;
  final List<String>? excludeGrades;
  final String? region;
  final double? maxDistance;

  const FilterCondition({
    this.selectedBadgeTypes = const [],
    this.minReviewCount,
    this.minRating,
    this.excludeGrades,
    this.region,
    this.maxDistance,
  });

  FilterCondition copyWith({
    List<String>? selectedBadgeTypes,
    int? minReviewCount,
    double? minRating,
    List<String>? excludeGrades,
    String? region,
    double? maxDistance,
  }) {
    return FilterCondition(
      selectedBadgeTypes: selectedBadgeTypes ?? this.selectedBadgeTypes,
      minReviewCount: minReviewCount ?? this.minReviewCount,
      minRating: minRating ?? this.minRating,
      excludeGrades: excludeGrades ?? this.excludeGrades,
      region: region ?? this.region,
      maxDistance: maxDistance ?? this.maxDistance,
    );
  }

  /// 필터가 적용되었는지 확인
  bool get isActive {
    return selectedBadgeTypes.isNotEmpty ||
        minReviewCount != null ||
        minRating != null ||
        (excludeGrades != null && excludeGrades!.isNotEmpty) ||
        region != null ||
        maxDistance != null;
  }

  /// 필터 초기화
  FilterCondition clear() {
    return const FilterCondition();
  }
}

/// 필터 상태
class FilterState {
  final FilterCondition condition;
  final List<Hospital> filteredHospitals;
  final bool isLoading;
  final String? error;

  const FilterState({
    this.condition = const FilterCondition(),
    this.filteredHospitals = const [],
    this.isLoading = false,
    this.error,
  });

  FilterState copyWith({
    FilterCondition? condition,
    List<Hospital>? filteredHospitals,
    bool? isLoading,
    String? error,
  }) {
    return FilterState(
      condition: condition ?? this.condition,
      filteredHospitals: filteredHospitals ?? this.filteredHospitals,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

/// 필터 Notifier
/// 필터 및 역필터링 상태를 관리합니다
@riverpod
class FilterNotifier extends _$FilterNotifier {
  @override
  FilterState build() {
    return const FilterState();
  }

  /// 배지 타입 필터 설정
  void setBadgeTypes(List<String> badgeTypes) {
    final newCondition = state.condition.copyWith(selectedBadgeTypes: badgeTypes);
    state = state.copyWith(condition: newCondition);
    _applyFilters();
  }

  /// 최소 리뷰 수 필터 설정 (역필터링)
  void setMinReviewCount(int? count) {
    final newCondition = state.condition.copyWith(minReviewCount: count);
    state = state.copyWith(condition: newCondition);
    _applyFilters();
  }

  /// 최소 평점 필터 설정 (역필터링)
  void setMinRating(double? rating) {
    final newCondition = state.condition.copyWith(minRating: rating);
    state = state.copyWith(condition: newCondition);
    _applyFilters();
  }

  /// 제외할 등급 설정 (역필터링)
  void setExcludeGrades(List<String>? grades) {
    final newCondition = state.condition.copyWith(excludeGrades: grades);
    state = state.copyWith(condition: newCondition);
    _applyFilters();
  }

  /// 지역 필터 설정
  void setRegion(String? region) {
    final newCondition = state.condition.copyWith(region: region);
    state = state.copyWith(condition: newCondition);
    _applyFilters();
  }

  /// 최대 거리 필터 설정
  void setMaxDistance(double? distance) {
    final newCondition = state.condition.copyWith(maxDistance: distance);
    state = state.copyWith(condition: newCondition);
    _applyFilters();
  }

  /// 필터 초기화
  void clearFilters() {
    state = state.copyWith(
      condition: const FilterCondition(),
      filteredHospitals: [],
    );
  }

  /// 필터 초기화 (별칭)
  void clearFilter() {
    clearFilters();
  }

  /// 필터 적용
  Future<void> _applyFilters() async {
    if (!state.condition.isActive) {
      state = state.copyWith(filteredHospitals: []);
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final repository = ref.read(hospitalRepositoryProvider);
      List<Hospital> hospitals = await repository.getAllHospitals();

      // 배지 타입 필터
      if (state.condition.selectedBadgeTypes.isNotEmpty) {
        hospitals = await repository.filterHospitalsByBadges(
          state.condition.selectedBadgeTypes,
        );
      }

      // 역필터링 적용
      hospitals = await repository.filterOutHospitals(
        minReviewCount: state.condition.minReviewCount,
        minRating: state.condition.minRating,
        excludeGrades: state.condition.excludeGrades,
      );

      // 지역 필터
      if (state.condition.region != null) {
        hospitals = hospitals.where((hospital) {
          return hospital.address.contains(state.condition.region!);
        }).toList();
      }

      state = state.copyWith(
        filteredHospitals: hospitals,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// 현재 필터 조건으로 병원 검색
  Future<List<Hospital>> getFilteredHospitals() async {
    if (!state.condition.isActive) {
      final repository = ref.read(hospitalRepositoryProvider);
      return await repository.getAllHospitals();
    }
    return state.filteredHospitals;
  }
}
