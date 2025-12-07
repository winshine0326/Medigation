import '../models/badge.dart';

/// 건강보험심사평가원 평가 항목별 배지 매핑
/// 평가 항목명과 등급에 따라 적절한 배지를 생성하는 규칙 정의
class BadgeMappings {
  /// 평가 항목 키워드 -> 배지 타입 매핑
  static final Map<String, BadgeMapping> evaluationMappings = {
    // 뇌졸중 관련
    '뇌졸중': BadgeMapping(
      type: BadgeType.stroke,
      label: '뇌졸중 전문',
      description: '뇌졸중 치료에 우수한 평가를 받았습니다',
      keywords: ['뇌졸중', '급성기 뇌졸중'],
    ),

    // 심근경색 관련
    '심근경색': BadgeMapping(
      type: BadgeType.heartAttack,
      label: '심근경색 전문',
      description: '심근경색 치료에 우수한 평가를 받았습니다',
      keywords: ['심근경색', '급성 심근경색'],
    ),

    // 폐렴 관련
    '폐렴': BadgeMapping(
      type: BadgeType.pneumonia,
      label: '폐렴 치료 전문',
      description: '폐렴 치료에 우수한 평가를 받았습니다',
      keywords: ['폐렴', '호흡기'],
    ),

    // 수술 관련
    '수술': BadgeMapping(
      type: BadgeType.surgery,
      label: '수술 전문',
      description: '수술 분야에서 우수한 평가를 받았습니다',
      keywords: ['수술', '외과', '시술'],
    ),

    // 응급 관련
    '응급': BadgeMapping(
      type: BadgeType.emergency,
      label: '응급 치료 전문',
      description: '응급 치료에 우수한 평가를 받았습니다',
      keywords: ['응급', '중증'],
    ),

    // 산부인과 관련
    '제왕절개': BadgeMapping(
      type: BadgeType.maternity,
      label: '산부인과 전문',
      description: '산부인과 분야에서 우수한 평가를 받았습니다',
      keywords: ['제왕절개', '분만', '산부인과'],
    ),

    // 소아과 관련
    '소아': BadgeMapping(
      type: BadgeType.pediatrics,
      label: '소아과 전문',
      description: '소아 진료에 우수한 평가를 받았습니다',
      keywords: ['소아', '아동', '어린이'],
    ),

    // 정형외과 관련
    '정형외과': BadgeMapping(
      type: BadgeType.orthopedics,
      label: '정형외과 전문',
      description: '정형외과 분야에서 우수한 평가를 받았습니다',
      keywords: ['정형외과', '골절', '관절', '척추'],
    ),

    // 치과 관련
    '치과': BadgeMapping(
      type: BadgeType.dentistry,
      label: '치과 전문',
      description: '치과 진료에 우수한 평가를 받았습니다',
      keywords: ['치과', '구강', '임플란트'],
    ),

    // 피부과 관련
    '피부과': BadgeMapping(
      type: BadgeType.dermatology,
      label: '피부과 전문',
      description: '피부과 진료에 우수한 평가를 받았습니다',
      keywords: ['피부과', '피부'],
    ),

    // 안과 관련
    '안과': BadgeMapping(
      type: BadgeType.ophthalmology,
      label: '안과 전문',
      description: '안과 진료에 우수한 평가를 받았습니다',
      keywords: ['안과', '눈', '백내장', '시력'],
    ),

    // 이비인후과 관련
    '이비인후과': BadgeMapping(
      type: BadgeType.ent,
      label: '이비인후과 전문',
      description: '이비인후과 진료에 우수한 평가를 받았습니다',
      keywords: ['이비인후과', '귀', '코', '목'],
    ),

    // 정신과 관련
    '정신': BadgeMapping(
      type: BadgeType.psychiatry,
      label: '정신건강 전문',
      description: '정신건강 진료에 우수한 평가를 받았습니다',
      keywords: ['정신', '우울', '불안', '정신건강'],
    ),

    // 심장내과 관련
    '심장': BadgeMapping(
      type: BadgeType.cardiology,
      label: '심장내과 전문',
      description: '심장 질환 치료에 우수한 평가를 받았습니다',
      keywords: ['심장', '순환기', '고혈압', '부정맥'],
    ),

    // 신경과 관련
    '신경과': BadgeMapping(
      type: BadgeType.neurology,
      label: '신경과 전문',
      description: '신경과 진료에 우수한 평가를 받았습니다',
      keywords: ['신경과', '두통', '어지럼증'],
    ),

    // 종양학 관련
    '암': BadgeMapping(
      type: BadgeType.oncology,
      label: '암 치료 전문',
      description: '암 치료에 우수한 평가를 받았습니다',
      keywords: ['암', '종양', '항암'],
    ),

    // 비뇨기과 관련
    '비뇨기': BadgeMapping(
      type: BadgeType.urology,
      label: '비뇨기과 전문',
      description: '비뇨기과 진료에 우수한 평가를 받았습니다',
      keywords: ['비뇨기', '전립선', '신장'],
    ),

    // 소화기내과 관련
    '소화기': BadgeMapping(
      type: BadgeType.gastroenterology,
      label: '소화기내과 전문',
      description: '소화기 질환 치료에 우수한 평가를 받았습니다',
      keywords: ['소화기', '위', '장', '간', '내시경'],
    ),
  };

