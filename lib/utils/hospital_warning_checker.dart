import 'package:medigation/models/hospital.dart';

/// 병원 경고 판단 유틸리티 클래스
///
/// "피해야 할 병원"의 기준을 정의하고 경고를 표시합니다.
class HospitalWarningChecker {
  /// 경고 유형
  static const String warningLowRating = 'LOW_RATING'; // 낮은 평점
  static const String warningFewReviews = 'FEW_REVIEWS'; // 적은 리뷰
  static const String warningLowGrade = 'LOW_GRADE'; // 낮은 등급
  static const String warningNoData = 'NO_DATA'; // 데이터 부족

  /// 경고 기준 상수
  static const double _minAcceptableRating = 3.0; // 최소 허용 평점
  static const int _minAcceptableReviews = 5; // 최소 허용 리뷰 수
  static const List<String> _lowGrades = ['4등급', '5등급']; // 낮은 등급

  /// 병원의 모든 경고 사항 확인
  static List<HospitalWarning> checkWarnings(Hospital hospital) {
    final warnings = <HospitalWarning>[];

    // 1. 낮은 평점 경고
    if (hospital.reviewStatistics != null) {
      if (hospital.reviewStatistics!.averageRating < _minAcceptableRating) {
        warnings.add(HospitalWarning(
          type: warningLowRating,
          severity: WarningSeverity.high,
          message:
              '평균 평점이 ${hospital.reviewStatistics!.averageRating.toStringAsFixed(1)}점으로 낮습니다.',
          description: '다른 사용자들의 평가가 좋지 않습니다. 신중하게 검토해주세요.',
        ));
      }
    }

    // 2. 적은 리뷰 수 경고
    if (hospital.reviewStatistics != null) {
      if (hospital.reviewStatistics!.totalReviewCount < _minAcceptableReviews) {
        warnings.add(HospitalWarning(
          type: warningFewReviews,
          severity: WarningSeverity.medium,
          message: '리뷰가 ${hospital.reviewStatistics!.totalReviewCount}개로 적습니다.',
          description: '충분한 리뷰 데이터가 없어 신뢰도가 낮을 수 있습니다.',
        ));
      }
    }

    // 3. 낮은 평가 등급 경고
    final lowGradeEvaluations = hospital.evaluations.where((eval) {
      return _lowGrades.any((grade) => eval.grade.contains(grade));
    }).toList();

    if (lowGradeEvaluations.isNotEmpty) {
      final items =
          lowGradeEvaluations.map((e) => '${e.evaluationItem}: ${e.grade}').join(', ');
      warnings.add(HospitalWarning(
        type: warningLowGrade,
        severity: WarningSeverity.high,
        message: '일부 평가 항목에서 4~5등급을 받았습니다.',
        description: '낮은 등급 항목: $items',
      ));
    }

    // 4. 데이터 부족 경고
    if (hospital.evaluations.isEmpty &&
        (hospital.reviewStatistics == null ||
            hospital.reviewStatistics!.totalReviewCount == 0)) {
      warnings.add(HospitalWarning(
        type: warningNoData,
        severity: WarningSeverity.medium,
        message: '평가 및 리뷰 데이터가 부족합니다.',
        description: '병원에 대한 정보가 충분하지 않습니다. 직접 방문하여 확인해주세요.',
      ));
    }

    return warnings;
  }

  /// 경고가 있는지 확인
  static bool hasWarnings(Hospital hospital) {
    return checkWarnings(hospital).isNotEmpty;
  }

  /// 심각한 경고가 있는지 확인 (HIGH 등급)
  static bool hasSevereWarnings(Hospital hospital) {
    return checkWarnings(hospital)
        .any((warning) => warning.severity == WarningSeverity.high);
  }

  /// 경고 개수 반환
  static int getWarningCount(Hospital hospital) {
    return checkWarnings(hospital).length;
  }

  /// 가장 심각한 경고 반환
  static HospitalWarning? getMostSevereWarning(Hospital hospital) {
    final warnings = checkWarnings(hospital);
    if (warnings.isEmpty) return null;

    // HIGH -> MEDIUM -> LOW 순으로 정렬
    warnings.sort((a, b) => b.severity.index.compareTo(a.severity.index));
    return warnings.first;
  }

  /// 역필터링 조건에 맞는지 확인
  ///
  /// [minRating]: 최소 평점 (기본값: 3.0)
  /// [minReviews]: 최소 리뷰 수 (기본값: 5)
  /// [excludeGrades]: 제외할 등급 (예: ['4등급', '5등급'])
  static bool passesReverseFilter(
    Hospital hospital, {
    double minRating = 3.0,
    int minReviews = 5,
    List<String> excludeGrades = const [],
  }) {
    // 평점 체크
    if (hospital.reviewStatistics != null) {
      if (hospital.reviewStatistics!.averageRating < minRating) {
        return false;
      }
      if (hospital.reviewStatistics!.totalReviewCount < minReviews) {
        return false;
      }
    }

    // 등급 체크
    if (excludeGrades.isNotEmpty) {
      for (final eval in hospital.evaluations) {
        if (excludeGrades.any((grade) => eval.grade.contains(grade))) {
          return false;
        }
      }
    }

    return true;
  }

  /// 경고 아이콘 반환 (UI용)
  static String getWarningIcon(WarningSeverity severity) {
    switch (severity) {
      case WarningSeverity.high:
        return '⚠️';
      case WarningSeverity.medium:
        return '⚡';
      case WarningSeverity.low:
        return 'ℹ️';
    }
  }

  /// 경고 색상 반환 (UI용, Hex 코드)
  static String getWarningColor(WarningSeverity severity) {
    switch (severity) {
      case WarningSeverity.high:
        return '#F44336'; // Red
      case WarningSeverity.medium:
        return '#FF9800'; // Orange
      case WarningSeverity.low:
        return '#2196F3'; // Blue
    }
  }
}

/// 병원 경고 데이터 클래스
class HospitalWarning {
  final String type; // 경고 유형
  final WarningSeverity severity; // 심각도
  final String message; // 경고 메시지
  final String description; // 상세 설명

  HospitalWarning({
    required this.type,
    required this.severity,
    required this.message,
    required this.description,
  });

  /// 경고 아이콘
  String get icon => HospitalWarningChecker.getWarningIcon(severity);

  /// 경고 색상
  String get color => HospitalWarningChecker.getWarningColor(severity);

  /// 심각도 텍스트
  String get severityText {
    switch (severity) {
      case WarningSeverity.high:
        return '높음';
      case WarningSeverity.medium:
        return '보통';
      case WarningSeverity.low:
        return '낮음';
    }
  }
}

/// 경고 심각도 enum
enum WarningSeverity {
  low, // 낮음 - 참고용
  medium, // 보통 - 주의 필요
  high, // 높음 - 심각한 문제
}
