import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/bookmark_provider.dart';
import '../providers/location_provider.dart';
import '../widgets/hospital_card.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/error_display.dart';

/// 북마크 화면
/// 사용자가 북마크한 병원 목록을 표시
class BookmarkScreen extends ConsumerWidget {
  const BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarkState = ref.watch(bookmarkNotifierProvider);
    final locationState = ref.watch(locationNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('북마크'),
        actions: [
          if (bookmarkState.bookmarkedHospitals.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                ref.read(bookmarkNotifierProvider.notifier).refresh();
              },
            ),
        ],
      ),
      body: _buildBody(context, ref, bookmarkState, locationState),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    BookmarkState bookmarkState,
    LocationState locationState,
  ) {
    // 로딩 상태
    if (bookmarkState.isLoading) {
      return const LoadingIndicator(message: '북마크 목록을 불러오는 중...');
    }

    // 에러 상태
    if (bookmarkState.error != null) {
      return ErrorDisplay(
        message: bookmarkState.error!,
        onRetry: () {
          ref.read(bookmarkNotifierProvider.notifier).loadBookmarks();
        },
      );
    }

    // 빈 상태
    if (bookmarkState.bookmarkedHospitals.isEmpty) {
      return const EmptyDisplay(
        message: '북마크한 병원이 없습니다.',
        icon: Icons.bookmark_border,
      );
    }

    // 북마크 목록 표시
    return ListView.builder(
      itemCount: bookmarkState.bookmarkedHospitals.length,
      itemBuilder: (context, index) {
        final hospital = bookmarkState.bookmarkedHospitals[index];
        final distance = locationState.hasLocation
            ? ref
                .read(locationNotifierProvider.notifier)
                .getDistanceToHospital(hospital)
            : null;

        return HospitalCard(
          hospital: hospital,
          isBookmarked: true,
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
                .removeBookmark(hospital.id);
          },
        );
      },
    );
  }
}
