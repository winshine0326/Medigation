import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/hospital.dart';
import '../repositories/hospital_repository.dart';
import '../data_sources/firebase_provider.dart';

part 'search_provider.g.dart';

/// 검색 상태
class SearchState {
  final String query;
  final List<Hospital> results;
  final List<String> searchHistory;
  final bool isLoading;
  final String? error;

  const SearchState({
    this.query = '',
    this.results = const [],
    this.searchHistory = const [],
    this.isLoading = false,
    this.error,
  });

  SearchState copyWith({
    String? query,
    List<Hospital>? results,
    List<String>? searchHistory,
    bool? isLoading,
    String? error,
  }) {
    return SearchState(
      query: query ?? this.query,
      results: results ?? this.results,
      searchHistory: searchHistory ?? this.searchHistory,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

/// 검색 Notifier
/// 검색어 및 검색 히스토리를 관리합니다
@riverpod
class SearchNotifier extends _$SearchNotifier {
  static const int _maxHistorySize = 10;

  @override
  SearchState build() {
    _loadSearchHistory();
    return const SearchState();
  }

  /// 검색 히스토리 로드
  Future<void> _loadSearchHistory() async {
    try {
      final searchHistoryCollection = ref.read(searchHistoryCollectionProvider);
      final snapshot = await searchHistoryCollection
          .orderBy('timestamp', descending: true)
          .limit(_maxHistorySize)
          .get();

      final history = snapshot.docs
          .map((doc) => doc.data()['query'] as String)
          .toList();

      state = state.copyWith(searchHistory: history);
    } catch (e) {
      // 히스토리 로드 실패는 무시
      print('검색 히스토리 로드 실패: $e');
    }
  }

  /// 병원 검색
  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      state = state.copyWith(
        query: '',
        results: [],
      );
      return;
    }

    state = state.copyWith(
      query: query,
      isLoading: true,
      error: null,
    );

    try {
      final repository = ref.read(hospitalRepositoryProvider);
      final results = await repository.searchHospitalsByName(query);

      state = state.copyWith(
        results: results,
        isLoading: false,
      );

      // 검색 히스토리에 추가
      await _addToHistory(query);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// 검색 히스토리에 추가
  Future<void> _addToHistory(String query) async {
    try {
      final searchHistoryCollection = ref.read(searchHistoryCollectionProvider);

      // 중복 제거: 같은 검색어가 있으면 삭제
      final existingDocs = await searchHistoryCollection
          .where('query', isEqualTo: query)
          .get();

      for (final doc in existingDocs.docs) {
        await doc.reference.delete();
      }

      // 새로운 검색어 추가
      await searchHistoryCollection.add({
        'query': query,
        'timestamp': DateTime.now().toIso8601String(),
      });

      // 히스토리 갯수 제한 (최대 10개)
      final allDocs = await searchHistoryCollection
          .orderBy('timestamp', descending: true)
          .get();

      if (allDocs.docs.length > _maxHistorySize) {
        for (int i = _maxHistorySize; i < allDocs.docs.length; i++) {
          await allDocs.docs[i].reference.delete();
        }
      }

      // 히스토리 재로드
      await _loadSearchHistory();
    } catch (e) {
      // 히스토리 추가 실패는 무시
      print('검색 히스토리 추가 실패: $e');
    }
  }

  /// 검색 히스토리 항목 삭제
  Future<void> removeFromHistory(String query) async {
    try {
      final searchHistoryCollection = ref.read(searchHistoryCollectionProvider);
      final docs = await searchHistoryCollection
          .where('query', isEqualTo: query)
          .get();

      for (final doc in docs.docs) {
        await doc.reference.delete();
      }

      // 히스토리 재로드
      await _loadSearchHistory();
    } catch (e) {
      print('검색 히스토리 삭제 실패: $e');
    }
  }

  /// 검색 히스토리 전체 삭제
  Future<void> clearHistory() async {
    try {
      final searchHistoryCollection = ref.read(searchHistoryCollectionProvider);
      final docs = await searchHistoryCollection.get();

      for (final doc in docs.docs) {
        await doc.reference.delete();
      }

      state = state.copyWith(searchHistory: []);
    } catch (e) {
      print('검색 히스토리 전체 삭제 실패: $e');
    }
  }

  /// 검색 히스토리 전체 삭제 (별칭)
  Future<void> clearAllHistory() async {
    await clearHistory();
  }

  /// 검색 결과 초기화
  void clearResults() {
    state = state.copyWith(
      query: '',
      results: [],
    );
  }

  /// 검색 초기화 (검색어 + 결과)
  void clearSearch() {
    clearResults();
  }

  /// 검색 히스토리 항목으로 검색
  Future<void> searchFromHistory(String query) async {
    await search(query);
  }
}
