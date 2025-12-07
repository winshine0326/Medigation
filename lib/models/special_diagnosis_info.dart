import 'package:freezed_annotation/freezed_annotation.dart';

part 'special_diagnosis_info.freezed.dart';
part 'special_diagnosis_info.g.dart';

/// 특수진료(진료가능분야) 정보 모델
/// 건강보험심사평가원 의료기관별상세정보서비스 - 특수진료정보
@freezed
class SpecialDiagnosisInfo with _$SpecialDiagnosisInfo {
  const factory SpecialDiagnosisInfo({
    required String searchCode, // 검색코드 (srchCd)
    required String searchCodeName, // 검색코드명 (srchCdNm)
  }) = _SpecialDiagnosisInfo;

  factory SpecialDiagnosisInfo.fromJson(Map<String, dynamic> json) =>
      _$SpecialDiagnosisInfoFromJson(json);

  /// HIRA API 응답에서 변환
  factory SpecialDiagnosisInfo.fromHiraApi(Map<String, dynamic> json) {
    return SpecialDiagnosisInfo(
      searchCode: json['srchCd']?.toString() ?? '',
      searchCodeName: json['srchCdNm']?.toString() ?? '',
    );
  }
}
