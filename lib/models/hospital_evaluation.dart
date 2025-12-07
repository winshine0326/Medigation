import 'package:freezed_annotation/freezed_annotation.dart';

part 'hospital_evaluation.freezed.dart';
part 'hospital_evaluation.g.dart';

/// 병원 평가 모델
/// 평가 항목, 평가 등급, 생성된 배지 목록을 포함
@freezed
class HospitalEvaluation with _$HospitalEvaluation {
  const factory HospitalEvaluation({
    required String evaluationItem, // 평가 항목 (예: "급성기 뇌졸중 적정성 평가")
    required String grade, // 평가 등급 (예: "1등급", "2등급")
    required List<String> badges, // 생성된 배지 목록 (예: ["뇌졸중 수술 전문"])
  }) = _HospitalEvaluation;

  factory HospitalEvaluation.fromJson(Map<String, dynamic> json) =>
      _$HospitalEvaluationFromJson(json);
}
