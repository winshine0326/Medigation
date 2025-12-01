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

### 1.2 Firebase 설정 ⚠️ (수동 설정 필요)
- [ ] **[수동 필요]** Firebase 프로젝트 생성 (https://console.firebase.google.com)
- [ ] **[수동 필요]** Android용 Firebase 설정 (`google-services.json` 다운로드 및 `android/app/`에 배치)
- [ ] **[수동 필요]** iOS용 Firebase 설정 (`GoogleService-Info.plist` 다운로드 및 `ios/Runner/`에 배치)
- [x] Firebase 초기화 코드 작성 (`main.dart` - Firebase 설정 후 주석 해제 필요)
- [ ] **[수동 필요]** Firestore 데이터베이스 생성 및 규칙 설정

### 1.3 Google Maps API 설정 ✅
- [x] Google Cloud Console에서 Maps SDK for Android 활성화
- [x] Google Cloud Console에서 Maps SDK for iOS 활성화
- [x] API 키 발급 완료
- [x] Android `AndroidManifest.xml`에 API 키 추가 완료
- [x] iOS `AppDelegate.swift`에 API 키 추가 완료
- [x] iOS `Info.plist`에 위치 권한 설명 추가
- [x] Android 권한 설정 완료

### 1.4 프로젝트 폴더 구조 생성 ✅
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

**Firebase 설정 가이드 (수동 작업 필요):**
1. 터미널에서 다음 명령 실행:
   ```bash
   flutterfire configure --project=medigation-773ab
   ```
2. 플랫폼 선택 시 `android`와 `ios`만 선택 (Space로 선택/해제, Enter로 확인)
3. 설정 완료 후 `lib/firebase_options.dart` 파일이 자동 생성됨
4. `lib/main.dart`에서 Firebase 초기화 주석 해제:
   ```dart
   await Firebase.initializeApp(
     options: DefaultFirebaseOptions.currentPlatform,
   );
   ```
5. Firebase Console에서 Firestore 데이터베이스 생성 및 규칙 설정

---

## Phase 2: 핵심 데이터 모델 구현

### 2.1 Hospital 모델
- [ ] `lib/models/hospital.dart` 생성
- [ ] Hospital 클래스 정의 (id, name, address, latitude, longitude)
- [ ] `fromJson`, `toJson` 메서드 구현
- [ ] 병원 평가 목록 필드 추가
- [ ] 비급여 가격 목록 필드 추가
- [ ] 리뷰 통계 필드 추가

### 2.2 HospitalEvaluation 모델
- [ ] `lib/models/hospital_evaluation.dart` 생성
- [ ] HospitalEvaluation 클래스 정의 (평가 항목, 평가 등급)
- [ ] 생성된 배지 목록 필드 추가
- [ ] `fromJson`, `toJson` 메서드 구현

### 2.3 NonReimbursementPrice 모델
- [ ] `lib/models/non_reimbursement_price.dart` 생성
- [ ] NonReimbursementPrice 클래스 정의 (항목명, 가격)
- [ ] `fromJson`, `toJson` 메서드 구현

### 2.4 ReviewStatistics 모델
- [ ] `lib/models/review_statistics.dart` 생성
- [ ] ReviewStatistics 클래스 정의 (평균 별점, 총 리뷰 개수)
- [ ] 주요 리뷰 키워드 목록 필드 추가
- [ ] `fromJson`, `toJson` 메서드 구현

### 2.5 Badge 모델
- [ ] `lib/models/badge.dart` 생성
- [ ] Badge 클래스 정의 (badge type, label, icon)
- [ ] 배지 타입 enum 정의 (전문 분야별)
- [ ] `fromJson`, `toJson` 메서드 구현

---

## Phase 3: Data Source Layer 구현

### 3.1 HIRA API Provider (건강보험심사평가원)
- [ ] `lib/data_sources/hira_api_provider.dart` 생성
- [ ] API 엔드포인트 상수 정의 (`lib/constants/api_constants.dart`)
- [ ] 병원 평가 데이터 조회 메서드 구현
- [ ] 비급여 가격 데이터 조회 메서드 구현
- [ ] API 응답 에러 핸들링
- [ ] API 응답 파싱 로직 구현

### 3.2 Firebase Firestore Provider
- [ ] `lib/data_sources/firebase_provider.dart` 생성
- [ ] Firestore collection 이름 상수 정의
- [ ] 병원 데이터 CRUD 메서드 구현
- [ ] 북마크 데이터 CRUD 메서드 구현
- [ ] 쿼리 메서드 구현 (지역별, 거리별 검색)

### 3.3 Local DB Provider (캐시)
- [ ] `lib/data_sources/local_db_provider.dart` 생성
- [ ] 로컬 DB 스키마 정의
- [ ] 병원 데이터 캐시 저장/조회 메서드 구현
- [ ] 캐시 만료 로직 구현
- [ ] 캐시 클리어 메서드 구현

---

## Phase 4: Repository Layer 구현

### 4.1 HospitalRepository
- [ ] `lib/repositories/hospital_repository.dart` 생성
- [ ] 병원 목록 조회 메서드 (캐시 우선, 없으면 API 호출)
- [ ] 병원 상세 정보 조회 메서드
- [ ] 지역 기반 병원 검색 메서드
- [ ] 거리 기반 병원 검색 메서드
- [ ] 필터링 로직 구현 (역필터링 포함)
- [ ] 데이터 동기화 로직 구현

### 4.2 BookmarkRepository
- [ ] `lib/repositories/bookmark_repository.dart` 생성
- [ ] 북마크 추가 메서드
- [ ] 북마크 제거 메서드
- [ ] 북마크 목록 조회 메서드
- [ ] 북마크 여부 확인 메서드

---

## Phase 5: 배지 번역 시스템 구현

### 5.1 배지 생성 로직
- [ ] `lib/utils/badge_generator.dart` 생성
- [ ] 평가 등급 -> 배지 매핑 규칙 정의
- [ ] 배지 생성 함수 구현
- [ ] 배지 우선순위 로직 구현 (여러 배지 중 표시할 것 선택)

### 5.2 배지 매핑 데이터
- [ ] `lib/constants/badge_mappings.dart` 생성
- [ ] 뇌졸중, 심근경색, 폐렴 등 주요 질환별 배지 매핑
- [ ] 수술/시술별 배지 매핑
- [ ] 배지 아이콘/색상 정의

---

## Phase 6: State Management (Riverpod) 구현

### 6.1 Provider 설정
- [ ] `lib/providers/hospital_provider.dart` 생성
- [ ] HospitalRepository provider 정의
- [ ] BookmarkRepository provider 정의

### 6.2 HospitalListNotifier
- [ ] `lib/providers/hospital_list_provider.dart` 생성
- [ ] StateNotifier 클래스 구현
- [ ] 병원 목록 상태 관리
- [ ] 로딩/에러 상태 관리
- [ ] 페이지네이션 로직 구현

### 6.3 FilterNotifier
- [ ] `lib/providers/filter_provider.dart` 생성
- [ ] 필터 상태 관리 (지역, 전문분야, 가격대 등)
- [ ] 역필터링 상태 관리
- [ ] 필터 적용 로직 구현

### 6.4 SearchNotifier
- [ ] `lib/providers/search_provider.dart` 생성
- [ ] 검색어 상태 관리
- [ ] 검색 결과 상태 관리
- [ ] 검색 히스토리 관리

### 6.5 BookmarkNotifier
- [ ] `lib/providers/bookmark_provider.dart` 생성
- [ ] 북마크 목록 상태 관리
- [ ] 북마크 추가/제거 액션 구현

### 6.6 LocationNotifier
- [ ] `lib/providers/location_provider.dart` 생성
- [ ] 현재 위치 상태 관리
- [ ] 위치 권한 처리
- [ ] 위치 기반 병원 정렬 로직

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
- [ ] 배지 생성 로직 테스트
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

**현재 단계:** Phase 1 완료 (Firebase 설정 제외) → Phase 2 준비

**완료율:** 12% (Phase 1 거의 완료)

**완료된 Phase:**
- ✅ Phase 1: 프로젝트 초기 설정 및 구성 (95% 완료)
  - ✅ 모든 의존성 패키지 설치
  - ✅ 프로젝트 폴더 구조 생성
  - ✅ Android/iOS 기본 설정 및 권한 구성
  - ✅ Firebase/Riverpod 초기화 코드 준비
  - ✅ Google Maps API 키 설정 완료
  - ⚠️ Firebase 설정 (수동 작업 필요 - flutterfire configure 실행)

**다음 작업:**
1. 사용자가 직접 `flutterfire configure --project=medigation-773ab` 실행
2. Phase 2: 핵심 데이터 모델 구현 시작 (Hospital, HospitalEvaluation, Badge 등)

**최근 업데이트:**
- 2025-12-01: Phase 1 대부분 완료 (Google Maps API 키 설정)
- Firebase 설정은 대화형 명령이므로 사용자가 직접 실행 필요
