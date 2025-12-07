import 'package:freezed_annotation/freezed_annotation.dart';

part 'specialist_info.freezed.dart';
part 'specialist_info.g.dart';

/// 전문과목별 전문의 정보 모델
/// 건강보험심사평가원 의료기관별상세정보서비스 - 전문과목별 전문의 수
@freezed
class SpecialistInfo with _$SpecialistInfo {
  const factory SpecialistInfo({
    required String specialtyCode, // 진료과목코드 (dgsbjtCd)
    required String specialtyName, // 진료과목명 (dgsbjtCdNm)
    required int specialistCount, // 전문의 수 (dtlSdrCnt)
  }) = _SpecialistInfo;

  factory SpecialistInfo.fromJson(Map<String, dynamic> json) =>
      _$SpecialistInfoFromJson(json);

  /// HIRA API 응답에서 변환
  factory SpecialistInfo.fromHiraApi(Map<String, dynamic> json) {
    return SpecialistInfo(
      specialtyCode: json['dgsbjtCd']?.toString() ?? '',
      specialtyName: json['dgsbjtCdNm']?.toString() ?? '',
      specialistCount: int.tryParse(json['dtlSdrCnt']?.toString() ?? '0') ?? 0,
    );
  }
}
