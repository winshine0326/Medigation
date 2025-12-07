import 'dart:math' show asin, sqrt;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/hospital.dart';
import '../data_sources/firebase_provider.dart';

part 'hospital_repository.g.dart';

/// 병원 데이터 Repository
/// Firestore와의 실제 통신을 담당하며, 데이터 소스를 추상화
class HospitalRepository {
  final CollectionReference<Map<String, dynamic>> _hospitalsCollection;

  HospitalRepository(this._hospitalsCollection);

  /// 모든 병원 목록을 가져옵니다
  Future<List<Hospital>> getAllHospitals() async {
    try {
      final snapshot = await _hospitalsCollection.get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return Hospital.fromJson(data);
      }).toList();
    } catch (e) {
      throw Exception('병원 목록을 가져오는데 실패했습니다: $e');
    }
  }

  /// 특정 병원의 상세 정보를 가져옵니다
  Future<Hospital?> getHospitalById(String hospitalId) async {
    try {
      final doc = await _hospitalsCollection.doc(hospitalId).get();
      if (!doc.exists) return null;

      final data = doc.data()!;
      data['id'] = doc.id;
      return Hospital.fromJson(data);
    } catch (e) {
      throw Exception('병원 정보를 가져오는데 실패했습니다: $e');
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
      // Firestore는 geohash를 직접 지원하지 않으므로
      // 모든 병원을 가져온 후 클라이언트에서 필터링
      final allHospitals = await getAllHospitals();

      return allHospitals.where((hospital) {
        final distance = _calculateDistance(
          latitude,
          longitude,
          hospital.latitude,
          hospital.longitude,
        );
        return distance <= radiusKm;
      }).toList();
    } catch (e) {
      throw Exception('주변 병원 검색에 실패했습니다: $e');
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
  return HospitalRepository(hospitalsCollection);
}
