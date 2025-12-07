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

      // 먼저 캐시된 데이터 확인
      List<Hospital> hospitals = await repository.getAllHospitals();

      // 캐시된 데이터가 없으면 기본 위치(서울 시청)에서 HIRA API로 검색
      if (hospitals.isEmpty) {
        print('캐시된 병원 데이터 없음. HIRA API로 서울 시청 주변 병원 검색 중...');
        try {
          hospitals = await repository.searchNearbyHospitalsFromHira(
            latitude: 37.5665, // 서울 시청 위도
            longitude: 126.9780, // 서울 시청 경도
            radiusInMeters: 10000, // 10km
            numOfRows: 50,
          );
          print('HIRA API에서 ${hospitals.length}개 병원 검색 완료');
        } catch (apiError) {
          print('HIRA API 검색 실패: $apiError');
          // API 실패해도 빈 리스트로 계속 진행
        }
      }

      // 첫 페이지 데이터만 로드
      final firstPageHospitals = hospitals.take(_pageSize).toList();

      // 상세 정보 보강 (API 호출)
      final enrichedHospitals = await _enrichHospitals(repository, firstPageHospitals);

      state = state.copyWith(
        hospitals: enrichedHospitals,
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

      // 상세 정보 보강 (API 호출)
      final enrichedNextPageHospitals = await _enrichHospitals(repository, nextPageHospitals);

      state = state.copyWith(
        hospitals: [...state.hospitals, ...enrichedNextPageHospitals],
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

  /// 병원 목록 상세 정보 보강
  Future<List<Hospital>> _enrichHospitals(
      HospitalRepository repository, List<Hospital> hospitals) async {
    if (hospitals.isEmpty) return [];

    print('병원 목록 ${hospitals.length}개 상세 정보 보강 시작...');
    
    // 병렬로 상세 정보 요청
    final enrichedList = await Future.wait(
      hospitals.map((hospital) async {
        try {
          // 이미 상세 정보가 있는지 확인 (간단한 체크)
          if (hospital.specialistInfoList.isNotEmpty || 
              hospital.nursingGradeInfoList.isNotEmpty) {
            return hospital;
          }
          return await repository.enrichHospitalDetails(hospital);
        } catch (e) {
          print('병원(${hospital.name}) 상세 정보 보강 실패: $e');
          return hospital;
        }
      }),
    );
    
    print('병원 목록 상세 정보 보강 완료');
    return enrichedList;
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

  /// 병원 목록 직접 업데이트 (검색 결과 등)
  Future<void> updateHospitals(List<Hospital> hospitals) async {
    // UI 먼저 업데이트 (빠른 응답)
    state = state.copyWith(
      hospitals: hospitals,
      isLoading: true, // 백그라운드 로딩 표시
      hasMore: false,
      currentPage: 1,
    );

    try {
      final repository = ref.read(hospitalRepositoryProvider);
      // 상세 정보 보강
      final enrichedHospitals = await _enrichHospitals(repository, hospitals);
      
      state = state.copyWith(
        hospitals: enrichedHospitals,
        isLoading: false,
      );
    } catch (e) {
      // 에러 발생 시 기존 리스트 유지하고 로딩만 끔
      print('검색 결과 상세 보강 실패: $e');
      state = state.copyWith(isLoading: false);
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