  /// 등급별 배지 생성 우선순위 (낮을수록 우선)
  static final Map<String, int> gradePriority = {
    '1등급': 1,
    '2등급': 2,
    '3등급': 3,
    '4등급': 4,
    '5등급': 5,
  };

  /// 배지 타입별 우선순위 (낮을수록 우선)
  /// 주요 질환/수술 > 일반 진료과
  static final Map<BadgeType, int> typePriority = {
    // 중증 질환 (최우선)
    BadgeType.stroke: 1,
    BadgeType.heartAttack: 1,
    BadgeType.oncology: 1,
    BadgeType.emergency: 2,

    // 수술/치료 분야
    BadgeType.surgery: 3,
    BadgeType.pneumonia: 3,

    // 진료과
    BadgeType.cardiology: 4,
    BadgeType.neurology: 4,
    BadgeType.orthopedics: 5,
    BadgeType.maternity: 5,
    BadgeType.pediatrics: 5,
    BadgeType.gastroenterology: 5,
    BadgeType.urology: 5,
    BadgeType.ent: 6,
    BadgeType.ophthalmology: 6,
    BadgeType.dermatology: 6,
    BadgeType.dentistry: 6,
    BadgeType.psychiatry: 6,

    // 일반
    BadgeType.general: 99,
  };

  /// 평가 항목에서 키워드 추출 및 매핑 찾기
  static BadgeMapping? findMapping(String evaluationItem) {
    final lowerItem = evaluationItem.toLowerCase();

    // 정확한 키워드 매칭을 위해 우선순위 기반 검색
    // 긴 키워드부터 검사하여 부분 매칭 문제 방지
    for (final entry in evaluationMappings.entries) {
      final mapping = entry.value;

      // 키워드를 길이 순으로 정렬 (긴 키워드 우선)
      final sortedKeywords = List<String>.from(mapping.keywords)
        ..sort((a, b) => b.length.compareTo(a.length));

      for (final keyword in sortedKeywords) {
        final lowerKeyword = keyword.toLowerCase();

        // 단어 경계를 고려한 매칭
        // 키워드가 공백이나 특수문자로 둘러싸여 있거나, 문자열 시작/끝에 있어야 함
        if (lowerItem.contains(lowerKeyword)) {
          final index = lowerItem.indexOf(lowerKeyword);

          // 앞뒤 문자 확인
          final beforeChar = index > 0 ? lowerItem[index - 1] : ' ';
          final afterIndex = index + lowerKeyword.length;
          final afterChar = afterIndex < lowerItem.length
              ? lowerItem[afterIndex]
              : ' ';

          // 한글 키워드는 완전 일치만 허용 (부분 매칭 방지)
          final isKorean = RegExp(r'[ㄱ-ㅎㅏ-ㅣ가-힣]').hasMatch(lowerKeyword);
          if (isKorean) {
            // 앞뒤가 공백이거나 특수문자인 경우만 매칭
            final beforeIsValid = beforeChar == ' ' ||
                beforeChar == ',' ||
                beforeChar == '(' ||
                index == 0;
            final afterIsValid = afterChar == ' ' ||
                afterChar == ',' ||
                afterChar == ')' ||
                afterIndex == lowerItem.length;

            if (beforeIsValid && afterIsValid) {
              return mapping;
            }
          } else {
            // 영문 키워드는 기존 로직 유지
            return mapping;
          }
        }
      }
    }

    return null;
  }

  /// 등급이 배지 생성 기준을 충족하는지 확인
  /// 1~2등급만 배지 생성
  static bool isQualifiedGrade(String grade) {
    return grade.contains('1등급') || grade.contains('2등급');
  }

  /// 등급에 따른 배지 라벨 수식어 반환
  /// 1등급: "우수", 2등급: "" (수식어 없음)
  static String getGradeModifier(String grade) {
    if (grade.contains('1등급')) {
      return '우수 ';
    }
    return '';
  }
}

/// 배지 매핑 정보
class BadgeMapping {
  final BadgeType type;
  final String label;
  final String description;
  final List<String> keywords;

  const BadgeMapping({
    required this.type,
    required this.label,
    required this.description,
    required this.keywords,
  });

  /// 등급에 따라 라벨을 수정한 Badge 객체 생성
  Badge createBadge(String grade) {
    final modifier = BadgeMappings.getGradeModifier(grade);
    final finalLabel = '$modifier$label';

    return Badge(
      type: type,
      label: finalLabel,
      description: description,
    );
  }
}
