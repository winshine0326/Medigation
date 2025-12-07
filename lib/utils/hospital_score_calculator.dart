import 'package:medigation/models/hospital.dart';
import 'package:medigation/models/hospital_evaluation.dart';
import 'package:medigation/models/review_statistics.dart';
import 'package:medigation/models/nursing_grade_info.dart';

/// 병원의 종합 점수를 계산하는 유틸리티 클래스
///
/// 가중치:
/// - 평가 데이터 (HIRA): 30%
/// - 리뷰 통계 (네이버/카카오): 30%
/// - 배지: 20%
/// - 상세 정보 (전문의/간호등급/특수진료): 20%
class HospitalScoreCalculator {
  // 가중치 상수 제거 (동적 가중치 사용)

  /// 병원의 종합 점수 계산 (0.0 ~ 100.0)
  static double calculateTotalScore(Hospital hospital) {
    // 데이터 유무 확인
    final hasEvaluations = hospital.evaluations.isNotEmpty;
    final hasReviews = hospital.reviewStatistics != null && hospital.reviewStatistics!.totalReviewCount > 0;
    final hasDetailedInfo = hospital.specialistInfoList.isNotEmpty || 
                           hospital.nursingGradeInfoList.isNotEmpty || 
                           hospital.specialDiagnosisInfoList.isNotEmpty;

    // 점수 계산
    final evaluationScore = _calculateEvaluationScore(hospital.evaluations);
    final reviewScore = _calculateReviewScore(hospital.reviewStatistics);
    final badgeScore = _calculateBadgeScore(hospital.evaluations);
    final detailInfoScore = _calculateDetailedInfoScore(hospital);

    // 동적 가중치 계산
    double evalWeight = 0.0;
    double reviewWeight = 0.0;
    double badgeWeight = 0.0;
    double detailWeight = 0.0;

    if (hasEvaluations && hasReviews) {
      // 모든 데이터가 있는 경우 (기존 로직)
      evalWeight = 0.3;
      reviewWeight = 0.3;
      badgeWeight = 0.2;
      detailWeight = 0.2;
    } else if (hasDetailedInfo) {
      // 상세 정보만 있는 경우 (API 연동 병원)
      // 평가/리뷰가 없으면 상세 정보에 몰아주기
      detailWeight = 0.8;
      // 나머지는 기본 점수나 미미한 가중치
      evalWeight = 0.1;
      reviewWeight = 0.1;
      badgeWeight = 0.0; 
    } else {
      // 데이터가 거의 없는 경우 (기본값)
      return 50.0;
    }

    // 가중치 재조정 (합이 1.0이 되도록)
    double totalWeight = evalWeight + reviewWeight + badgeWeight + detailWeight;
    if (totalWeight > 0) {
      evalWeight /= totalWeight;
      reviewWeight /= totalWeight;
      badgeWeight /= totalWeight;
      detailWeight /= totalWeight;
    }

    return (evaluationScore * evalWeight) +
        (reviewScore * reviewWeight) +
        (badgeScore * badgeWeight) +
        (detailInfoScore * detailWeight);
  }

  /// 평가 데이터 점수 계산 (0.0 ~ 100.0)
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

