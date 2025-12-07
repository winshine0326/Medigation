import 'dart:math' show asin, sqrt;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/hospital.dart';
import '../models/specialist_info.dart';
import '../models/nursing_grade_info.dart';
import '../models/special_diagnosis_info.dart';
import '../data_sources/firebase_provider.dart';
import '../data_sources/local_db_provider.dart';
import '../data_sources/hira_api_provider.dart';
import '../utils/hospital_score_calculator.dart';

part 'hospital_repository.g.dart';

/// 병원 데이터 Repository
/// 캐시 우선 로직으로 데이터를 제공
/// 1. 로컬 캐시 확인
/// 2. 캐시 없으면 Firestore에서 조회
/// 3. HIRA API로 평가/가격 데이터 보강
class HospitalRepository {
  final CollectionReference<Map<String, dynamic>> _hospitalsCollection;
  final LocalDbProvider _localDb;
  final HiraApiProvider _hiraApi;

  HospitalRepository(
    this._hospitalsCollection,
    this._localDb,
    this._hiraApi,
  );

  /// 모든 병원 목록을 가져옵니다 (캐시 우선)
  Future<List<Hospital>> getAllHospitals() async {
    try {
      // 1. 로컬 캐시 확인
      final cachedHospitals = await _localDb.getAllCachedHospitals();
      if (cachedHospitals.isNotEmpty) {
        return cachedHospitals;
      }

      // 2. Firestore에서 조회
      final snapshot = await _hospitalsCollection.get();
      final hospitals = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return Hospital.fromJson(data);
      }).toList();

      // 3. 로컬 캐시에 저장
      for (final hospital in hospitals) {
        await _localDb.cacheHospital(hospital);
      }

