import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/hospital.dart';
import '../repositories/bookmark_repository.dart';
import '../repositories/hospital_repository.dart';

part 'bookmark_provider.g.dart';

/// 북마크 상태
class BookmarkState {
  final List<String> bookmarkedHospitalIds;
  final List<Hospital> bookmarkedHospitals;
  final bool isLoading;
  final String? error;

  const BookmarkState({
    this.bookmarkedHospitalIds = const [],
    this.bookmarkedHospitals = const [],
    this.isLoading = false,
    this.error,
  });

  BookmarkState copyWith({
    List<String>? bookmarkedHospitalIds,
    List<Hospital>? bookmarkedHospitals,
    bool? isLoading,
    String? error,
  }) {
    return BookmarkState(
      bookmarkedHospitalIds: bookmarkedHospitalIds ?? this.bookmarkedHospitalIds,
      bookmarkedHospitals: bookmarkedHospitals ?? this.bookmarkedHospitals,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  /// 특정 병원이 북마크되어 있는지 확인
  bool isBookmarked(String hospitalId) {
    return bookmarkedHospitalIds.contains(hospitalId);
  }
}

/// 북마크 Notifier
/// 북마크 목록 상태를 관리합니다
@riverpod
class BookmarkNotifier extends _$BookmarkNotifier {
  // 임시 사용자 ID (실제로는 Firebase Auth로 관리)
  static const String _tempUserId = 'temp_user';

  @override
  BookmarkState build() {
    loadBookmarks();
    return const BookmarkState();
  }

  /// 북마크 목록 로드
  Future<void> loadBookmarks() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final bookmarkRepository = ref.read(bookmarkRepositoryProvider);
      final hospitalRepository = ref.read(hospitalRepositoryProvider);

      // 북마크된 병원 ID 목록 가져오기
      final bookmarkedIds = await bookmarkRepository.getBookmarks(_tempUserId);

      // 병원 상세 정보 가져오기
      final hospitals = <Hospital>[];
      for (final hospitalId in bookmarkedIds) {
        final hospital = await hospitalRepository.getHospitalById(hospitalId);
        if (hospital != null) {
          hospitals.add(hospital);
        }
      }

      state = state.copyWith(
        bookmarkedHospitalIds: bookmarkedIds,
        bookmarkedHospitals: hospitals,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// 북마크 추가
  Future<void> addBookmark(String hospitalId) async {
    try {
      final repository = ref.read(bookmarkRepositoryProvider);
      await repository.addBookmark(_tempUserId, hospitalId);

      // 상태 업데이트
      await loadBookmarks();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// 북마크 제거
  Future<void> removeBookmark(String hospitalId) async {
    try {
      final repository = ref.read(bookmarkRepositoryProvider);
      await repository.removeBookmark(_tempUserId, hospitalId);

      // 상태 업데이트
      await loadBookmarks();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// 북마크 토글 (추가/제거)
  Future<bool> toggleBookmark(String hospitalId) async {
    try {
      final repository = ref.read(bookmarkRepositoryProvider);
      final isBookmarked = await repository.toggleBookmark(_tempUserId, hospitalId);

      // 상태 업데이트
      await loadBookmarks();

      return isBookmarked;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// 특정 병원이 북마크되어 있는지 확인
  Future<bool> isBookmarked(String hospitalId) async {
    try {
      final repository = ref.read(bookmarkRepositoryProvider);
      return await repository.isBookmarked(_tempUserId, hospitalId);
    } catch (e) {
      return false;
    }
  }

  /// 북마크 새로고침
  Future<void> refresh() async {
    await loadBookmarks();
  }
}
