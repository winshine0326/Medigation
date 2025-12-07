/// API 관련 상수 정의
class ApiConstants {
  // 건강보험심사평가원 (HIRA) API
  static const String hiraBaseUrl = 'https://apis.data.go.kr/B551182';

  // 병원정보서비스 v2
  static const String hiraHospitalInfoEndpoint = '/hospInfoServicev2/getHospBasisList';

  // API 키 (환경 변수에서 로드)
  // .env 파일에서 HIRA_API_KEY 설정 필요
  static String? hiraApiKey;

  // Google Maps API 키 (이미 AndroidManifest.xml과 AppDelegate에 설정됨)
  // 추가 설정이 필요한 경우 여기에 정의

  // API 요청 타임아웃 (밀리초)
  static const int apiTimeout = 30000; // 30초

  // API 응답 포맷
  static const String responseFormat = 'json';

  // 페이지당 항목 수
  static const int itemsPerPage = 20;
}

/// Firestore 컬렉션 이름
class FirestoreCollections {
  static const String hospitals = 'hospitals';
  static const String bookmarks = 'bookmarks';
  static const String searchHistory = 'search_history';
  static const String userPreferences = 'user_preferences';
}

/// 로컬 DB 관련 상수
class LocalDbConstants {
  static const String dbName = 'medigation.db';
  static const int dbVersion = 1;

  // 테이블 이름
  static const String hospitalsTable = 'hospitals';
  static const String evaluationsTable = 'evaluations';
  static const String pricesTable = 'prices';

  // 캐시 만료 시간 (시간 단위)
  static const int cacheExpiryHours = 24;
}

/// 외부 리뷰 링크 URL 템플릿
class ReviewLinkConstants {
  // 네이버 지도 검색 URL
  static String getNaverMapSearchUrl(String hospitalName, String address) {
    final query = Uri.encodeComponent('$hospitalName $address');
    return 'https://map.naver.com/v5/search/$query';
  }

  // 카카오맵 검색 URL
  static String getKakaoMapSearchUrl(String hospitalName, String address) {
    final query = Uri.encodeComponent('$hospitalName $address');
    return 'https://map.kakao.com/?q=$query';
  }
}