      return hospitals;
    } catch (e) {
      throw Exception('병원 목록을 가져오는데 실패했습니다: $e');
    }
  }

  /// 특정 병원의 상세 정보를 가져옵니다 (캐시 우선 + HIRA 데이터 보강)
  Future<Hospital?> getHospitalById(String hospitalId) async {
    try {
      // 1. 로컬 캐시 확인
      final cachedHospital = await _localDb.getCachedHospital(hospitalId);
      if (cachedHospital != null) {
        // 캐시된 데이터가 있지만 상세 정보가 비어있으면 보강 시도
        if (cachedHospital.specialistInfoList.isEmpty || 
            cachedHospital.nursingGradeInfoList.isEmpty || 
            cachedHospital.specialDiagnosisInfoList.isEmpty) {
           return await enrichHospitalDetails(cachedHospital);
        }
        return cachedHospital;
      }

      // 2. Firestore에서 조회
      final doc = await _hospitalsCollection.doc(hospitalId).get();
      if (!doc.exists) return null;

      final data = doc.data()!;
      data['id'] = doc.id;
      var hospital = Hospital.fromJson(data);

      // 3. HIRA API로 데이터 보강
      hospital = await enrichHospitalDetails(hospital);

      // 4. 로컬 캐시에 저장
      await _localDb.cacheHospital(hospital);

      return hospital;
    } catch (e) {
      throw Exception('병원 정보를 가져오는데 실패했습니다: $e');
    }
  }

  /// HIRA API를 통해 병원 상세 정보를 보강합니다
  Future<Hospital> enrichHospitalDetails(Hospital hospital) async {
    try {
      // 이미 데이터가 있으면 스킵 (선택적)
      // 여기서는 항상 최신 정보를 가져오도록 시도하거나, 비어있을 때만 가져오도록 할 수 있음
      // 병렬로 API 호출하여 속도 향상
      final results = await Future.wait([
        _hiraApi.getSpecialistInfo(hospital.id),
        _hiraApi.getNursingGradeInfo(hospital.id),
        _hiraApi.getSpecialDiagnosisInfo(hospital.id),
      ]);

      final specialistInfo = results[0] as List<SpecialistInfo>;
      final nursingGradeInfo = results[1] as List<NursingGradeInfo>;
      final specialDiagnosisInfo = results[2] as List<SpecialDiagnosisInfo>;

      // 데이터가 없으면 기존 데이터 유지 (또는 빈 리스트)
      final updatedHospital = hospital.copyWith(
        specialistInfoList: specialistInfo.isNotEmpty ? specialistInfo : hospital.specialistInfoList,
        nursingGradeInfoList: nursingGradeInfo.isNotEmpty ? nursingGradeInfo : hospital.nursingGradeInfoList,
        specialDiagnosisInfoList: specialDiagnosisInfo.isNotEmpty ? specialDiagnosisInfo : hospital.specialDiagnosisInfoList,
      );

      // 변경사항이 있으면 로컬 DB 업데이트
      if (specialistInfo.isNotEmpty || nursingGradeInfo.isNotEmpty || specialDiagnosisInfo.isNotEmpty) {
        await _localDb.cacheHospital(updatedHospital);
        // Firestore 업데이트는 선택적 (비용 절감 위해 로컬만 업데이트할 수도 있음)
        // await updateHospital(updatedHospital); 
      }

      return updatedHospital;
    } catch (e) {
      print('병원 상세 정보 보강 실패: $e');
      // 실패해도 기존 병원 정보 반환
      return hospital;
    }
  }

  /// 새로운 병원을 추가합니다
  Future<void> addHospital(Hospital hospital) async {
    try {
      await _hospitalsCollection.doc(hospital.id).set(hospital.toJson());
    } catch (e) {
      throw Exception('병원 추가에 실패했습니다: $e');
    }
  }

  /// 병원 정보를 업데이트합니다
  Future<void> updateHospital(Hospital hospital) async {
    try {
      await _hospitalsCollection.doc(hospital.id).update(hospital.toJson());
    } catch (e) {
      throw Exception('병원 정보 업데이트에 실패했습니다: $e');
    }
  }

  /// 위치 기반으로 주변 병원을 검색합니다
  Future<List<Hospital>> getNearbyHospitals({
    required double latitude,
    required double longitude,
    double radiusKm = 5.0,
  }) async {
    try {
      final allHospitals = await getAllHospitals();

      final nearbyHospitals = allHospitals.where((hospital) {
        final distance = _calculateDistance(
          latitude,
          longitude,
          hospital.latitude,
          hospital.longitude,
        );
        return distance <= radiusKm;
      }).toList();

      // 거리순으로 정렬
      nearbyHospitals.sort((a, b) {
        final distA = _calculateDistance(latitude, longitude, a.latitude, a.longitude);
        final distB = _calculateDistance(latitude, longitude, b.latitude, b.longitude);
        return distA.compareTo(distB);
      });

      return nearbyHospitals;
    } catch (e) {
      throw Exception('주변 병원 검색에 실패했습니다: $e');
    }
  }

  /// 병원 이름으로 검색
  Future<List<Hospital>> searchHospitalsByName(String query) async {
    try {
      if (query.trim().isEmpty) {
        return [];
      }

      final allHospitals = await getAllHospitals();
      final lowerQuery = query.toLowerCase();

      return allHospitals.where((hospital) {
        return hospital.name.toLowerCase().contains(lowerQuery) ||
            hospital.address.toLowerCase().contains(lowerQuery);
      }).toList();
    } catch (e) {
      throw Exception('병원 검색에 실패했습니다: $e');
    }
  }

  /// 배지 타입으로 병원 필터링
  Future<List<Hospital>> filterHospitalsByBadges(List<String> badgeTypes) async {
    try {
      if (badgeTypes.isEmpty) {
        return getAllHospitals();
      }

      final allHospitals = await getAllHospitals();

      return allHospitals.where((hospital) {
        // 병원의 평가에서 배지를 확인
        for (final evaluation in hospital.evaluations) {
          for (final badge in evaluation.badges) {
            if (badgeTypes.any((type) => badge.toLowerCase().contains(type.toLowerCase()))) {
              return true;
            }
          }
        }
        return false;
      }).toList();
    } catch (e) {
      throw Exception('병원 필터링에 실패했습니다: $e');
    }
  }

  /// 역필터링 및 상세 필터: 특정 조건을 만족하지 않는 병원 제외
  Future<List<Hospital>> filterOutHospitals({
    List<String>? selectedTotalGrades, // 선택된 종합 등급 목록 (S, A, B, C, D)
    int? minSpecialistCount, // 최소 전문의 수
    int? minDiagnosisCount, // 최소 특수 진료 수
  }) async {
    try {
      final allHospitals = await getAllHospitals();

      return allHospitals.where((hospital) {
        // 종합 등급 필터 (다중 선택)
        if (selectedTotalGrades != null && selectedTotalGrades.isNotEmpty) {
          final totalScore = HospitalScoreCalculator.calculateTotalScore(hospital);
          final grade = HospitalScoreCalculator.getScoreGrade(totalScore);
          
          if (!selectedTotalGrades.contains(grade)) {
            return false; // 선택된 등급에 포함되지 않으면 제외
          }
        }

        // 전문의 수 필터
        if (minSpecialistCount != null) {
          int totalSpecialists = 0;
          for (final info in hospital.specialistInfoList) {
            totalSpecialists += info.specialistCount;
          }
          if (totalSpecialists < minSpecialistCount) return false;
        }

        // 특수 진료 수 필터
        if (minDiagnosisCount != null) {
          if (hospital.specialDiagnosisInfoList.length < minDiagnosisCount) return false;
        }

        return true; // 포함
      }).toList();
    } catch (e) {
      throw Exception('병원 필터링에 실패했습니다: $e');
    }
  }

  /// 데이터 동기화: Firestore → 로컬 캐시
  Future<void> syncData() async {
    try {
      // 만료된 캐시 정리
      await _localDb.clearExpiredCache();

      // Firestore에서 최신 데이터 가져오기
      final hospitals = await getAllHospitals();

      print('데이터 동기화 완료: ${hospitals.length}개 병원');
    } catch (e) {
      throw Exception('데이터 동기화에 실패했습니다: $e');
    }
  }

  /// 캐시 초기화
  Future<void> clearCache() async {
    try {
      await _localDb.clearAllCache();
    } catch (e) {
      throw Exception('캐시 초기화에 실패했습니다: $e');
    }
  }

  /// HIRA API로 주변 병원 검색 (실시간)
  ///
  /// Firestore 캐시가 아닌 실시간 HIRA API 조회
  Future<List<Hospital>> searchNearbyHospitalsFromHira({
    required double latitude,
    required double longitude,
    int radiusInMeters = 5000,
    int numOfRows = 20,
  }) async {
    try {
      final hospitals = await _hiraApi.searchNearbyHospitals(
        latitude: latitude,
        longitude: longitude,
        radiusInMeters: radiusInMeters,
        numOfRows: numOfRows,
      );

      // Firestore에 저장 (캐싱)
      for (final hospital in hospitals) {
        try {
          await addHospital(hospital);
        } catch (e) {
          // 이미 존재하는 병원은 무시
          print('병원 저장 스킵 (이미 존재): ${hospital.id}');
        }
      }

      return hospitals;
    } catch (e) {
      print('HIRA API 주변 병원 검색 실패: $e');
      throw Exception('주변 병원 검색에 실패했습니다: $e');
    }
  }

  /// HIRA API로 병원명 검색 (실시간)
  Future<List<Hospital>> searchHospitalsByNameFromHira({
    required String hospitalName,
    int numOfRows = 20,
  }) async {
    try {
      final hospitals = await _hiraApi.searchByName(
        hospitalName: hospitalName,
        numOfRows: numOfRows,
      );

      // Firestore에 저장 (캐싱)
      for (final hospital in hospitals) {
        try {
          await addHospital(hospital);
        } catch (e) {
          // 이미 존재하는 병원은 무시
          print('병원 저장 스킵 (이미 존재): ${hospital.id}');
        }
      }

      return hospitals;
    } catch (e) {
      print('HIRA API 병원명 검색 실패: $e');
      throw Exception('병원 검색에 실패했습니다: $e');
    }
  }

  /// 두 지점 간의 거리를 계산합니다 (Haversine formula)
  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadius = 6371; // km
    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);

    final a =
        (dLat / 2) * (dLat / 2) +
        _toRadians(lat1) * _toRadians(lat2) *
        (dLon / 2) * (dLon / 2);
    final c = 2 * asin(sqrt(a));

    return earthRadius * c;
  }

  double _toRadians(double degree) {
    return degree * 3.14159265359 / 180;
  }
}

/// HospitalRepository Provider
@riverpod
HospitalRepository hospitalRepository(HospitalRepositoryRef ref) {
  final hospitalsCollection = ref.watch(hospitalsCollectionProvider);
  final localDb = ref.watch(localDbProviderProvider);
  final hiraApi = ref.watch(hiraApiProviderProvider);
  return HospitalRepository(hospitalsCollection, localDb, hiraApi);
}
