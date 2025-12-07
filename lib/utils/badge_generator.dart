import '../models/hospital.dart';
import '../constants/badge_mappings.dart';
import '../models/badge.dart';
import '../models/hospital_evaluation.dart';

/// 배지 생성 유틸리티
/// 병원 평가 데이터를 분석하여 사용자가 이해하기 쉬운 배지로 변환
class BadgeGenerator {
  /// 병원 상세 정보를 기반으로 가상의 평가(배지) 목록 생성
  ///
  /// [hospital] 병원 정보 (상세 정보 포함)
  /// Returns: 생성된 HospitalEvaluation 목록
  static List<HospitalEvaluation> generateEvaluationsFromDetailInfo(Hospital hospital) {
    final evaluations = <HospitalEvaluation>[];

    // 1. 특수 진료 정보 -> 배지 변환
    for (final info in hospital.specialDiagnosisInfoList) {
      evaluations.add(HospitalEvaluation(
        evaluationItem: info.searchCodeName,
        grade: '인증', // 가상 등급
        badges: ['${info.searchCodeName} 가능'],
      ));
    }

    // 2. 간호 등급 정보 -> 배지 변환 (1등급만)
    for (final info in hospital.nursingGradeInfoList) {
      if (info.careGrade.contains('1등급')) {
        evaluations.add(HospitalEvaluation(
          evaluationItem: info.typeName,
          grade: '1등급',
          badges: ['최우수 간호 인력'],
        ));
      }
    }

    // 3. 전문의 정보 -> 배지 변환 (5명 이상인 과)
    for (final info in hospital.specialistInfoList) {
      if (info.specialistCount >= 5) {
        evaluations.add(HospitalEvaluation(
          evaluationItem: info.specialtyName,
          grade: '우수',
          badges: ['${info.specialtyName} 전문의 다수 보유'],
        ));
      }
    }

    return evaluations;
  }

  /// 단일 평가 항목에서 배지 생성
  ///
  /// [evaluation] 병원 평가 정보
  /// Returns: 생성된 Badge 객체, 조건 미충족 시 null
  static Badge? generateFromEvaluation(HospitalEvaluation evaluation) {
    // 등급이 1~2등급이 아니면 배지 생성 안 함
    if (!BadgeMappings.isQualifiedGrade(evaluation.grade) && evaluation.grade != '인증' && evaluation.grade != '우수') {
      return null;
    }

    // 평가 항목에서 매핑 찾기
    final mapping = BadgeMappings.findMapping(evaluation.evaluationItem);
    if (mapping == null) {
      // 매핑이 없으면 기본 배지 반환 (상세 정보 기반 생성된 경우)
      if (evaluation.badges.isNotEmpty) {
        return Badge(
          type: BadgeType.specialty,
          label: evaluation.badges.first,
          description: evaluation.evaluationItem,
        );
      }
      return null;
    }

    // 배지 생성
    return mapping.createBadge(evaluation.grade);
  }

  /// 여러 평가 항목에서 배지 목록 생성
  ///
  /// [evaluations] 병원 평가 목록
  /// Returns: 생성된 Badge 목록
  static List<Badge> generateFromEvaluations(
    List<HospitalEvaluation> evaluations,
  ) {
    final badges = <Badge>[];

    for (final evaluation in evaluations) {
      final badge = generateFromEvaluation(evaluation);
      if (badge != null) {
        badges.add(badge);
      }
    }

    return badges;
  }

  /// 여러 배지 중 우선순위가 높은 배지만 선택
  ///
  /// [badges] 배지 목록
  /// [maxCount] 최대 선택 개수 (기본값: 3)
  /// Returns: 우선순위 순으로 정렬된 배지 목록
  static List<Badge> selectTopBadges(
    List<Badge> badges, {
    int maxCount = 3,
  }) {
    if (badges.isEmpty) {
      return [];
    }

    // 배지 타입별로 그룹화하여 중복 제거
    final uniqueBadges = _removeDuplicatesByType(badges);

    // 우선순위 순으로 정렬
    final sortedBadges = _sortByPriority(uniqueBadges);

    // 최대 개수만큼 반환
    return sortedBadges.take(maxCount).toList();
  }

  /// 평가 항목에서 배지 문자열 목록 생성 (HospitalEvaluation.badges 필드용)
  ///
  /// [evaluationItem] 평가 항목명
  /// [grade] 평가 등급
  /// Returns: 배지 라벨 문자열 목록
  static List<String> generateBadgeLabels(
    String evaluationItem,
    String grade,
  ) {
    // 등급이 1~2등급이 아니면 빈 목록 반환
    if (!BadgeMappings.isQualifiedGrade(grade)) {
      return [];
    }

    // 평가 항목에서 매핑 찾기
    final mapping = BadgeMappings.findMapping(evaluationItem);
    if (mapping == null) {
      return [];
    }

    // 배지 생성 후 라벨 반환
    final badge = mapping.createBadge(grade);
    return [badge.label];
  }

