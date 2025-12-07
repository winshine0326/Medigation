import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/search_provider.dart';
import '../providers/bookmark_provider.dart';
import '../providers/location_provider.dart';
import '../widgets/hospital_card.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/error_display.dart';

/// 검색 화면
/// 병원 검색 및 검색 히스토리 관리
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchNotifierProvider);
    final bookmarkState = ref.watch(bookmarkNotifierProvider);
    final locationState = ref.watch(locationNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          autofocus: true,
          decoration: InputDecoration(
            hintText: '병원 이름 또는 주소 검색',
            border: InputBorder.none,
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      ref.read(searchNotifierProvider.notifier).clearSearch();
                      setState(() {});
                    },
                  )
                : null,
          ),
          onChanged: (value) {
            setState(() {});
          },
          onSubmitted: (value) {
            if (value.trim().isNotEmpty) {
              ref.read(searchNotifierProvider.notifier).search(value);
            }
          },
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                if (_searchController.text.trim().isNotEmpty) {
                  ref
                      .read(searchNotifierProvider.notifier)
                      .search(_searchController.text);
                }
              },
            ),
        ],
      ),
      body: _buildBody(searchState, bookmarkState, locationState),
    );
  }

  Widget _buildBody(
    SearchState searchState,
    BookmarkState bookmarkState,
    LocationState locationState,
  ) {
    // 검색어가 없으면 검색 히스토리 표시
    if (searchState.query.isEmpty) {
      return _buildSearchHistory(searchState);
    }

    // 로딩 상태
    if (searchState.isLoading) {
      return const LoadingIndicator(message: '검색 중...');
    }

    // 에러 상태
    if (searchState.error != null) {
      return ErrorDisplay(
        message: searchState.error!,
        onRetry: () {
          ref.read(searchNotifierProvider.notifier).search(searchState.query);
        },
      );
    }

    // 검색 결과가 없을 때
    if (searchState.results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              '검색 결과가 없습니다',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '다른 검색어를 입력해보세요',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    // 검색 결과 표시
    return ListView.builder(
      itemCount: searchState.results.length,
      itemBuilder: (context, index) {
        final hospital = searchState.results[index];
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

  /// 검색 히스토리 표시
  Widget _buildSearchHistory(SearchState searchState) {
    if (searchState.searchHistory.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              '최근 검색 기록이 없습니다',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '병원 이름 또는 주소로 검색해보세요',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 헤더
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '최근 검색',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  // 전체 삭제 확인 다이얼로그
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('검색 기록 삭제'),
                      content: const Text('모든 검색 기록을 삭제하시겠습니까?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('취소'),
                        ),
                        TextButton(
                          onPressed: () {
                            ref
                                .read(searchNotifierProvider.notifier)
                                .clearAllHistory();
                            Navigator.pop(context);
                          },
                          child: const Text('삭제'),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text('전체 삭제'),
              ),
            ],
          ),
        ),

        // 검색 히스토리 목록
        Expanded(
          child: ListView.separated(
            itemCount: searchState.searchHistory.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final query = searchState.searchHistory[index];
              return ListTile(
                leading: Icon(
                  Icons.history,
                  color: Colors.grey[600],
                ),
                title: Text(query),
                trailing: IconButton(
                  icon: Icon(
                    Icons.close,
                    size: 20,
                    color: Colors.grey[600],
                  ),
                  onPressed: () {
                    ref
                        .read(searchNotifierProvider.notifier)
                        .removeFromHistory(query);
                  },
                ),
                onTap: () {
                  _searchController.text = query;
                  ref.read(searchNotifierProvider.notifier).search(query);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