  /// 상세 정보 점수 계산 (0.0 ~ 100.0)
  static double _calculateDetailedInfoScore(Hospital hospital) {
    // 데이터가 하나도 없으면 중간값 (기존 평가 방식과의 호환성)
    if (hospital.specialistInfoList.isEmpty &&
        hospital.nursingGradeInfoList.isEmpty &&
        hospital.specialDiagnosisInfoList.isEmpty) {
      return 50.0;
    }

    // 1. 간호 등급 점수 (40%)
    double nursingScore = 50.0; // 기본값
    if (hospital.nursingGradeInfoList.isNotEmpty) {
      // 가장 좋은 등급 찾기
      int bestGrade = 9; // 큰 값으로 초기화
      bool found = false;
      
      for (final info in hospital.nursingGradeInfoList) {
        final gradeStr = info.careGrade.replaceAll(RegExp(r'[^0-9]'), '');
        if (gradeStr.isNotEmpty) {
          final grade = int.tryParse(gradeStr);
          if (grade != null && grade < bestGrade) {
            bestGrade = grade;
            found = true;
          }
        }
      }

      if (found) {
        if (bestGrade == 1) nursingScore = 100.0;
        else if (bestGrade == 2) nursingScore = 80.0;
        else if (bestGrade == 3) nursingScore = 60.0;
        else if (bestGrade == 4) nursingScore = 40.0;
        else nursingScore = 20.0;
      }
    }

    // 2. 전문의 수 점수 (30%)
    double specialistScore = 0.0;
    if (hospital.specialistInfoList.isNotEmpty) {
      int totalSpecialists = 0;
      for (final info in hospital.specialistInfoList) {
        totalSpecialists += info.specialistCount;
      }

      if (totalSpecialists > 50) specialistScore = 100.0;
      else if (totalSpecialists > 20) specialistScore = 80.0;
      else if (totalSpecialists > 10) specialistScore = 60.0;
      else if (totalSpecialists > 5) specialistScore = 40.0;
      else if (totalSpecialists > 0) specialistScore = 20.0;
    }

    // 3. 특수 진료 점수 (30%)
    double diagnosisScore = 0.0;
    if (hospital.specialDiagnosisInfoList.isNotEmpty) {
      final count = hospital.specialDiagnosisInfoList.length;
      if (count >= 5) diagnosisScore = 100.0;
      else if (count >= 3) diagnosisScore = 80.0;
      else if (count >= 2) diagnosisScore = 60.0;
      else if (count >= 1) diagnosisScore = 40.0;
    }

    // 항목별 가중치 적용
    // 데이터가 없는 항목은 0점 처리되므로, 데이터가 풍부할수록 점수가 높아짐
    // 다만 간호등급은 필수적인 경우가 많아 기본값 50을 줌
    return (nursingScore * 0.4) + (specialistScore * 0.3) + (diagnosisScore * 0.3);
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
  static double calculateDataCompleteness(Hospital hospital) {
    double completeness = 0.0;

    // 상세 정보 (전문의/간호/특수) - 가장 중요한 데이터로 취급 (60점)
    if (hospital.specialistInfoList.isNotEmpty || 
        hospital.nursingGradeInfoList.isNotEmpty || 
        hospital.specialDiagnosisInfoList.isNotEmpty) {
      completeness += 60.0;
    }

    // 평가 데이터 (20점)
    if (hospital.evaluations.isNotEmpty) completeness += 20.0;

    // 비급여 가격 데이터 (10점)
    if (hospital.nonCoveredPrices.isNotEmpty) completeness += 10.0;

    // 리뷰 통계 데이터 (10점)
    if (hospital.reviewStatistics != null &&
        hospital.reviewStatistics!.totalReviewCount > 0) completeness += 10.0;

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
    // 데이터 유무 확인
    final hasEvaluations = hospital.evaluations.isNotEmpty;
    final hasReviews = hospital.reviewStatistics != null && hospital.reviewStatistics!.totalReviewCount > 0;
    final hasDetailedInfo = hospital.specialistInfoList.isNotEmpty || 
                           hospital.nursingGradeInfoList.isNotEmpty || 
                           hospital.specialDiagnosisInfoList.isNotEmpty;

    // 가중치 계산 (calculateTotalScore와 동일한 로직)
    double evalWeight = 0.0;
    double reviewWeight = 0.0;
    double badgeWeight = 0.0;
    double detailWeight = 0.0;

    if (hasEvaluations && hasReviews) {
      evalWeight = 0.3;
      reviewWeight = 0.3;
      badgeWeight = 0.2;
      detailWeight = 0.2;
    } else if (hasDetailedInfo) {
      detailWeight = 0.8;
      evalWeight = 0.1;
      reviewWeight = 0.1;
      badgeWeight = 0.0; 
    }

    // 정규화
    double totalWeight = evalWeight + reviewWeight + badgeWeight + detailWeight;
    if (totalWeight > 0) {
      evalWeight /= totalWeight;
      reviewWeight /= totalWeight;
      badgeWeight /= totalWeight;
      detailWeight /= totalWeight;
    }

    return HospitalScoreReport(
      hospital: hospital,
      totalScore: calculateTotalScore(hospital),
      evaluationScore: _calculateEvaluationScore(hospital.evaluations),
      reviewScore: _calculateReviewScore(hospital.reviewStatistics),
      badgeScore: _calculateBadgeScore(hospital.evaluations),
      detailInfoScore: _calculateDetailedInfoScore(hospital),
      dataCompleteness: calculateDataCompleteness(hospital),
      evalWeight: evalWeight,
      reviewWeight: reviewWeight,
      badgeWeight: badgeWeight,
      detailWeight: detailWeight,
    );
  }
}

/// 병원 종합 리포트 데이터 클래스
class HospitalScoreReport {
  final Hospital hospital;
  final double totalScore; // 종합 점수
  final double evaluationScore; // 평가 점수
  final double reviewScore; // 리뷰 점수
  final double badgeScore; // 배지 점수
  final double detailInfoScore; // 상세 정보 점수
  final double dataCompleteness; // 데이터 완성도

  // 적용된 가중치
  final double evalWeight;
  final double reviewWeight;
  final double badgeWeight;
  final double detailWeight;

  HospitalScoreReport({
    required this.hospital,
    required this.totalScore,
    required this.evaluationScore,
    required this.reviewScore,
    required this.badgeScore,
    required this.detailInfoScore,
    required this.dataCompleteness,
    required this.evalWeight,
    required this.reviewWeight,
    required this.badgeWeight,
    required this.detailWeight,
  });

  /// 종합 등급 (S, A, B, C, D)
  String get grade => HospitalScoreCalculator.getScoreGrade(totalScore);

  /// 종합 점수 색상
  String get scoreColor => HospitalScoreCalculator.getScoreColor(totalScore);

  /// 데이터 완성도 텍스트
  String get dataCompletenessText =>
      HospitalScoreCalculator.getDataCompletenessText(dataCompleteness);

  /// 평가 데이터 기여도 (백분율)
  double get evaluationContribution => evaluationScore * evalWeight;

  /// 리뷰 데이터 기여도 (백분율)
  double get reviewContribution => reviewScore * reviewWeight;

  /// 배지 데이터 기여도 (백분율)
  double get badgeContribution => badgeScore * badgeWeight;
  
  /// 상세 정보 기여도 (백분율)
  double get detailInfoContribution => detailInfoScore * detailWeight;

  // ... (나머지 getter는 동일)
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
