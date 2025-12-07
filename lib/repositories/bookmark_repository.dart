import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data_sources/firebase_provider.dart';

part 'bookmark_repository.g.dart';

/// 북마크 Repository
/// 사용자의 북마크 데이터를 관리
class BookmarkRepository {
  final CollectionReference<Map<String, dynamic>> _bookmarksCollection;

  BookmarkRepository(this._bookmarksCollection);

  /// 북마크 추가
  ///
  /// [userId] 사용자 ID
  /// [hospitalId] 병원 ID
  Future<void> addBookmark(String userId, String hospitalId) async {
    try {
      final bookmarkId = '${userId}_$hospitalId';
      await _bookmarksCollection.doc(bookmarkId).set({
        'userId': userId,
        'hospitalId': hospitalId,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('북마크 추가에 실패했습니다: $e');
    }
  }

  /// 북마크 제거
  ///
  /// [userId] 사용자 ID
  /// [hospitalId] 병원 ID
  Future<void> removeBookmark(String userId, String hospitalId) async {
    try {
      final bookmarkId = '${userId}_$hospitalId';
      await _bookmarksCollection.doc(bookmarkId).delete();
    } catch (e) {
      throw Exception('북마크 제거에 실패했습니다: $e');
    }
  }

  /// 북마크 목록 조회
  ///
  /// [userId] 사용자 ID
  /// Returns: 북마크한 병원 ID 목록
  Future<List<String>> getBookmarks(String userId) async {
    try {
      final snapshot = await _bookmarksCollection
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => doc.data()['hospitalId'] as String)
          .toList();
    } catch (e) {
      throw Exception('북마크 목록 조회에 실패했습니다: $e');
    }
  }

  /// 북마크 여부 확인
  ///
  /// [userId] 사용자 ID
  /// [hospitalId] 병원 ID
  /// Returns: 북마크 여부
  Future<bool> isBookmarked(String userId, String hospitalId) async {
    try {
      final bookmarkId = '${userId}_$hospitalId';
      final doc = await _bookmarksCollection.doc(bookmarkId).get();
      return doc.exists;
    } catch (e) {
      throw Exception('북마크 확인에 실패했습니다: $e');
    }
  }

  /// 북마크 토글 (추가/제거)
  ///
  /// [userId] 사용자 ID
  /// [hospitalId] 병원 ID
  /// Returns: 토글 후 북마크 상태 (true: 추가됨, false: 제거됨)
  Future<bool> toggleBookmark(String userId, String hospitalId) async {
    final isCurrentlyBookmarked = await isBookmarked(userId, hospitalId);

    if (isCurrentlyBookmarked) {
      await removeBookmark(userId, hospitalId);
      return false;
    } else {
      await addBookmark(userId, hospitalId);
      return true;
    }
  }
}

/// BookmarkRepository Provider
@riverpod
BookmarkRepository bookmarkRepository(BookmarkRepositoryRef ref) {
  final bookmarksCollection = ref.watch(bookmarksCollectionProvider);
  return BookmarkRepository(bookmarksCollection);
}
