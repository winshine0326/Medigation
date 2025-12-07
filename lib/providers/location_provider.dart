import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/hospital.dart';
import '../repositories/hospital_repository.dart';

part 'location_provider.g.dart';

/// 위치 권한 상태
enum LocationPermissionStatus {
  granted,
  denied,
  deniedForever,
  notDetermined,
}

/// 위치 상태
class LocationState {
  final Position? currentPosition;
  final LocationPermissionStatus permissionStatus;
  final bool isLoading;
  final String? error;
  final List<Hospital> nearbyHospitals;

  const LocationState({
    this.currentPosition,
    this.permissionStatus = LocationPermissionStatus.notDetermined,
    this.isLoading = false,
    this.error,
    this.nearbyHospitals = const [],
  });

  LocationState copyWith({
    Position? currentPosition,
    LocationPermissionStatus? permissionStatus,
    bool? isLoading,
    String? error,
    List<Hospital>? nearbyHospitals,
  }) {
    return LocationState(
      currentPosition: currentPosition ?? this.currentPosition,
      permissionStatus: permissionStatus ?? this.permissionStatus,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      nearbyHospitals: nearbyHospitals ?? this.nearbyHospitals,
    );
  }

  /// 위치가 사용 가능한지 확인
  bool get hasLocation => currentPosition != null;

  /// 위치 권한이 승인되었는지 확인
  bool get hasPermission => permissionStatus == LocationPermissionStatus.granted;
}

/// 위치 Notifier
/// 현재 위치 및 위치 권한을 관리합니다
@riverpod
class LocationNotifier extends _$LocationNotifier {
  @override
  LocationState build() {
    _checkPermission();
    return const LocationState();
  }

  /// 위치 권한 확인
  Future<void> _checkPermission() async {
    try {
      final permission = await Geolocator.checkPermission();
      final status = _mapPermissionStatus(permission);
      state = state.copyWith(permissionStatus: status);
    } catch (e) {
      print('위치 권한 확인 실패: $e');
    }
  }

  /// 위치 권한 요청
  Future<bool> requestPermission() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // 위치 서비스 활성화 확인
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        state = state.copyWith(
          isLoading: false,
          error: '위치 서비스가 비활성화되어 있습니다. 설정에서 위치 서비스를 활성화해주세요.',
        );
        return false;
      }

      // 권한 확인
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      final status = _mapPermissionStatus(permission);
      state = state.copyWith(
        permissionStatus: status,
        isLoading: false,
      );

      if (status == LocationPermissionStatus.granted) {
        await getCurrentLocation();
        return true;
      }

      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  /// 현재 위치 가져오기
  Future<void> getCurrentLocation() async {
    if (!state.hasPermission) {
      final granted = await requestPermission();
      if (!granted) return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      state = state.copyWith(
        currentPosition: position,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '현재 위치를 가져올 수 없습니다: $e',
      );
    }
  }

  /// 주변 병원 검색
  Future<void> searchNearbyHospitals({double radiusKm = 5.0}) async {
    if (!state.hasLocation) {
      await getCurrentLocation();
      if (!state.hasLocation) return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final repository = ref.read(hospitalRepositoryProvider);
      final position = state.currentPosition!;

      final hospitals = await repository.getNearbyHospitals(
        latitude: position.latitude,
        longitude: position.longitude,
        radiusKm: radiusKm,
      );

      state = state.copyWith(
        nearbyHospitals: hospitals,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '주변 병원 검색에 실패했습니다: $e',
      );
    }
  }

  /// 병원 목록을 거리순으로 정렬
  List<Hospital> sortHospitalsByDistance(List<Hospital> hospitals) {
    if (!state.hasLocation) return hospitals;

    final position = state.currentPosition!;
    final sortedHospitals = List<Hospital>.from(hospitals);

    sortedHospitals.sort((a, b) {
      final distA = _calculateDistance(
        position.latitude,
        position.longitude,
        a.latitude,
        a.longitude,
      );
      final distB = _calculateDistance(
        position.latitude,
        position.longitude,
        b.latitude,
        b.longitude,
      );
      return distA.compareTo(distB);
    });

    return sortedHospitals;
  }

  /// 특정 병원까지의 거리 계산
  double? getDistanceToHospital(Hospital hospital) {
    if (!state.hasLocation) return null;

    final position = state.currentPosition!;
    return _calculateDistance(
      position.latitude,
      position.longitude,
      hospital.latitude,
      hospital.longitude,
    );
  }

  /// 위치 권한 상태 매핑
  LocationPermissionStatus _mapPermissionStatus(LocationPermission permission) {
    switch (permission) {
      case LocationPermission.always:
      case LocationPermission.whileInUse:
        return LocationPermissionStatus.granted;
      case LocationPermission.denied:
        return LocationPermissionStatus.denied;
      case LocationPermission.deniedForever:
        return LocationPermissionStatus.deniedForever;
      default:
        return LocationPermissionStatus.notDetermined;
    }
  }

  /// 두 지점 간의 거리 계산 (Haversine formula)
  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2) / 1000; // km
  }

  /// 위치 정보 새로고침
  Future<void> refresh() async {
    await getCurrentLocation();
  }
}
