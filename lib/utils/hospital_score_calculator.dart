import 'package:medigation/models/hospital.dart';
import 'package:medigation/models/hospital_evaluation.dart';
import 'package:medigation/models/review_statistics.dart';
import 'package:medigation/models/nursing_grade_info.dart';

/// 병원의 종합 점수를 계산하는 유틸리티 클래스
///
/// 가중치:
/// - 간호 등급 (Quality): 40%
/// - 의료 규모/인프라 (Quantity - 전문의/특수진료): 20%
/// - 배지 (Specialty): 20%
/// - 리뷰 통계 (Satisfaction): 20%
class HospitalScoreCalculator {
  /// 병원의 종합 점수 계산 (0.0 ~ 100.0)
  static double calculateTotalScore(Hospital hospital) {
    // 데이터 유무 확인
    final hasReviews = hospital.reviewStatistics != null && hospital.reviewStatistics!.totalReviewCount > 0;
    // 간호 등급 데이터 유무
    final hasNursing = hospital.nursingGradeInfoList.isNotEmpty;
    // 규모 데이터 유무
    final hasCapacity = hospital.specialistInfoList.isNotEmpty || hospital.specialDiagnosisInfoList.isNotEmpty;

    // 점수 계산
    final nursingScore = _calculateNursingScore(hospital);
    final capacityScore = _calculateCapacityScore(hospital);
    final badgeScore = _calculateBadgeScore(hospital.evaluations);
    final reviewScore = _calculateReviewScore(hospital.reviewStatistics);

    // 가중치 설정
    double nursingWeight = 0.4;
    double capacityWeight = 0.2;
    double badgeWeight = 0.2;
    double reviewWeight = 0.2;

    // 리뷰 데이터가 없는 경우 가중치 재분배
    if (!hasReviews) {
      reviewWeight = 0.0;
      // 리뷰 비중을 간호 등급과 규모에 나눠줌
      nursingWeight += 0.1; // 0.5
      capacityWeight += 0.1; // 0.3
    }

    // 간호 등급 데이터가 없는 경우 (매우 드뭄)
    if (!hasNursing) {
      nursingWeight = 0.0;
      capacityWeight += 0.2;
      badgeWeight += 0.2;
    }

    // 규모 데이터가 없는 경우
    if (!hasCapacity) {
      capacityWeight = 0.0;
      nursingWeight += 0.2;
    }

    // 가중치 정규화 (합이 1.0이 되도록)
    double totalWeight = nursingWeight + capacityWeight + badgeWeight + reviewWeight;
    if (totalWeight > 0) {
      nursingWeight /= totalWeight;
      capacityWeight /= totalWeight;
      badgeWeight /= totalWeight;
      reviewWeight /= totalWeight;
    } else {
      // 데이터가 하나도 없으면 기본값
      return 50.0;
    }

    return (nursingScore * nursingWeight) +
        (capacityScore * capacityWeight) +
        (badgeScore * badgeWeight) +
        (reviewScore * reviewWeight);
  }

