import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/hospital_list_provider.dart';
import '../providers/bookmark_provider.dart';
import '../providers/location_provider.dart';
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
          // 필터 버튼
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              Navigator.pushNamed(context, '/filter');
            },
          ),
        ],
      ),
      body: _buildBody(hospitalListState, bookmarkState, locationState),
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
    BookmarkState bookmarkState,
    LocationState locationState,
  ) {
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
