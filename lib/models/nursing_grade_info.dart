import 'package:freezed_annotation/freezed_annotation.dart';

part 'nursing_grade_info.freezed.dart';
part 'nursing_grade_info.g.dart';

/// 간호등급 정보 모델
/// 건강보험심사평가원 의료기관별상세정보서비스 - 간호등급정보
@freezed
class NursingGradeInfo with _$NursingGradeInfo {
  const factory NursingGradeInfo({
    required String typeCode, // 유형코드 (tyCd)
    required String typeName, // 유형명 (tyCdNm)
    required String careGrade, // 간호등급 (careGrd)
  }) = _NursingGradeInfo;

  factory NursingGradeInfo.fromJson(Map<String, dynamic> json) =>
      _$NursingGradeInfoFromJson(json);

  /// HIRA API 응답에서 변환
  factory NursingGradeInfo.fromHiraApi(Map<String, dynamic> json) {
    return NursingGradeInfo(
      typeCode: json['tyCd']?.toString() ?? '',
      typeName: json['tyCdNm']?.toString() ?? '',
      careGrade: json['careGrd']?.toString() ?? '',
    );
  }
}
