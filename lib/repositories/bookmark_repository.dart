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
      print('북마크 추가 성공: $bookmarkId');
    } catch (e) {
      print('북마크 추가 실패: $e');
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
      print('북마크 제거 성공: $bookmarkId');
    } catch (e) {
      print('북마크 제거 실패: $e');
      throw Exception('북마크 제거에 실패했습니다: $e');
    }
  }

  /// 북마크 목록 조회
  ///
  /// [userId] 사용자 ID
  /// Returns: 북마크한 병원 ID 목록
  Future<List<String>> getBookmarks(String userId) async {
    try {
      print('북마크 조회 요청 (userId: $userId)');
      
      // Firestore 인덱스 생성 없이 조회하기 위해 orderBy 제거
      final snapshot = await _bookmarksCollection
          .where('userId', isEqualTo: userId)
          .get();

      print('북마크 조회 결과: ${snapshot.docs.length}건');

      // 메모리 내 정렬 (최신순) - 수정 가능한 리스트로 복사
      final docs = List.of(snapshot.docs);
      
      docs.sort((a, b) {
        final dataA = a.data();
        final dataB = b.data();
        
        final aTime = (dataA['createdAt'] as Timestamp?)?.toDate() ?? DateTime(0);
        final bTime = (dataB['createdAt'] as Timestamp?)?.toDate() ?? DateTime(0);
        return bTime.compareTo(aTime); // 내림차순
      });

      return docs
          .map((doc) => doc.data()['hospitalId'] as String)
          .toList();
    } catch (e) {
      print('북마크 목록 조회 실패 상세: $e');
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
