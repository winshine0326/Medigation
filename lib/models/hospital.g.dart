// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hospital.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HospitalImpl _$$HospitalImplFromJson(
  Map<String, dynamic> json,
) => _$HospitalImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  address: json['address'] as String,
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  evaluations:
      (json['evaluations'] as List<dynamic>?)
          ?.map((e) => HospitalEvaluation.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  nonCoveredPrices:
      (json['nonCoveredPrices'] as List<dynamic>?)
          ?.map((e) => NonCoveredPrice.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  reviewStatistics:
      json['reviewStatistics'] == null
          ? null
          : ReviewStatistics.fromJson(
            json['reviewStatistics'] as Map<String, dynamic>,
          ),
  specialistInfoList:
      (json['specialistInfoList'] as List<dynamic>?)
          ?.map((e) => SpecialistInfo.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  nursingGradeInfoList:
      (json['nursingGradeInfoList'] as List<dynamic>?)
          ?.map((e) => NursingGradeInfo.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  specialDiagnosisInfoList:
      (json['specialDiagnosisInfoList'] as List<dynamic>?)
          ?.map((e) => SpecialDiagnosisInfo.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$HospitalImplToJson(_$HospitalImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'evaluations': instance.evaluations,
      'nonCoveredPrices': instance.nonCoveredPrices,
      'reviewStatistics': instance.reviewStatistics,
      'specialistInfoList': instance.specialistInfoList,
      'nursingGradeInfoList': instance.nursingGradeInfoList,
      'specialDiagnosisInfoList': instance.specialDiagnosisInfoList,
    };