  /// 평가 항목명에서 키워드 추출
  ///
  /// [evaluationItem] 평가 항목명
  /// Returns: 추출된 키워드 목록
  static List<String> extractKeywords(String evaluationItem) {
    final keywords = <String>[];
    final lowerItem = evaluationItem.toLowerCase();

    // 모든 매핑을 순회하며 키워드 추출
    for (final mapping in BadgeMappings.evaluationMappings.values) {
      for (final keyword in mapping.keywords) {
        if (lowerItem.contains(keyword.toLowerCase())) {
          keywords.add(keyword);
        }
      }
    }

    return keywords;
  }

  /// 배지 타입별로 중복 제거 (같은 타입이면 등급이 높은 것만 유지)
  static List<Badge> _removeDuplicatesByType(List<Badge> badges) {
    final Map<BadgeType, Badge> typeMap = {};

    for (final badge in badges) {
      final existing = typeMap[badge.type];

      if (existing == null) {
        // 처음 등장하는 타입이면 추가
        typeMap[badge.type] = badge;
      } else {
        // 이미 있는 타입이면 라벨 비교 (1등급 > 2등급)
        // "우수"가 포함된 배지를 우선
        if (badge.label.contains('우수') && !existing.label.contains('우수')) {
          typeMap[badge.type] = badge;
        }
      }
    }

    return typeMap.values.toList();
  }

  /// 우선순위 순으로 배지 정렬
  ///
  /// 1. 배지 타입 우선순위 (중증 질환 > 수술 > 진료과)
  /// 2. 라벨 내 "우수" 포함 여부 (1등급)
  static List<Badge> _sortByPriority(List<Badge> badges) {
    final sortedBadges = List<Badge>.from(badges);

    sortedBadges.sort((a, b) {
      // 1. 타입 우선순위 비교
      final aPriority = BadgeMappings.typePriority[a.type] ?? 99;
      final bPriority = BadgeMappings.typePriority[b.type] ?? 99;

      if (aPriority != bPriority) {
        return aPriority.compareTo(bPriority);
      }

      // 2. "우수" 포함 여부 비교 (1등급 우선)
      final aHasExcellent = a.label.contains('우수');
      final bHasExcellent = b.label.contains('우수');

      if (aHasExcellent != bHasExcellent) {
        return aHasExcellent ? -1 : 1;
      }

      // 3. 알파벳순
      return a.label.compareTo(b.label);
    });

    return sortedBadges;
  }

  /// 배지 타입에서 필터링용 카테고리 반환
  ///
  /// [type] 배지 타입
  /// Returns: 카테고리 문자열 (예: "중증질환", "수술", "진료과")
  static String getBadgeCategory(BadgeType type) {
    final priority = BadgeMappings.typePriority[type] ?? 99;

    if (priority <= 2) {
      return '중증질환';
    } else if (priority == 3) {
      return '수술/치료';
    } else if (priority <= 6) {
      return '진료과';
    } else {
      return '일반';
    }
  }

  /// 배지의 상세 정보 반환 (UI 표시용)
  ///
  /// [badge] 배지 객체
  /// Returns: 배지 상세 정보 Map
  static Map<String, dynamic> getBadgeDetails(Badge badge) {
    return {
      'label': badge.label,
      'description': badge.description ?? '',
      'category': getBadgeCategory(badge.type),
      'icon': badge.type.icon.codePoint,
      'color': badge.type.color.value,
      'priority': BadgeMappings.typePriority[badge.type] ?? 99,
    };
  }

  /// 여러 배지를 카테고리별로 그룹화
  ///
  /// [badges] 배지 목록
  /// Returns: 카테고리별로 그룹화된 Map
  static Map<String, List<Badge>> groupByCategory(List<Badge> badges) {
    final Map<String, List<Badge>> grouped = {};

    for (final badge in badges) {
      final category = getBadgeCategory(badge.type);
      grouped.putIfAbsent(category, () => []);
      grouped[category]!.add(badge);
    }

    return grouped;
  }

  /// 배지 존재 여부로 필터링된 병원 목록 생성 (역필터링용)
  ///
  /// [requiredTypes] 필수 배지 타입 목록
  /// [hospitalBadges] 병원의 배지 목록
  /// Returns: 필수 배지를 모두 가지고 있으면 true
  static bool hasRequiredBadges(
    List<BadgeType> requiredTypes,
    List<Badge> hospitalBadges,
  ) {
    final hospitalTypes = hospitalBadges.map((b) => b.type).toSet();

    for (final requiredType in requiredTypes) {
      if (!hospitalTypes.contains(requiredType)) {
        return false;
      }
    }

    return true;
  }
}

