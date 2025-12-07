// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'specialist_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SpecialistInfoImpl _$$SpecialistInfoImplFromJson(Map<String, dynamic> json) =>
    _$SpecialistInfoImpl(
      specialtyCode: json['specialtyCode'] as String,
      specialtyName: json['specialtyName'] as String,
      specialistCount: (json['specialistCount'] as num).toInt(),
    );

Map<String, dynamic> _$$SpecialistInfoImplToJson(
  _$SpecialistInfoImpl instance,
) => <String, dynamic>{
  'specialtyCode': instance.specialtyCode,
  'specialtyName': instance.specialtyName,
  'specialistCount': instance.specialistCount,
};
