프로젝트 주제	
- 메디게이션 : 데이터로 찾는 진짜 좋은 병원(medical + navigation)

핵심 기능 요약(MVP)
- 데이터 융합 리포트
  - 평가API(팩트), 비급여 가격(가격), 네이버 평점(경험) 3가지 핵심 정보를 한 화면에서 제공
  - 사용자가 직접 데이터를 찾아 해석할 필요 없이, 가공된 '종합리포트'를 제공
- 데이터 번역 ‘배지’ 시스템
  - 어려운 평가 데이터를 사용자가 직관적으로 이해할 수 있는 ‘배지’로 번역
  - 급성기 뇌졸중 적정성 평가 1등급 -> [뇌졸중 수술 전문]
- ‘역필터링’ 기반 스마트 검색
  - 피해야 할 병원을 거를 수 있는 필터링 기능을 제공

목표 및 기대효과 
- 공공데이터와 분산된 포털 리뷰 데이터를 융합하여 사용자의 실제적인 병원 선택 의사결정을 도울 수 있다.

기술 스택 상세 명세
- 프레임워크 : Flutter
- 상태관리 : Riverpod
- DB : Firebase Firestore
- 지도 : Maps_flutter
- 공공데이터 API 통신 : http 

시스템 구조도	
-  UI (Presentation Layer) ]  <-- (Flutter Widgets)
 |  (HospitalListScreen, HospitalDetailScreen)
 |  (사용자 이벤트 발생 -> Notifier 호출)
 V
   [ State (State Notifier Layer) ] <-- (Business Logic)
 |  (HospitalListNotifier, FilterNotifier)
 |  (로직 처리, 상태 변경 -> UI에 통보)
 |  (데이터 필요시 Repository에 요청)
 V
   [ Repository (Data Abstraction Layer) ]
 |  (HospitalRepository, BookmarkRepository)
 |  (StateNotifier에게 데이터 소스를 숨김)
 |  (로컬(SQLite) 캐시 확인 -> 없으면 Remote(API) 요청)
 V
   [ Data Source (Data Layer) ]
 |  (HiraApiProvider, FirebaseProvider, LocalDbProvider)
 |  (실제 DB 및 API와 통신)


핵심 데이터 모델 정의	
- 병원: 병원 ID, 병원 이름, 주소, 위도, 경도, 병원 평가 목록, 비급여 가격 목록, 리뷰 통계)
- 병원 평가: 평가 항목, 평가 등급, 생성된 배지 목록
- 비급여 가격: 비급여 항목, 가격
- 리뷰 통계 : 평균 별점, 총 리뷰 개수, 주요 리뷰 키워드 목록

위험 관리	
- 포털 리뷰 데이터 수집 (크롤링)
- 문제: 네이버/카카오맵의 리뷰를 크롤링하는 것은 정책적으로 막혀있거나(어뷰징 방지) 구조가 자주 변경되어 안정적인 수급이 어려움
- 대응:링크 제공: 앱 내에서 해당 병원의 네이버/카카오맵 리뷰 페이지로 바로 이동하는 '바로가기' 버튼을 제공하여 사용자가 직접 확인하도록 유도