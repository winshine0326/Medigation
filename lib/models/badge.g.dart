// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'badge.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BadgeImpl _$$BadgeImplFromJson(Map<String, dynamic> json) => _$BadgeImpl(
  type: $enumDecode(_$BadgeTypeEnumMap, json['type']),
  label: json['label'] as String,
  description: json['description'] as String?,
);

Map<String, dynamic> _$$BadgeImplToJson(_$BadgeImpl instance) =>
    <String, dynamic>{
      'type': _$BadgeTypeEnumMap[instance.type]!,
      'label': instance.label,
      'description': instance.description,
    };

const _$BadgeTypeEnumMap = {
  BadgeType.stroke: 'stroke',
  BadgeType.heartAttack: 'heartAttack',
  BadgeType.pneumonia: 'pneumonia',
  BadgeType.surgery: 'surgery',
  BadgeType.emergency: 'emergency',
  BadgeType.maternity: 'maternity',
  BadgeType.pediatrics: 'pediatrics',
  BadgeType.orthopedics: 'orthopedics',
  BadgeType.dentistry: 'dentistry',
  BadgeType.dermatology: 'dermatology',
  BadgeType.ophthalmology: 'ophthalmology',
  BadgeType.ent: 'ent',
  BadgeType.psychiatry: 'psychiatry',
  BadgeType.cardiology: 'cardiology',
  BadgeType.neurology: 'neurology',
  BadgeType.oncology: 'oncology',
  BadgeType.urology: 'urology',
  BadgeType.gastroenterology: 'gastroenterology',
  BadgeType.general: 'general',
};
