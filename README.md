# 메디게이션 (Medigation)

**데이터로 찾는 진짜 좋은 병원** - Medical + Navigation

병원 평가, 비급여 가격, 리뷰 데이터를 융합하여 사용자가 정보에 기반한 병원 선택을 할 수 있도록 돕는 Flutter 앱입니다.

## 주요 기능

### 1. 데이터 융합 리포트
- **3가지 핵심 데이터 통합**: 건강보험심사평가원 평가 데이터(40%) + 리뷰 통계(40%) + 전문 분야 배지(20%)
- **종합 점수 시스템**: 0-100점, S/A/B/C/D 등급
- **데이터 완성도 측정**: 신뢰도 평가

### 2. 배지 번역 시스템
- 어려운 평가 데이터를 직관적인 배지로 번역
- 예: "급성기 뇌졸중 적정성 평가 1등급" → [뇌졸중 수술 전문] 배지
- 18개 전문 분야 배지 지원

### 3. 역필터링
- **피해야 할 병원** 자동 판단
- 4가지 경고 유형: 낮은 평점, 적은 리뷰, 낮은 등급, 데이터 부족
- 3단계 심각도 분류 (HIGH/MEDIUM/LOW)

### 4. 외부 리뷰 연동
- 네이버 지도, 카카오맵, Google Maps 바로가기
- 앱 우선 실행, 실패 시 웹 fallback

### 5. 위치 기반 검색
- 현재 위치 기반 주변 병원 검색
- 거리 표시 및 정렬
- Google Maps 통합

## 기술 스택

- **Framework**: Flutter 3.x
- **State Management**: Riverpod 2.0
- **Database**: Firebase Firestore (클라우드), SQLite (로컬 캐시)
- **Maps**: Google Maps Flutter
- **API**: HIRA API (건강보험심사평가원)
- **Architecture**: Clean Architecture (UI → State → Repository → Data Source)

## 시작하기

### 1. 사전 요구사항

- Flutter SDK 3.x 이상
- Dart SDK 3.x 이상
- Android Studio / Xcode (각 플랫폼별)
- Firebase 계정
- Google Cloud Console 계정 (Maps API)
- 공공데이터포털 계정 (HIRA API)

### 2. API 키 발급

#### Google Maps API
1. [Google Cloud Console](https://console.cloud.google.com/google/maps-apis) 접속
2. Maps SDK for Android 및 iOS 활성화
3. API 키 발급

#### HIRA API (건강보험심사평가원)
1. [공공데이터포털](https://www.data.go.kr) 접속 및 회원가입
2. 다음 API 검색 및 활용신청:
   - **병원평가정보서비스** (적정성 평가 결과)
   - **비급여진료비정보서비스** (비급여 항목 및 가격)
3. 승인 후 서비스 키 발급 (즉시~1일 소요)

### 3. 프로젝트 설정

```bash
# 1. 저장소 클론
git clone <repository-url>
cd medigation

# 2. 의존성 패키지 설치
flutter pub get

# 3. 환경 변수 설정
cp .env.example .env
# .env 파일을 열어 다음 키들을 설정:
# - GOOGLE_MAPS_API_KEY (Google Cloud Console에서 발급)
# - HIRA_API_KEY (공공데이터포털에서 발급)

# 4. Firebase 설정
flutterfire configure --project=medigation-773ab

# 5. 코드 생성
flutter pub run build_runner build --delete-conflicting-outputs

# 6. 실행
flutter run
```

### 4. Firebase 설정

Firebase Console에서 Firestore 데이터베이스를 생성하고 다음 컬렉션을 만드세요:
- `hospitals` - 병원 데이터
- `bookmarks` - 북마크
- `search_history` - 검색 히스토리

**Firestore 규칙 예시**:
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true; // 테스트용 (프로덕션에서는 인증 필요)
    }
  }
}
```

## 프로젝트 구조

```
lib/
├── models/              # 데이터 모델 (Freezed)
├── data_sources/        # API 및 DB 통신
│   ├── hira_api_provider.dart
│   ├── firebase_provider.dart
│   └── local_db_provider.dart
├── repositories/        # 데이터 추상화 계층
│   ├── hospital_repository.dart
│   └── bookmark_repository.dart
├── providers/           # Riverpod State Notifiers
│   ├── hospital_list_provider.dart
│   ├── filter_provider.dart
│   ├── search_provider.dart
│   ├── bookmark_provider.dart
│   └── location_provider.dart
├── screens/             # UI 화면
│   ├── main_screen.dart
│   ├── hospital_list_screen.dart
│   ├── hospital_detail_screen.dart
│   ├── map_screen.dart
│   ├── filter_screen.dart
│   ├── search_screen.dart
│   └── bookmark_screen.dart
├── widgets/             # 재사용 가능한 위젯
├── utils/               # 유틸리티 클래스
│   ├── badge_generator.dart
│   ├── hospital_score_calculator.dart
│   ├── hospital_warning_checker.dart
│   └── review_link_generator.dart
└── constants/           # 상수 정의
```

## 개발 진행 상황

현재 **Phase 8 완료** (97% 완료)

- ✅ Phase 1: 프로젝트 초기 설정
- ✅ Phase 2: 데이터 모델 구현
- ✅ Phase 3: Data Source Layer
- ✅ Phase 4: Repository Layer
- ✅ Phase 5: 배지 번역 시스템
- ✅ Phase 6: State Management (Riverpod)
- ✅ Phase 7: UI Layer (8개 화면, 5개 위젯)
- ✅ Phase 8: 핵심 기능 통합 (데이터 융합, 역필터링, 외부 리뷰)
- 🔄 Phase 9: 테스팅 및 품질 관리 (진행 예정)

자세한 개발 계획은 [DEVELOPMENT_PLAN.md](DEVELOPMENT_PLAN.md) 참고

## 주요 알고리즘

### 종합 점수 계산
```dart
총점 = (평가점수 × 0.4) + (리뷰점수 × 0.4) + (배지점수 × 0.2)

- 평가점수: 1등급=100점, 2등급=80점, 3등급=60점, 4등급=40점, 5등급=20점
- 리뷰점수: (별점/5 × 100) + 리뷰개수 보너스 (최대 10점)
- 배지점수: 배지 개수 점수 + 중증질환 전문 보너스
```

### 역필터링 기준
- 평균 평점 < 3.0 → 높은 경고 (HIGH)
- 리뷰 개수 < 5개 → 중간 경고 (MEDIUM)
- 평가 등급 4~5등급 포함 → 높은 경고 (HIGH)
- 평가 및 리뷰 데이터 부족 → 중간 경고 (MEDIUM)

## 라이선스

이 프로젝트는 교육 및 포트폴리오 목적으로 만들어졌습니다.

## 기여

이슈 및 풀 리퀘스트를 환영합니다!

## 문의

프로젝트 관련 문의사항은 이슈를 등록해주세요.
