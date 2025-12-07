// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hospital_evaluation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HospitalEvaluationImpl _$$HospitalEvaluationImplFromJson(
  Map<String, dynamic> json,
) => _$HospitalEvaluationImpl(
  evaluationItem: json['evaluationItem'] as String,
  grade: json['grade'] as String,
  badges: (json['badges'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$$HospitalEvaluationImplToJson(
  _$HospitalEvaluationImpl instance,
) => <String, dynamic>{
  'evaluationItem': instance.evaluationItem,
  'grade': instance.grade,
  'badges': instance.badges,
};
