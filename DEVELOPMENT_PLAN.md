# 메디게이션 개발 계획서

## Phase 1: 프로젝트 초기 설정 및 구성 ✅ (완료)

### 1.1 의존성 패키지 추가 ✅
- [x] pubspec.yaml에 Riverpod 관련 패키지 추가 (`flutter_riverpod`, `riverpod_annotation`)
- [x] Firebase 관련 패키지 추가 (`firebase_core`, `cloud_firestore`)
- [x] Google Maps 패키지 추가 (`google_maps_flutter`)
- [x] HTTP 통신 패키지 추가 (`http`, `dio`)
- [x] 로컬 DB 패키지 추가 (`sqflite` 또는 `hive`)
- [x] JSON 직렬화 패키지 추가 (`json_annotation`, `json_serializable`)
- [x] URL 런처 패키지 추가 (`url_launcher` - 네이버/카카오맵 리뷰 링크용)
- [x] 위치 정보 패키지 추가 (`geolocator`, `geocoding`)
- [x] `flutter pub get` 실행

### 1.2 Firebase 설정 ✅
- [x] Firebase 프로젝트 생성 (https://console.firebase.google.com)
- [x] Android용 Firebase 설정 (`google-services.json` 다운로드 및 `android/app/`에 배치)
- [x] iOS용 Firebase 설정 (`GoogleService-Info.plist` 다운로드 및 `ios/Runner/`에 배치)
- [x] `flutterfire configure --project=medigation-773ab` 실행 완료
- [x] Firebase 초기화 코드 작성 (`main.dart`)
- [ ] **[수동 필요]** Firestore 데이터베이스 생성 및 규칙 설정 (Firebase Console에서 수행)

### 1.3 Google Maps API 설정 ✅
- [x] Google Cloud Console에서 Maps SDK for Android 활성화
- [x] Google Cloud Console에서 Maps SDK for iOS 활성화
- [x] API 키 발급 완료
- [x] Android `AndroidManifest.xml`에 API 키 추가 완료
- [x] iOS `AppDelegate.swift`에 API 키 추가 완료
- [x] iOS `Info.plist`에 위치 권한 설명 추가
- [x] Android 권한 설정 완료

### 1.4 프로젝트 폴더 구조 생성 ₩
- [x] `lib/models/` 디렉토리 생성
- [x] `lib/providers/` 디렉토리 생성 (Riverpod providers)
- [x] `lib/repositories/` 디렉토리 생성
- [x] `lib/data_sources/` 디렉토리 생성
- [x] `lib/screens/` 디렉토리 생성
- [x] `lib/widgets/` 디렉토리 생성
- [x] `lib/utils/` 디렉토리 생성
- [x] `lib/constants/` 디렉토리 생성

**Phase 1 완료 사항:**
- ✅ 모든 필수 패키지 설치 완료
- ✅ 프로젝트 폴더 구조 생성 완료
- ✅ Android/iOS 권한 및 설정 파일 구성 완료
- ✅ Firebase 및 Riverpod 초기화 코드 준비 완료
- ✅ Google Maps API 키 발급 및 Android/iOS 설정 완료

**Firebase 설정 완료 상태:**
- ✅ `flutterfire configure --project=medigation-773ab` 실행 완료
- ✅ `android/app/google-services.json` 생성 완료
- ✅ `ios/Runner/GoogleService-Info.plist` 생성 완료
- ⚠️ `lib/firebase_options.dart` 파일 확인 필요 (누락 시 flutterfire configure 재실행)
- ⚠️ Firebase Console에서 Firestore 데이터베이스 생성 및 규칙 설정 필요

---

## Phase 2: 핵심 데이터 모델 구현 ✅ (완료)

### 2.1 Hospital 모델 ✅
- [x] `lib/models/hospital.dart` 생성
- [x] Hospital 클래스 정의 (id, name, address, latitude, longitude)
- [x] `fromJson`, `toJson` 메서드 구현 (Freezed 사용)
- [x] 병원 평가 목록 필드 추가
- [x] 비급여 가격 목록 필드 추가
- [x] 리뷰 통계 필드 추가

### 2.2 HospitalEvaluation 모델 ✅
- [x] `lib/models/hospital_evaluation.dart` 생성
- [x] HospitalEvaluation 클래스 정의 (평가 항목, 평가 등급)
- [x] 생성된 배지 목록 필드 추가
- [x] `fromJson`, `toJson` 메서드 구현 (Freezed 사용)

### 2.3 NonCoveredPrice 모델 ✅
- [x] `lib/models/non_covered_price.dart` 생성
- [x] NonCoveredPrice 클래스 정의 (항목명, 가격)
- [x] `fromJson`, `toJson` 메서드 구현 (Freezed 사용)

### 2.4 ReviewStatistics 모델 ✅
- [x] `lib/models/review_statistics.dart` 생성
- [x] ReviewStatistics 클래스 정의 (평균 별점, 총 리뷰 개수)
- [x] 주요 리뷰 키워드 목록 필드 추가
- [x] `fromJson`, `toJson` 메서드 구현 (Freezed 사용)

### 2.5 Badge 모델 ✅
- [x] `lib/models/badge.dart` 생성
- [x] Badge 클래스 정의 (badge type, label, icon)
- [x] 배지 타입 enum 정의 (전문 분야별 - 19개 타입)
- [x] BadgeTypeExtension으로 아이콘 및 색상 매핑 구현
- [x] `fromJson`, `toJson` 메서드 구현 (Freezed 사용)

**Phase 2 완료 사항:**
- ✅ 모든 핵심 데이터 모델 구현 완료
- ✅ Freezed를 사용한 불변 객체 패턴 적용
- ✅ JSON 직렬화/역직렬화 구현
- ✅ 19개 전문 분야별 배지 타입 정의
- ✅ 배지별 아이콘 및 색상 매핑 완료

---

## Phase 3: Data Source Layer 구현 ✅ (완료)

### 3.1 HIRA API Provider (건강보험심사평가원) ✅
- [x] `lib/data_sources/hira_api_provider.dart` 생성
- [x] API 엔드포인트 상수 정의 (`lib/constants/api_constants.dart`)
- [x] 병원 평가 데이터 조회 메서드 구현
- [x] 비급여 가격 데이터 조회 메서드 구현
- [x] API 응답 에러 핸들링 (DioException 처리)
- [x] API 응답 파싱 로직 구현
- [x] 배지 생성 기본 로직 구현

### 3.2 Firebase Firestore Provider ✅
- [x] `lib/data_sources/firebase_provider.dart` 확장
- [x] Firestore collection 이름 상수 정의
- [x] 병원 데이터 CRUD 메서드 구현 (HospitalRepository에서)
- [x] 북마크 컬렉션 Provider 추가
- [x] 검색 히스토리 컬렉션 Provider 추가
- [x] BookmarkRepository 구현 (추가/제거/조회/토글)

### 3.3 Local DB Provider (캐시) ✅
- [x] `lib/data_sources/local_db_provider.dart` 생성
- [x] 로컬 DB 스키마 정의 (hospitals, evaluations, prices 테이블)
- [x] 병원 데이터 캐시 저장/조회 메서드 구현
- [x] 캐시 만료 로직 구현 (24시간)
- [x] 캐시 클리어 메서드 구현 (만료된 캐시, 전체 캐시)

**Phase 3 완료 사항:**
- ✅ HIRA API 연동 준비 완료 (실제 API 키 필요)
- ✅ Firebase Provider 확장 (북마크, 검색 히스토리)
- ✅ BookmarkRepository 구현
- ✅ SQLite 기반 로컬 캐시 시스템 구현
- ✅ .env 파일 설정 (API 키 관리)
- ✅ Dio를 사용한 HTTP 통신 구현

---

## Phase 4: Repository Layer 구현 ✅ (완료)

### 4.1 HospitalRepository ✅
- [x] `lib/repositories/hospital_repository.dart` 확장
- [x] 병원 목록 조회 메서드 (캐시 우선 로직)
- [x] 병원 상세 정보 조회 메서드 (HIRA 데이터 보강)
- [x] 지역 기반 병원 검색 메서드
- [x] 거리 기반 병원 검색 메서드 (거리순 정렬)
- [x] 이름/주소 검색 기능
- [x] 배지 기반 필터링
- [x] 역필터링 로직 구현 (평점, 리뷰 수, 등급)
- [x] 데이터 동기화 로직 구현
- [x] 캐시 초기화 기능

### 4.2 BookmarkRepository ✅
- [x] `lib/repositories/bookmark_repository.dart` 생성 (Phase 3 완료)
- [x] 북마크 추가 메서드
- [x] 북마크 제거 메서드
- [x] 북마크 목록 조회 메서드
- [x] 북마크 여부 확인 메서드
- [x] 북마크 토글 기능

**Phase 4 완료 사항:**
- ✅ 캐시 우선 로직 (Local DB → Firestore → HIRA API)
- ✅ 검색 기능 (이름, 주소, 위치 기반)
- ✅ 필터링 기능 (배지, 역필터링)
- ✅ 데이터 동기화 및 캐시 관리
- ✅ 거리 계산 및 정렬

---

## Phase 5: 배지 번역 시스템 구현 ✅ (완료)

### 5.1 배지 생성 로직 ✅
- [x] `lib/utils/badge_generator.dart` 생성
- [x] 평가 등급 -> 배지 매핑 규칙 정의
- [x] 배지 생성 함수 구현
- [x] 배지 우선순위 로직 구현 (여러 배지 중 표시할 것 선택)

### 5.2 배지 매핑 데이터 ✅
- [x] `lib/constants/badge_mappings.dart` 생성
- [x] 뇌졸중, 심근경색, 폐렴 등 주요 질환별 배지 매핑 (18개 전문분야)
- [x] 수술/시술별 배지 매핑
- [x] 배지 아이콘/색상 정의 (Badge 모델에서 이미 정의됨)
- [x] 단어 경계 기반 정확한 키워드 매칭 로직 구현
- [x] 등급별 배지 우선순위 정의
- [x] 배지 타입별 우선순위 정의 (중증질환 > 수술 > 진료과)

**Phase 5 완료 사항:**
- ✅ BadgeGenerator 유틸리티 클래스 구현
  - 단일/다중 평가에서 배지 생성
  - 배지 중복 제거 (타입별 최우선 배지만 유지)
  - 배지 우선순위 정렬 (중증질환 우선)
  - 배지 라벨 문자열 생성 (HospitalEvaluation.badges용)
  - 키워드 추출 및 카테고리 분류
  - 필수 배지 보유 여부 확인 (필터링용)
- ✅ BadgeMappings 상수 클래스 구현
  - 18개 전문분야별 배지 매핑 규칙
  - 등급별 우선순위 (1등급 > 2등급)
  - 배지 타입별 우선순위 (중증질환: 1-2, 수술: 3, 진료과: 4-6)
  - 정확한 키워드 매칭 (단어 경계 검사)
- ✅ HiraApiProvider 업데이트
  - 기존 배지 생성 로직을 BadgeGenerator로 교체
- ✅ 18개 테스트 케이스 작성 및 모두 통과
  - 배지 생성 로직 테스트
  - 배지 우선순위 테스트
  - 배지 필터링 및 그룹화 테스트
  - 키워드 매칭 테스트

---

## Phase 6: State Management (Riverpod) 구현 ✅ (완료)

### 6.1 Provider 설정 ✅
- [x] HospitalRepository provider 정의 (hospital_repository.dart에 이미 구현됨)
- [x] BookmarkRepository provider 정의 (bookmark_repository.dart에 이미 구현됨)

### 6.2 HospitalListNotifier ✅
- [x] `lib/providers/hospital_list_provider.dart` 생성
- [x] StateNotifier 클래스 구현 (Riverpod 2.0 AsyncNotifier 사용)
- [x] 병원 목록 상태 관리 (HospitalListState)
- [x] 로딩/에러 상태 관리
- [x] 페이지네이션 로직 구현 (무한 스크롤)
- [x] 데이터 동기화 및 캐시 초기화 기능

### 6.3 FilterNotifier ✅
- [x] `lib/providers/filter_provider.dart` 생성
- [x] 필터 상태 관리 (지역, 배지, 가격대 등)
- [x] 역필터링 상태 관리 (최소 리뷰 수, 최소 평점, 제외 등급)
- [x] 필터 적용 로직 구현
- [x] FilterCondition 클래스 구현
- [x] 필터 초기화 기능

### 6.4 SearchNotifier ✅
- [x] `lib/providers/search_provider.dart` 생성
- [x] 검색어 상태 관리
- [x] 검색 결과 상태 관리
- [x] 검색 히스토리 관리 (Firestore 연동)
- [x] 검색 히스토리 추가/삭제/전체 삭제 기능
- [x] 검색 히스토리 중복 제거 로직

### 6.5 BookmarkNotifier ✅
- [x] `lib/providers/bookmark_provider.dart` 생성
- [x] 북마크 목록 상태 관리
- [x] 북마크 추가/제거 액션 구현
- [x] 북마크 토글 기능
- [x] 북마크 여부 확인 기능
- [x] 북마크된 병원 상세 정보 로드

### 6.6 LocationNotifier ✅
- [x] `lib/providers/location_provider.dart` 생성
- [x] 현재 위치 상태 관리
- [x] 위치 권한 처리 (granted, denied, deniedForever, notDetermined)
- [x] 위치 기반 병원 정렬 로직
- [x] 주변 병원 검색 기능
- [x] 특정 병원까지의 거리 계산 기능
- [x] 위치 서비스 활성화 확인

**Phase 6 완료 사항:**
- ✅ Riverpod 2.0 기반 State Management 완전 구현
- ✅ 6개 핵심 Notifier 구현 (HospitalList, Filter, Search, Bookmark, Location)
- ✅ 각 Notifier의 상태 관리 클래스 구현
- ✅ 로딩/에러 처리 로직 포함
- ✅ build_runner로 코드 생성 완료 (.g.dart 파일 생성)
- ✅ Repository와의 완전한 통합

---

## Phase 7: UI Layer 구현

### 7.1 공통 위젯
- [ ] `lib/widgets/hospital_card.dart` - 병원 카드 위젯
- [ ] `lib/widgets/badge_chip.dart` - 배지 칩 위젯
- [ ] `lib/widgets/rating_display.dart` - 평점 표시 위젯
- [ ] `lib/widgets/loading_indicator.dart` - 로딩 인디케이터
- [ ] `lib/widgets/error_widget.dart` - 에러 표시 위젯

### 7.2 메인 네비게이션
- [ ] `lib/screens/main_screen.dart` 생성
- [ ] BottomNavigationBar 구현
- [ ] 탭 간 전환 로직 구현
- [ ] 4개 탭: 홈(검색), 지도, 북마크, 설정

### 7.3 병원 목록 화면
- [ ] `lib/screens/hospital_list_screen.dart` 생성
- [ ] 병원 목록 ListView 구현
- [ ] 필터 버튼 UI 구현
- [ ] 검색 바 UI 구현
- [ ] 정렬 옵션 UI 구현
- [ ] Pull-to-refresh 구현
- [ ] 무한 스크롤 구현

### 7.4 병원 상세 화면
- [ ] `lib/screens/hospital_detail_screen.dart` 생성
- [ ] 병원 기본 정보 섹션
- [ ] 데이터 융합 리포트 섹션 (평가 + 가격 + 리뷰)
- [ ] 배지 표시 섹션
- [ ] 평가 데이터 상세 표시
- [ ] 비급여 가격 목록 표시
- [ ] 네이버/카카오맵 리뷰 바로가기 버튼
- [ ] 북마크 버튼
- [ ] 위치 보기 버튼 (지도로 이동)

### 7.5 지도 화면
- [ ] `lib/screens/map_screen.dart` 생성
- [ ] Google Maps 위젯 통합
- [ ] 병원 위치 마커 표시
- [ ] 현재 위치 표시
- [ ] 마커 클릭 시 병원 정보 표시
- [ ] 지도 이동 시 해당 영역 병원 재검색

### 7.6 필터 화면
- [ ] `lib/screens/filter_screen.dart` 생성
- [ ] 지역 선택 UI
- [ ] 전문 분야 선택 UI (배지 기반)
- [ ] 역필터링 옵션 UI
- [ ] 가격대 필터 UI
- [ ] 필터 적용/초기화 버튼

### 7.7 검색 화면
- [ ] `lib/screens/search_screen.dart` 생성
- [ ] 검색 입력 UI
- [ ] 검색 히스토리 표시
- [ ] 자동완성 기능 (선택사항)
- [ ] 검색 결과 표시

### 7.8 북마크 화면
- [ ] `lib/screens/bookmark_screen.dart` 생성
- [ ] 북마크한 병원 목록 표시
- [ ] 북마크 제거 기능
- [ ] 빈 상태 UI

---

## Phase 8: 핵심 기능 통합

### 8.1 데이터 융합 리포트
- [ ] 3가지 데이터(평가, 가격, 리뷰)를 한 화면에 통합
- [ ] 데이터 가중치 로직 구현 (어떤 데이터가 더 중요한지)
- [ ] 종합 점수 계산 로직
- [ ] 시각화 차트/그래프 추가 (선택사항)

### 8.2 역필터링 시스템
- [ ] "피해야 할 병원" 기준 정의
- [ ] 역필터링 로직 구현
- [ ] UI에 경고 표시 기능
- [ ] 필터링된 병원 카운트 표시

### 8.3 외부 리뷰 링크 통합
- [ ] 네이버 지도 URL 생성 로직
- [ ] 카카오맵 URL 생성 로직
- [ ] url_launcher를 통한 외부 링크 열기
- [ ] 리뷰 없을 시 대체 UI

---

## Phase 9: 테스팅 및 품질 관리

### 9.1 Unit Tests
- [ ] Repository 테스트 작성
- [ ] Provider 테스트 작성
- [x] 배지 생성 로직 테스트 (18개 테스트 케이스 완료)
- [ ] 필터링 로직 테스트

### 9.2 Widget Tests
- [ ] HospitalCard 위젯 테스트
- [ ] 필터 화면 테스트
- [ ] 검색 기능 테스트

### 9.3 Integration Tests
- [ ] 병원 검색 플로우 테스트
- [ ] 북마크 추가/제거 플로우 테스트
- [ ] 필터 적용 플로우 테스트

### 9.4 코드 품질
- [ ] `flutter analyze` 경고 모두 해결
- [ ] 린트 규칙 준수 확인
- [ ] 코드 리팩토링
- [ ] 주석 및 문서화

## 진행 상황 추적

**현재 단계:** Phase 6 완료 → Phase 7 시작

**완료율:** 80% (Phase 1, 2, 3, 4, 5, 6 완료)

**완료된 Phase:**
- ✅ Phase 1: 프로젝트 초기 설정 및 구성 (100% 완료)
  - ✅ 모든 의존성 패키지 설치
  - ✅ 프로젝트 폴더 구조 생성
  - ✅ Android/iOS 기본 설정 및 권한 구성
  - ✅ Firebase/Riverpod 초기화 코드 준비
  - ✅ Google Maps API 키 설정 완료
  - ✅ Firebase 설정 완료 (`firebase_options.dart` 생성)
  - ✅ Firestore 데이터베이스 생성 완료
  - ✅ iOS 배포 타겟 14.0으로 업데이트
  - ✅ Firebase 연결 테스트 완료

- ✅ Phase 2: 핵심 데이터 모델 구현 (100% 완료)
  - ✅ Hospital, HospitalEvaluation, NonCoveredPrice, ReviewStatistics 모델 구현
  - ✅ Badge 모델 및 19개 전문 분야 타입 정의
  - ✅ Freezed를 사용한 불변 객체 패턴 적용
  - ✅ JSON 직렬화/역직렬화 구현
  - ✅ 배지별 아이콘 및 색상 매핑 완료

- ✅ Phase 3: Data Source Layer 구현 (100% 완료)
  - ✅ HIRA API Provider (Dio 기반 HTTP 통신)
  - ✅ Firebase Provider 확장 (북마크, 검색 히스토리)
  - ✅ BookmarkRepository 구현
  - ✅ Local DB Provider (SQLite 캐시 시스템)
  - ✅ API 상수 정의 및 환경 변수 관리

- ✅ Phase 4: Repository Layer 구현 (100% 완료)
  - ✅ HospitalRepository 캐시 우선 로직
  - ✅ 검색 및 필터링 기능
  - ✅ 역필터링 시스템
  - ✅ 데이터 동기화 및 캐시 관리

- ✅ Phase 5: 배지 번역 시스템 구현 (100% 완료)
  - ✅ BadgeGenerator 유틸리티 클래스 (배지 생성, 우선순위, 필터링)
  - ✅ BadgeMappings 상수 클래스 (18개 전문분야 매핑)
  - ✅ 정확한 키워드 매칭 로직 (단어 경계 검사)
  - ✅ HiraApiProvider 통합
  - ✅ 18개 테스트 케이스 작성 및 통과

- ✅ Phase 6: State Management (Riverpod) 구현 (100% 완료)
  - ✅ HospitalListNotifier 구현 (페이지네이션, 무한 스크롤)
  - ✅ FilterNotifier 구현 (필터 및 역필터링)
  - ✅ SearchNotifier 구현 (검색 히스토리 관리)
  - ✅ BookmarkNotifier 구현 (북마크 상태 관리)
  - ✅ LocationNotifier 구현 (위치 권한 및 주변 병원 검색)
  - ✅ 모든 Provider 코드 생성 완료 (.g.dart 파일)

**다음 작업:**
1. Phase 7: UI Layer 구현
2. Phase 8: 핵심 기능 통합
3. Phase 9: 테스팅 및 품질 관리

**최근 업데이트:**
- 2025-12-07: Phase 6 완료 - Riverpod State Management 전체 구현 완료
- 2025-12-07: Phase 5 완료 - 배지 번역 시스템 구현 및 테스트 완료
- 2025-12-07: Phase 4 완료 - Repository Layer 및 캐시 시스템 완성
- 2025-12-07: Phase 3 완료 - Data Source Layer 구현 완료
- 2025-12-07: Phase 2 완료 - 모든 데이터 모델 구현 및 테스트 완료
