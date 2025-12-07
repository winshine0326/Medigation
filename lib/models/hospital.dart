import 'package:freezed_annotation/freezed_annotation.dart';
import 'hospital_evaluation.dart';
import 'non_covered_price.dart';
import 'review_statistics.dart';
import 'specialist_info.dart';
import 'nursing_grade_info.dart';
import 'special_diagnosis_info.dart';

part 'hospital.freezed.dart';
part 'hospital.g.dart';

/// 병원 모델
/// 병원의 기본 정보, 평가, 가격, 리뷰 통계를 모두 포함하는 핵심 데이터 모델
@freezed
class Hospital with _$Hospital {
  const factory Hospital({
    required String id, // 병원 ID (Firestore document ID 또는 공공데이터 API ID)
    required String name, // 병원 이름
    required String address, // 주소
    required double latitude, // 위도
    required double longitude, // 경도
    @Default([]) List<HospitalEvaluation> evaluations, // 병원 평가 목록
    @Default([]) List<NonCoveredPrice> nonCoveredPrices, // 비급여 가격 목록
    ReviewStatistics? reviewStatistics, // 리뷰 통계 (nullable - 리뷰가 없을 수 있음)
    @Default([]) List<SpecialistInfo> specialistInfoList, // 전문의 정보 목록
    @Default([]) List<NursingGradeInfo> nursingGradeInfoList, // 간호 등급 정보 목록
    @Default([]) List<SpecialDiagnosisInfo> specialDiagnosisInfoList, // 특수 진료 정보 목록
  }) = _Hospital;

  factory Hospital.fromJson(Map<String, dynamic> json) =>
      _$HospitalFromJson(json);
}
