import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';

part 'badge.freezed.dart';
part 'badge.g.dart';

/// 배지 타입 (전문 분야별)
enum BadgeType {
  stroke, // 뇌졸중
  heartAttack, // 심근경색
  pneumonia, // 폐렴
  surgery, // 수술
  emergency, // 응급
  maternity, // 산부인과
  pediatrics, // 소아과
  orthopedics, // 정형외과
  dentistry, // 치과
  dermatology, // 피부과
  ophthalmology, // 안과
  ent, // 이비인후과
  psychiatry, // 정신과
  cardiology, // 심장내과
  neurology, // 신경과
  oncology, // 종양학
  urology, // 비뇨기과
  gastroenterology, // 소화기내과
  general, // 일반
}

/// 배지 아이콘 및 색상 매핑
extension BadgeTypeExtension on BadgeType {
  /// 배지 아이콘
  IconData get icon {
    switch (this) {
      case BadgeType.stroke:
        return Icons.psychology;
      case BadgeType.heartAttack:
        return Icons.favorite;
      case BadgeType.pneumonia:
        return Icons.air;
      case BadgeType.surgery:
        return Icons.medical_services;
      case BadgeType.emergency:
        return Icons.emergency;
      case BadgeType.maternity:
        return Icons.pregnant_woman;
      case BadgeType.pediatrics:
        return Icons.child_care;
      case BadgeType.orthopedics:
        return Icons.accessible;
      case BadgeType.dentistry:
        return Icons.medication;
      case BadgeType.dermatology:
        return Icons.spa;
      case BadgeType.ophthalmology:
        return Icons.remove_red_eye;
      case BadgeType.ent:
        return Icons.hearing;
      case BadgeType.psychiatry:
        return Icons.psychology_alt;
      case BadgeType.cardiology:
        return Icons.monitor_heart;
      case BadgeType.neurology:
        return Icons.psychology; // 신경과 (뇌 관련)
      case BadgeType.oncology:
        return Icons.science;
      case BadgeType.urology:
        return Icons.health_and_safety;
      case BadgeType.gastroenterology:
        return Icons.restaurant;
      case BadgeType.general:
        return Icons.local_hospital;
    }
  }

  /// 배지 색상
  Color get color {
    switch (this) {
      case BadgeType.stroke:
        return const Color(0xFFE57373); // 빨강
      case BadgeType.heartAttack:
        return const Color(0xFFEC407A); // 분홍
      case BadgeType.pneumonia:
        return const Color(0xFF64B5F6); // 파랑
      case BadgeType.surgery:
        return const Color(0xFF81C784); // 초록
      case BadgeType.emergency:
        return const Color(0xFFFF5252); // 진한 빨강
      case BadgeType.maternity:
        return const Color(0xFFBA68C8); // 보라
      case BadgeType.pediatrics:
        return const Color(0xFFFFB74D); // 주황
      case BadgeType.orthopedics:
        return const Color(0xFF90A4AE); // 회색
      case BadgeType.dentistry:
        return const Color(0xFF4DD0E1); // 청록
      case BadgeType.dermatology:
        return const Color(0xFFA1887F); // 갈색
      case BadgeType.ophthalmology:
        return const Color(0xFF7986CB); // 남색
      case BadgeType.ent:
        return const Color(0xFF4DB6AC); // 틸
      case BadgeType.psychiatry:
        return const Color(0xFF9575CD); // 연보라
      case BadgeType.cardiology:
        return const Color(0xFFEF5350); // 심장 빨강
      case BadgeType.neurology:
        return const Color(0xFF5C6BC0); // 진한 파랑
      case BadgeType.oncology:
        return const Color(0xFFAB47BC); // 자주
      case BadgeType.urology:
        return const Color(0xFF42A5F5); // 밝은 파랑
      case BadgeType.gastroenterology:
        return const Color(0xFFFFCA28); // 노랑
      case BadgeType.general:
        return const Color(0xFF66BB6A); // 밝은 초록
    }
  }
}

/// 배지 모델
/// 평가 데이터를 사용자가 쉽게 이해할 수 있는 배지로 변환
@freezed
class Badge with _$Badge {
  const factory Badge({
    required BadgeType type, // 배지 타입
    required String label, // 배지 레이블 (예: "뇌졸중 수술 전문")
    String? description, // 배지 설명 (선택사항)
  }) = _Badge;

  factory Badge.fromJson(Map<String, dynamic> json) => _$BadgeFromJson(json);
}
