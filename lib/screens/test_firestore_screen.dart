import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/hospital.dart';
import '../models/hospital_evaluation.dart';
import '../models/non_covered_price.dart';
import '../models/review_statistics.dart';
import '../repositories/hospital_repository.dart';

/// Firestore 연결 테스트 화면
class TestFirestoreScreen extends ConsumerWidget {
  const TestFirestoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hospitalRepository = ref.watch(hospitalRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Firestore 연결 테스트'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.local_hospital,
              size: 80,
              color: Colors.blue,
            ),
            const SizedBox(height: 20),
            const Text(
              'Firestore 연결 테스트',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () async {
                try {
                  // 테스트 데이터 생성
                  final testHospital = Hospital(
                    id: 'test_hospital_001',
                    name: '서울대학교병원',
                    address: '서울특별시 종로구 대학로 101',
                    latitude: 37.5796,
                    longitude: 127.0018,
                    evaluations: [
                      const HospitalEvaluation(
                        evaluationItem: '급성기 뇌졸중 적정성 평가',
                        grade: '1등급',
                        badges: ['뇌졸중 수술 전문'],
                      ),
                    ],
                    nonCoveredPrices: [
                      const NonCoveredPrice(
                        item: 'MRI 검사',
                        price: 500000,
                      ),
                    ],
                    reviewStatistics: const ReviewStatistics(
                      averageRating: 4.5,
                      totalReviewCount: 1234,
                      keywords: ['친절', '전문적', '시설 좋음'],
                    ),
                  );

                  // Firestore에 데이터 추가
                  await hospitalRepository.addHospital(testHospital);

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('테스트 병원 데이터가 성공적으로 추가되었습니다!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('오류 발생: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              icon: const Icon(Icons.add),
              label: const Text('테스트 데이터 추가'),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () async {
                try {
                  // Firestore에서 데이터 조회
                  final hospitals = await hospitalRepository.getAllHospitals();

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('총 ${hospitals.length}개의 병원 데이터를 찾았습니다!'),
                        backgroundColor: Colors.blue,
                      ),
                    );

                    // 데이터 출력
                    for (var hospital in hospitals) {
                      print('병원: ${hospital.name}');
                      print('주소: ${hospital.address}');
                      print('평가: ${hospital.evaluations.length}개');
                      print('---');
                    }
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('오류 발생: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              icon: const Icon(Icons.search),
              label: const Text('데이터 조회'),
            ),
          ],
        ),
      ),
    );
  }
}
