import 'package:medigation/models/hospital.dart';
import 'package:medigation/models/hospital_evaluation.dart';
import 'package:medigation/models/review_statistics.dart';

/// 병원의 종합 점수를 계산하는 유틸리티 클래스
///
/// 가중치:
/// - 평가 데이터 (HIRA): 40%
/// - 리뷰 통계 (네이버/카카오): 40%
/// - 배지: 20%
class HospitalScoreCalculator {
  // 가중치 상수
  static const double _evaluationWeight = 0.4; // 평가 데이터 40%
  static const double _reviewWeight = 0.4; // 리뷰 통계 40%
  static const double _badgeWeight = 0.2; // 배지 20%

  /// 병원의 종합 점수 계산 (0.0 ~ 100.0)
  static double calculateTotalScore(Hospital hospital) {
    final evaluationScore = _calculateEvaluationScore(hospital.evaluations);
    final reviewScore = _calculateReviewScore(hospital.reviewStatistics);
    final badgeScore = _calculateBadgeScore(hospital.evaluations);

    return (evaluationScore * _evaluationWeight) +
        (reviewScore * _reviewWeight) +
        (badgeScore * _badgeWeight);
  }

  /// 평가 데이터 점수 계산 (0.0 ~ 100.0)
  /// 1등급: 100점, 2등급: 80점, 3등급: 60점, 4등급: 40점, 5등급: 20점
  static double _calculateEvaluationScore(List<HospitalEvaluation> evaluations) {
    if (evaluations.isEmpty) return 50.0; // 데이터 없으면 중간값

    double totalScore = 0.0;
    int count = 0;

    for (final eval in evaluations) {
      final grade = eval.grade;
      double score = 50.0; // 기본값

      if (grade.contains('1등급')) {
        score = 100.0;
      } else if (grade.contains('2등급')) {
        score = 80.0;
      } else if (grade.contains('3등급')) {
        score = 60.0;
      } else if (grade.contains('4등급')) {
        score = 40.0;
      } else if (grade.contains('5등급')) {
        score = 20.0;
      }

      totalScore += score;
      count++;
    }

    return count > 0 ? totalScore / count : 50.0;
  }

  /// 리뷰 통계 점수 계산 (0.0 ~ 100.0)
  /// 평균 별점과 리뷰 개수를 종합하여 계산
  static double _calculateReviewScore(ReviewStatistics? statistics) {
    if (statistics == null) return 50.0; // 데이터 없으면 중간값

    // 평균 별점을 100점 만점으로 환산 (5점 만점 → 100점 만점)
    final ratingScore = (statistics.averageRating / 5.0) * 100.0;

    // 리뷰 개수에 따른 신뢰도 보정 (최대 10점)
    double reviewCountBonus = 0.0;
    if (statistics.totalReviewCount >= 1000) {
      reviewCountBonus = 10.0;
    } else if (statistics.totalReviewCount >= 500) {
      reviewCountBonus = 8.0;
    } else if (statistics.totalReviewCount >= 100) {
      reviewCountBonus = 5.0;
    } else if (statistics.totalReviewCount >= 50) {
      reviewCountBonus = 3.0;
    } else if (statistics.totalReviewCount >= 10) {
      reviewCountBonus = 1.0;
    }

    // 최종 점수 = 별점 점수 + 리뷰 개수 보너스 (최대 100점)
    return (ratingScore + reviewCountBonus).clamp(0.0, 100.0);
  }

  /// 배지 점수 계산 (0.0 ~ 100.0)
  /// 배지 개수와 품질에 따라 점수 부여
  static double _calculateBadgeScore(List<HospitalEvaluation> evaluations) {
    if (evaluations.isEmpty) return 50.0; // 데이터 없으면 중간값

    // 모든 평가에서 배지 수집
    final allBadges = <String>[];
    for (final eval in evaluations) {
      allBadges.addAll(eval.badges);
    }

    if (allBadges.isEmpty) return 50.0; // 배지 없으면 중간값

    // 배지 개수에 따른 기본 점수 (최대 70점)
    double badgeCountScore = 0.0;
    if (allBadges.length >= 10) {
      badgeCountScore = 70.0;
    } else if (allBadges.length >= 7) {
      badgeCountScore = 60.0;
    } else if (allBadges.length >= 5) {
      badgeCountScore = 50.0;
    } else if (allBadges.length >= 3) {
      badgeCountScore = 40.0;
    } else {
      badgeCountScore = 30.0;
    }

    // 중증질환 전문 배지 보너스 (최대 30점)
    double specialtyBonus = 0.0;
    final specialtyBadges = allBadges.where((badge) =>
        badge.contains('뇌졸중') ||
        badge.contains('심근경색') ||
        badge.contains('중증외상') ||
        badge.contains('암센터') ||
        badge.contains('응급의료')).toList();

    if (specialtyBadges.isNotEmpty) {
      specialtyBonus = (specialtyBadges.length * 10.0).clamp(0.0, 30.0);
    }

    return (badgeCountScore + specialtyBonus).clamp(0.0, 100.0);
  }

