import 'package:flutter_test/flutter_test.dart';
import 'package:medigation/constants/badge_mappings.dart';
import 'package:medigation/models/badge.dart';
import 'package:medigation/models/hospital_evaluation.dart';
import 'package:medigation/utils/badge_generator.dart';

void main() {
  group('BadgeGenerator Tests', () {
    test('1등급 뇌졸중 평가에서 배지 생성', () {
      final evaluation = HospitalEvaluation(
        evaluationItem: '급성기 뇌졸중 적정성 평가',
        grade: '1등급',
        badges: [],
      );

      final badge = BadgeGenerator.generateFromEvaluation(evaluation);

      expect(badge, isNotNull);
      expect(badge!.type, BadgeType.stroke);
      expect(badge.label, contains('뇌졸중'));
      expect(badge.label, contains('우수'));
    });

    test('2등급 심근경색 평가에서 배지 생성 (우수 수식어 없음)', () {
      final evaluation = HospitalEvaluation(
        evaluationItem: '급성 심근경색 적정성 평가',
        grade: '2등급',
        badges: [],
      );

      final badge = BadgeGenerator.generateFromEvaluation(evaluation);

      expect(badge, isNotNull);
      expect(badge!.type, BadgeType.heartAttack);
      expect(badge.label, contains('심근경색'));
      expect(badge.label, isNot(contains('우수')));
    });

    test('3등급 평가에서는 배지 생성 안 함', () {
      final evaluation = HospitalEvaluation(
        evaluationItem: '급성기 뇌졸중 적정성 평가',
        grade: '3등급',
        badges: [],
      );

      final badge = BadgeGenerator.generateFromEvaluation(evaluation);

      expect(badge, isNull);
    });

    test('매핑되지 않은 평가 항목에서는 배지 생성 안 함', () {
      final evaluation = HospitalEvaluation(
        evaluationItem: '알 수 없는 평가 항목',
        grade: '1등급',
        badges: [],
      );

      final badge = BadgeGenerator.generateFromEvaluation(evaluation);

      expect(badge, isNull);
    });

    test('여러 평가에서 배지 목록 생성', () {
      final evaluations = [
        HospitalEvaluation(
          evaluationItem: '급성기 뇌졸중 적정성 평가',
          grade: '1등급',
          badges: [],
        ),
        HospitalEvaluation(
          evaluationItem: '급성 심근경색 적정성 평가',
          grade: '2등급',
          badges: [],
        ),
        HospitalEvaluation(
          evaluationItem: '폐렴 적정성 평가',
          grade: '3등급', // 3등급이므로 배지 생성 안 됨
          badges: [],
        ),
      ];

      final badges = BadgeGenerator.generateFromEvaluations(evaluations);

      expect(badges.length, 2); // 뇌졸중, 심근경색만
      expect(badges.any((b) => b.type == BadgeType.stroke), isTrue);
      expect(badges.any((b) => b.type == BadgeType.heartAttack), isTrue);
    });

    test('배지 라벨 문자열 생성', () {
      final labels = BadgeGenerator.generateBadgeLabels(
        '급성기 뇌졸중 적정성 평가',
        '1등급',
      );

      expect(labels.length, 1);
      expect(labels.first, contains('뇌졸중'));
      expect(labels.first, contains('우수'));
    });

    test('중복 배지 제거 - 같은 타입은 1개만', () {
      final badges = [
        Badge(type: BadgeType.stroke, label: '우수 뇌졸중 전문'),
        Badge(type: BadgeType.stroke, label: '뇌졸중 전문'),
        Badge(type: BadgeType.heartAttack, label: '심근경색 전문'),
      ];

      final topBadges = BadgeGenerator.selectTopBadges(badges, maxCount: 10);

      // 뇌졸중 타입은 1개만 남아야 함 (우수가 포함된 것 우선)
      final strokeBadges = topBadges.where((b) => b.type == BadgeType.stroke);
      expect(strokeBadges.length, 1);
      expect(strokeBadges.first.label, contains('우수'));
    });

    test('배지 우선순위 정렬 - 중증질환이 먼저', () {
      final badges = [
        Badge(type: BadgeType.dentistry, label: '치과 전문'), // 우선순위 낮음
        Badge(type: BadgeType.stroke, label: '뇌졸중 전문'), // 우선순위 높음
        Badge(type: BadgeType.surgery, label: '수술 전문'), // 우선순위 중간
      ];

      final topBadges = BadgeGenerator.selectTopBadges(badges);

      expect(topBadges.length, 3);
      expect(topBadges[0].type, BadgeType.stroke); // 뇌졸중이 첫 번째
      expect(topBadges[1].type, BadgeType.surgery); // 수술이 두 번째
      expect(topBadges[2].type, BadgeType.dentistry); // 치과가 세 번째
    });

    test('최대 개수 제한', () {
      final badges = [
        Badge(type: BadgeType.stroke, label: '뇌졸중 전문'),
        Badge(type: BadgeType.heartAttack, label: '심근경색 전문'),
        Badge(type: BadgeType.surgery, label: '수술 전문'),
        Badge(type: BadgeType.dentistry, label: '치과 전문'),
      ];

      final topBadges = BadgeGenerator.selectTopBadges(badges, maxCount: 2);

      expect(topBadges.length, 2);
      // 우선순위가 높은 2개만 선택되어야 함
      expect(topBadges[0].type, BadgeType.stroke);
      expect(topBadges[1].type, BadgeType.heartAttack);
    });

    test('키워드 추출', () {
      final keywords = BadgeGenerator.extractKeywords('급성기 뇌졸중 적정성 평가');

      expect(keywords.isNotEmpty, isTrue);
      expect(keywords.any((k) => k.contains('뇌졸중')), isTrue);
    });

    test('배지 카테고리 분류', () {
      expect(
        BadgeGenerator.getBadgeCategory(BadgeType.stroke),
        '중증질환',
      );
      expect(
        BadgeGenerator.getBadgeCategory(BadgeType.surgery),
        '수술/치료',
      );
      expect(
        BadgeGenerator.getBadgeCategory(BadgeType.dentistry),
        '진료과',
      );
    });

    test('배지 상세 정보 반환', () {
      final badge = Badge(
        type: BadgeType.stroke,
        label: '우수 뇌졸중 전문',
        description: '뇌졸중 치료에 우수한 평가',
      );

      final details = BadgeGenerator.getBadgeDetails(badge);

      expect(details['label'], '우수 뇌졸중 전문');
      expect(details['description'], '뇌졸중 치료에 우수한 평가');
      expect(details['category'], '중증질환');
      expect(details['priority'], 1);
    });

    test('카테고리별 그룹화', () {
      final badges = [
        Badge(type: BadgeType.stroke, label: '뇌졸중 전문'),
        Badge(type: BadgeType.heartAttack, label: '심근경색 전문'),
        Badge(type: BadgeType.surgery, label: '수술 전문'),
        Badge(type: BadgeType.dentistry, label: '치과 전문'),
      ];

      final grouped = BadgeGenerator.groupByCategory(badges);

      expect(grouped['중증질환']?.length, 2); // 뇌졸중, 심근경색
      expect(grouped['수술/치료']?.length, 1); // 수술
      expect(grouped['진료과']?.length, 1); // 치과
    });

    test('필수 배지 보유 여부 확인', () {
      final hospitalBadges = [
        Badge(type: BadgeType.stroke, label: '뇌졸중 전문'),
        Badge(type: BadgeType.surgery, label: '수술 전문'),
      ];

      // 뇌졸중 배지 필수 - 보유
      expect(
        BadgeGenerator.hasRequiredBadges(
          [BadgeType.stroke],
          hospitalBadges,
        ),
        isTrue,
      );

      // 심근경색 배지 필수 - 미보유
      expect(
        BadgeGenerator.hasRequiredBadges(
          [BadgeType.heartAttack],
          hospitalBadges,
        ),
        isFalse,
      );

      // 뇌졸중 + 수술 배지 모두 필수 - 보유
      expect(
        BadgeGenerator.hasRequiredBadges(
          [BadgeType.stroke, BadgeType.surgery],
          hospitalBadges,
        ),
        isTrue,
      );
    });
  });

  group('BadgeMappings Tests', () {
    test('평가 항목에서 매핑 찾기', () {
      final mapping = BadgeMappings.findMapping('급성기 뇌졸중 적정성 평가');

      expect(mapping, isNotNull);
      expect(mapping!.type, BadgeType.stroke);
    });

    test('매핑되지 않은 항목은 null 반환', () {
      final mapping = BadgeMappings.findMapping('알 수 없는 평가 항목');

      expect(mapping, isNull);
    });

    test('1~2등급만 배지 생성 자격 충족', () {
      expect(BadgeMappings.isQualifiedGrade('1등급'), isTrue);
      expect(BadgeMappings.isQualifiedGrade('2등급'), isTrue);
      expect(BadgeMappings.isQualifiedGrade('3등급'), isFalse);
      expect(BadgeMappings.isQualifiedGrade('4등급'), isFalse);
      expect(BadgeMappings.isQualifiedGrade('5등급'), isFalse);
    });

    test('1등급은 "우수" 수식어 추가', () {
      expect(BadgeMappings.getGradeModifier('1등급'), '우수 ');
      expect(BadgeMappings.getGradeModifier('2등급'), '');
      expect(BadgeMappings.getGradeModifier('3등급'), '');
    });
  });
}
