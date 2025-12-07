import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/hospital_list_provider.dart';
import '../providers/bookmark_provider.dart';
import '../providers/location_provider.dart';
import '../providers/filter_provider.dart';
import '../widgets/hospital_card.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/error_display.dart';

/// 병원 목록 화면
/// 병원 목록을 표시하고 무한 스크롤, 필터, 검색 기능을 제공
class HospitalListScreen extends ConsumerStatefulWidget {
  const HospitalListScreen({super.key});

  @override
  ConsumerState<HospitalListScreen> createState() =>
      _HospitalListScreenState();
}

class _HospitalListScreenState extends ConsumerState<HospitalListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // 초기 데이터 로드
    Future.microtask(() {
      ref.read(hospitalListNotifierProvider.notifier).loadHospitals();
    });

    // 무한 스크롤 리스너
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      // 스크롤이 90%에 도달하면 다음 페이지 로드
      ref.read(hospitalListNotifierProvider.notifier).loadMoreHospitals();
    }
  }

  @override
  Widget build(BuildContext context) {
    final hospitalListState = ref.watch(hospitalListNotifierProvider);
    final filterState = ref.watch(filterNotifierProvider); // 필터 상태 구독
    final bookmarkState = ref.watch(bookmarkNotifierProvider);
    final locationState = ref.watch(locationNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('메디게이션'),
        actions: [
          // 검색 버튼
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.pushNamed(context, '/search');
            },
          ),
          // 필터 버튼 (활성화 시 색상 변경)
          IconButton(
            icon: Icon(
              Icons.filter_list,
              color: filterState.condition.isActive ? Colors.blue : null,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/filter');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 필터 적용 중일 때 배너 표시
          if (filterState.condition.isActive)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              color: Colors.blue[50],
              child: Row(
                children: [
                  const Icon(Icons.filter_alt, size: 16, color: Colors.blue),
                  const SizedBox(width: 8),
                  Text(
                    '필터 적용 중 (${filterState.filteredHospitals.length}개 결과)',
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      ref.read(filterNotifierProvider.notifier).clearFilters();
                    },
                    child: const Icon(Icons.close, size: 16, color: Colors.blue),
                  ),
                ],
              ),
            ),
          Expanded(
            child: _buildBody(
              hospitalListState,
              filterState,
              bookmarkState,
              locationState,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // 현재 위치 기반 검색
          await ref.read(locationNotifierProvider.notifier).searchNearbyHospitals();

          // 검색된 병원을 HospitalListProvider에도 반영
          final nearbyHospitals = ref.read(locationNotifierProvider).nearbyHospitals;
          if (nearbyHospitals.isNotEmpty) {
            ref.read(hospitalListNotifierProvider.notifier).updateHospitals(nearbyHospitals);
          }
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }

  Widget _buildBody(
    HospitalListState hospitalListState,
    FilterState filterState,
    BookmarkState bookmarkState,
    LocationState locationState,
  ) {
    // 필터 적용 중인 경우
    if (filterState.condition.isActive) {
      if (filterState.isLoading) {
        return const LoadingIndicator(message: '필터링 중...');
      }
      
      if (filterState.filteredHospitals.isEmpty) {
        return const EmptyDisplay(
          message: '조건에 맞는 병원이 없습니다.',
          icon: Icons.filter_list_off,
        );
      }

      return ListView.builder(
        itemCount: filterState.filteredHospitals.length,
        itemBuilder: (context, index) {
          final hospital = filterState.filteredHospitals[index];
          final isBookmarked = bookmarkState.isBookmarked(hospital.id);
          final distance = locationState.hasLocation
              ? ref
                  .read(locationNotifierProvider.notifier)
                  .getDistanceToHospital(hospital)
              : null;

          return HospitalCard(
            hospital: hospital,
            isBookmarked: isBookmarked,
            distance: distance,
            onTap: () {
              Navigator.pushNamed(
                context,
                '/hospital-detail',
                arguments: hospital,
              );
            },
            onBookmarkTap: () {
              ref
                  .read(bookmarkNotifierProvider.notifier)
                  .toggleBookmark(hospital.id);
            },
          );
        },
      );
    }

    // 일반 목록 (필터 미적용)
    // 로딩 상태
    if (hospitalListState.isLoading && hospitalListState.hospitals.isEmpty) {
      return const LoadingIndicator(message: '병원 목록을 불러오는 중...');
    }

    // 에러 상태
    if (hospitalListState.error != null &&
        hospitalListState.hospitals.isEmpty) {
      return ErrorDisplay(
        message: hospitalListState.error!,
        onRetry: () {
          ref.read(hospitalListNotifierProvider.notifier).loadHospitals();
        },
      );
    }

    // 빈 상태
    if (hospitalListState.hospitals.isEmpty) {
      return const EmptyDisplay(
        message: '병원 정보가 없습니다.',
        icon: Icons.local_hospital_outlined,
      );
    }

    // 병원 목록 표시
    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(hospitalListNotifierProvider.notifier).refresh();
      },
      child: ListView.builder(
        controller: _scrollController,
        itemCount: hospitalListState.hospitals.length +
            (hospitalListState.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          // 로딩 인디케이터 (마지막 항목)
          if (index == hospitalListState.hospitals.length) {
            return const SmallLoadingIndicator(message: '더 불러오는 중...');
          }

          final hospital = hospitalListState.hospitals[index];
          final isBookmarked = bookmarkState.isBookmarked(hospital.id);
          final distance = locationState.hasLocation
              ? ref
                  .read(locationNotifierProvider.notifier)
                  .getDistanceToHospital(hospital)
              : null;

          return HospitalCard(
            hospital: hospital,
            isBookmarked: isBookmarked,
            distance: distance,
            onTap: () {
              // TODO: 병원 상세 화면으로 이동
              Navigator.pushNamed(
                context,
                '/hospital-detail',
                arguments: hospital,
              );
            },
            onBookmarkTap: () {
              ref
                  .read(bookmarkNotifierProvider.notifier)
                  .toggleBookmark(hospital.id);
            },
          );
        },
      ),
    );
  }
}
