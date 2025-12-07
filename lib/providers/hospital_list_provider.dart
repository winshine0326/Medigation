import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/hospital.dart';
import '../repositories/hospital_repository.dart';

part 'hospital_list_provider.g.dart';

/// 병원 목록 상태
class HospitalListState {
  final List<Hospital> hospitals;
  final bool isLoading;
  final String? error;
  final bool hasMore;
  final int currentPage;

  const HospitalListState({
    this.hospitals = const [],
    this.isLoading = false,
    this.error,
    this.hasMore = true,
    this.currentPage = 0,
  });

  HospitalListState copyWith({
    List<Hospital>? hospitals,
    bool? isLoading,
    String? error,
    bool? hasMore,
    int? currentPage,
  }) {
    return HospitalListState(
      hospitals: hospitals ?? this.hospitals,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

/// 병원 목록 Notifier
/// 병원 목록 상태를 관리하고 페이지네이션을 처리합니다
@riverpod
class HospitalListNotifier extends _$HospitalListNotifier {
  static const int _pageSize = 20;

  @override
  HospitalListState build() {
    return const HospitalListState();
  }

  /// 병원 목록 초기 로드
  Future<void> loadHospitals() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final repository = ref.read(hospitalRepositoryProvider);
      final hospitals = await repository.getAllHospitals();

      // 첫 페이지 데이터만 로드
      final firstPageHospitals = hospitals.take(_pageSize).toList();

      state = state.copyWith(
        hospitals: firstPageHospitals,
        isLoading: false,
        hasMore: hospitals.length > _pageSize,
        currentPage: 1,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// 다음 페이지 로드 (무한 스크롤)
  Future<void> loadMoreHospitals() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true);

    try {
      final repository = ref.read(hospitalRepositoryProvider);
      final allHospitals = await repository.getAllHospitals();

      final startIndex = state.currentPage * _pageSize;
      final endIndex = startIndex + _pageSize;

      if (startIndex >= allHospitals.length) {
        state = state.copyWith(
          isLoading: false,
          hasMore: false,
        );
        return;
      }

      final nextPageHospitals = allHospitals
          .skip(startIndex)
          .take(_pageSize)
          .toList();

      state = state.copyWith(
        hospitals: [...state.hospitals, ...nextPageHospitals],
        isLoading: false,
        hasMore: endIndex < allHospitals.length,
        currentPage: state.currentPage + 1,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// 병원 목록 새로고침
  Future<void> refresh() async {
    state = const HospitalListState();
    await loadHospitals();
  }

  /// 특정 병원 상세 정보 가져오기
  Future<Hospital?> getHospitalDetail(String hospitalId) async {
    try {
      final repository = ref.read(hospitalRepositoryProvider);
      return await repository.getHospitalById(hospitalId);
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return null;
    }
  }

  /// 데이터 동기화
  Future<void> syncData() async {
    try {
      final repository = ref.read(hospitalRepositoryProvider);
      await repository.syncData();
      await refresh();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// 캐시 초기화
  Future<void> clearCache() async {
    try {
      final repository = ref.read(hospitalRepositoryProvider);
      await repository.clearCache();
      await refresh();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}