  /// 간호 등급 점수 계산 (0.0 ~ 100.0)
  /// 4가지 주요 항목(건강보험(환자수), 건강보험, 의료급여, 의료급여(환자수))의 평균 등급을 기반으로 계산
  static double _calculateNursingScore(Hospital hospital) {
    if (hospital.nursingGradeInfoList.isEmpty) return 50.0; // 기본값

    final targetCategories = [
      '건강보험(환자수)',
      '건강보험',
      '의료급여',
      '의료급여(환자수)'
    ];

    double totalGrade = 0.0;
    int count = 0;

    for (final info in hospital.nursingGradeInfoList) {
      // 대상 카테고리인지 확인 (부분 일치 허용 또는 정확한 일치)
      // API 응답의 tyCdNm이 정확하지 않을 수 있으므로 포함 여부로 체크하는 것이 안전할 수 있으나,
      // 여기서는 최대한 정확도를 위해 리스트에 있는 항목과 매칭 시도
      if (targetCategories.any((category) => info.typeName.contains(category))) {
        double grade = 0.0;
        
        // 등급 파싱 (S, A, B 또는 숫자)
        if (info.careGrade.toUpperCase().contains('S')) {
          grade = 1.0;
        } else if (info.careGrade.toUpperCase().contains('A')) {
          grade = 2.0;
        } else if (info.careGrade.toUpperCase().contains('B')) {
          grade = 3.0;
        } else {
          // 숫자 추출
          final gradeStr = info.careGrade.replaceAll(RegExp(r'[^0-9]'), '');
          if (gradeStr.isNotEmpty) {
            grade = double.tryParse(gradeStr) ?? 0.0;
          }
        }

        // 유효한 등급(1~7)인 경우 합산
        if (grade >= 1.0 && grade <= 7.0) {
          totalGrade += grade;
          count++;
        }
      }
    }

    if (count == 0) return 50.0; // 유효한 데이터 없음

    final averageGrade = totalGrade / count;

    // 점수 환산 (1등급=100점, 7등급=10점)
    // 등급이 낮을수록(숫자가 클수록) 점수가 낮아짐
    // 공식: 100 - ((등급 - 1) * 15)
    // 예: 1등급 -> 100 - 0 = 100
    // 예: 4등급 -> 100 - 45 = 55
    // 예: 7등급 -> 100 - 90 = 10
    double score = 100.0 - ((averageGrade - 1.0) * 15.0);
    
    return score.clamp(0.0, 100.0);
  }