  /// 점수 등급 반환 (S, A, B, C, D)
  static String getScoreGrade(double score) {
    if (score >= 90.0) return 'S';
    if (score >= 80.0) return 'A';
    if (score >= 70.0) return 'B';
    if (score >= 60.0) return 'C';
    return 'D';
  }

  /// 점수에 따른 색상 반환 (UI용)
  static String getScoreColor(double score) {
    if (score >= 90.0) return '#FFD700'; // Gold
    if (score >= 80.0) return '#4CAF50'; // Green
    if (score >= 70.0) return '#2196F3'; // Blue
    if (score >= 60.0) return '#FF9800'; // Orange
    return '#F44336'; // Red
  }

  /// 데이터 완성도 계산 (0.0 ~ 100.0)
  /// 평가, 가격, 리뷰 데이터가 얼마나 있는지 측정
  static double calculateDataCompleteness(Hospital hospital) {
    double completeness = 0.0;

    // 평가 데이터 (40점)
    if (hospital.evaluations.isNotEmpty) {
      completeness += 40.0;
    }

    // 비급여 가격 데이터 (30점)
    if (hospital.nonCoveredPrices.isNotEmpty) {
      completeness += 30.0;
    }

    // 리뷰 통계 데이터 (30점)
    if (hospital.reviewStatistics != null &&
        hospital.reviewStatistics!.totalReviewCount > 0) {
      completeness += 30.0;
    }

    return completeness;
  }

  /// 데이터 완성도 텍스트 반환
  static String getDataCompletenessText(double completeness) {
    if (completeness >= 90.0) return '매우 풍부';
    if (completeness >= 70.0) return '풍부';
    if (completeness >= 50.0) return '보통';
    if (completeness >= 30.0) return '부족';
    return '매우 부족';
  }

  /// 종합 리포트 생성
  static HospitalScoreReport generateReport(Hospital hospital) {
    return HospitalScoreReport(
      hospital: hospital,
      totalScore: calculateTotalScore(hospital),
      evaluationScore: _calculateEvaluationScore(hospital.evaluations),
      reviewScore: _calculateReviewScore(hospital.reviewStatistics),
      badgeScore: _calculateBadgeScore(hospital.evaluations),
      dataCompleteness: calculateDataCompleteness(hospital),
    );
  }
}

/// 병원 종합 리포트 데이터 클래스
class HospitalScoreReport {
  final Hospital hospital;
  final double totalScore; // 종합 점수 (0-100)
  final double evaluationScore; // 평가 점수 (0-100)
  final double reviewScore; // 리뷰 점수 (0-100)
  final double badgeScore; // 배지 점수 (0-100)
  final double dataCompleteness; // 데이터 완성도 (0-100)

  HospitalScoreReport({
    required this.hospital,
    required this.totalScore,
    required this.evaluationScore,
    required this.reviewScore,
    required this.badgeScore,
    required this.dataCompleteness,
  });

  /// 종합 등급 (S, A, B, C, D)
  String get grade => HospitalScoreCalculator.getScoreGrade(totalScore);

  /// 종합 점수 색상
  String get scoreColor => HospitalScoreCalculator.getScoreColor(totalScore);

  /// 데이터 완성도 텍스트
  String get dataCompletenessText =>
      HospitalScoreCalculator.getDataCompletenessText(dataCompleteness);

  /// 평가 데이터 기여도 (백분율)
  double get evaluationContribution => evaluationScore * 0.4;

  /// 리뷰 데이터 기여도 (백분율)
  double get reviewContribution => reviewScore * 0.4;

  /// 배지 데이터 기여도 (백분율)
  double get badgeContribution => badgeScore * 0.2;

  /// 신뢰도 점수 (데이터 완성도 기반, 0-100)
  double get reliabilityScore => dataCompleteness;

  /// 신뢰도 텍스트
  String get reliabilityText {
    if (reliabilityScore >= 90.0) return '매우 신뢰함';
    if (reliabilityScore >= 70.0) return '신뢰함';
    if (reliabilityScore >= 50.0) return '보통';
    if (reliabilityScore >= 30.0) return '주의 필요';
    return '데이터 부족';
  }
}