  /// 의료 규모/인프라 점수 계산 (0.0 ~ 100.0)
  /// 전문의 수 + 특수 진료 가능 분야 수
  static double _calculateCapacityScore(Hospital hospital) {
    if (hospital.specialistInfoList.isEmpty && hospital.specialDiagnosisInfoList.isEmpty) {
      return 0.0; // 데이터 없음
    }

    // 1. 전문의 수 점수 (50%)
    double specialistScore = 0.0;
    int totalSpecialists = 0;
    for (final info in hospital.specialistInfoList) {
      totalSpecialists += info.specialistCount;
    }

    if (totalSpecialists > 50) specialistScore = 100.0;
    else if (totalSpecialists > 20) specialistScore = 80.0;
    else if (totalSpecialists > 10) specialistScore = 60.0;
    else if (totalSpecialists > 5) specialistScore = 40.0;
    else if (totalSpecialists > 0) specialistScore = 20.0;

    // 2. 특수 진료 점수 (50%)
    double diagnosisScore = 0.0;
    final count = hospital.specialDiagnosisInfoList.length;
    
    if (count >= 5) diagnosisScore = 100.0;
    else if (count >= 3) diagnosisScore = 80.0;
    else if (count >= 2) diagnosisScore = 60.0;
    else if (count >= 1) diagnosisScore = 40.0;

    // 두 점수 합산 (둘 중 하나만 있어도 점수 반영)
    if (hospital.specialistInfoList.isNotEmpty && hospital.specialDiagnosisInfoList.isNotEmpty) {
      return (specialistScore + diagnosisScore) / 2.0;
    } else if (hospital.specialistInfoList.isNotEmpty) {
      return specialistScore;
    } else {
      return diagnosisScore;
    }
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

  /// 평가 데이터 점수 계산 (Deprecated but kept for badges)
  static double _calculateEvaluationScore(List<HospitalEvaluation> evaluations) {
    if (evaluations.isEmpty) return 50.0;
    double totalScore = 0.0;
    int count = 0;
    for (final eval in evaluations) {
      final grade = eval.grade;
      double score = 50.0;
      if (grade.contains('1등급')) score = 100.0;
      else if (grade.contains('2등급')) score = 80.0;
      else if (grade.contains('3등급')) score = 60.0;
      else if (grade.contains('4등급')) score = 40.0;
      else if (grade.contains('5등급')) score = 20.0;
      totalScore += score;
      count++;
    }
    return count > 0 ? totalScore / count : 50.0;
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

    // 간호 등급 (40점)
    if (hospital.nursingGradeInfoList.isNotEmpty) completeness += 40.0;

    // 의료 규모 (30점)
    if (hospital.specialistInfoList.isNotEmpty || hospital.specialDiagnosisInfoList.isNotEmpty) completeness += 30.0;

    // 평가/배지 데이터 (20점)
    if (hospital.evaluations.isNotEmpty) completeness += 20.0;

    // 리뷰 데이터 (10점)
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
    final hasReviews = hospital.reviewStatistics != null && hospital.reviewStatistics!.totalReviewCount > 0;
    final hasNursing = hospital.nursingGradeInfoList.isNotEmpty;
    final hasCapacity = hospital.specialistInfoList.isNotEmpty || hospital.specialDiagnosisInfoList.isNotEmpty;

    // 가중치 설정
    double nursingWeight = 0.4;
    double capacityWeight = 0.2;
    double badgeWeight = 0.2;
    double reviewWeight = 0.2;

    // 리뷰 데이터가 없는 경우 가중치 재분배
    if (!hasReviews) {
      reviewWeight = 0.0;
      nursingWeight += 0.1;
      capacityWeight += 0.1;
    }

    if (!hasNursing) {
      nursingWeight = 0.0;
      capacityWeight += 0.2;
      badgeWeight += 0.2;
    }

    if (!hasCapacity) {
      capacityWeight = 0.0;
      nursingWeight += 0.2;
    }

    double totalWeight = nursingWeight + capacityWeight + badgeWeight + reviewWeight;
    if (totalWeight > 0) {
      nursingWeight /= totalWeight;
      capacityWeight /= totalWeight;
      badgeWeight /= totalWeight;
      reviewWeight /= totalWeight;
    }

    return HospitalScoreReport(
      hospital: hospital,
      totalScore: calculateTotalScore(hospital),
      nursingScore: _calculateNursingScore(hospital),
      capacityScore: _calculateCapacityScore(hospital),
      badgeScore: _calculateBadgeScore(hospital.evaluations),
      reviewScore: _calculateReviewScore(hospital.reviewStatistics),
      dataCompleteness: calculateDataCompleteness(hospital),
      nursingWeight: nursingWeight,
      capacityWeight: capacityWeight,
      badgeWeight: badgeWeight,
      reviewWeight: reviewWeight,
    );
  }
}

/// 병원 종합 리포트 데이터 클래스
class HospitalScoreReport {
  final Hospital hospital;
  final double totalScore; // 종합 점수
  final double nursingScore; // 간호 등급 점수
  final double capacityScore; // 의료 규모 점수 (전문의/특수진료)
  final double badgeScore; // 배지 점수
  final double reviewScore; // 리뷰 점수
  final double dataCompleteness; // 데이터 완성도

  // 적용된 가중치
  final double nursingWeight;
  final double capacityWeight;
  final double badgeWeight;
  final double reviewWeight;

  HospitalScoreReport({
    required this.hospital,
    required this.totalScore,
    required this.nursingScore,
    required this.capacityScore,
    required this.badgeScore,
    required this.reviewScore,
    required this.dataCompleteness,
    required this.nursingWeight,
    required this.capacityWeight,
    required this.badgeWeight,
    required this.reviewWeight,
  });

  /// 종합 등급 (S, A, B, C, D)
  String get grade => HospitalScoreCalculator.getScoreGrade(totalScore);

  /// 종합 점수 색상
  String get scoreColor => HospitalScoreCalculator.getScoreColor(totalScore);

  /// 데이터 완성도 텍스트
  String get dataCompletenessText =>
      HospitalScoreCalculator.getDataCompletenessText(dataCompleteness);

  /// 간호 점수 기여도 (백분율)
  double get nursingContribution => nursingScore * nursingWeight;

  /// 규모 점수 기여도 (백분율)
  double get capacityContribution => capacityScore * capacityWeight;

  /// 배지 데이터 기여도 (백분율)
  double get badgeContribution => badgeScore * badgeWeight;
  
  /// 리뷰 데이터 기여도 (백분율)
  double get reviewContribution => reviewScore * reviewWeight;

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