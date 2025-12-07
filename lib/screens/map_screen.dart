import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/hospital.dart';
import '../providers/hospital_list_provider.dart';
import '../providers/location_provider.dart';
import '../providers/bookmark_provider.dart';
import '../widgets/hospital_card.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/error_display.dart';

/// 지도 화면
/// Google Maps를 사용하여 병원 위치를 표시
class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  GoogleMapController? _mapController;
  Hospital? _selectedHospital;
  Set<Marker> _markers = {};

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hospitalListState = ref.watch(hospitalListNotifierProvider);
    final locationState = ref.watch(locationNotifierProvider);

    // 초기 카메라 위치 (현재 위치 또는 서울 시청)
    final initialPosition = locationState.hasLocation
        ? LatLng(
            locationState.currentPosition!.latitude,
            locationState.currentPosition!.longitude,
          )
        : const LatLng(37.5665, 126.9780); // 서울 시청

    return Scaffold(
      appBar: AppBar(
        title: const Text('지도'),
        actions: [
          // 현재 위치로 이동 버튼
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: locationState.hasLocation
                ? () => _moveToCurrentLocation(locationState)
                : null,
          ),
          // 새로고침 버튼
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(hospitalListNotifierProvider.notifier).refresh();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // 지도
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: initialPosition,
              zoom: 14,
            ),
            onMapCreated: _onMapCreated,
            markers: _markers,
            myLocationEnabled: locationState.hasLocation,
            myLocationButtonEnabled: false,
            onTap: (_) {
              // 지도 탭 시 선택 해제
              setState(() {
                _selectedHospital = null;
              });
            },
          ),

          // 로딩 인디케이터
          if (hospitalListState.isLoading && hospitalListState.hospitals.isEmpty)
            const Positioned.fill(
              child: LoadingIndicator(message: '병원 정보 로딩 중...'),
            ),

          // 에러 표시
          if (hospitalListState.error != null &&
              hospitalListState.hospitals.isEmpty)
            Positioned.fill(
              child: ErrorDisplay(
                message: hospitalListState.error!,
                onRetry: () {
                  ref.read(hospitalListNotifierProvider.notifier).loadHospitals();
                },
              ),
            ),

          // 선택된 병원 카드 (하단)
          if (_selectedHospital != null)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _buildSelectedHospitalCard(_selectedHospital!),
            ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 현재 위치 주변 병원 검색
          if (locationState.hasLocation)
            FloatingActionButton(
              heroTag: 'search_nearby',
              onPressed: () {
                ref
                    .read(locationNotifierProvider.notifier)
                    .searchNearbyHospitals();
              },
              tooltip: '주변 병원 검색',
              child: const Icon(Icons.search),
            ),
        ],
      ),
    );
  }

  /// 지도 생성 콜백
  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _updateMarkers();
  }

  /// 마커 업데이트
  void _updateMarkers() {
    final hospitals = ref.read(hospitalListNotifierProvider).hospitals;
    final newMarkers = <Marker>{};

    for (final hospital in hospitals) {
      final marker = Marker(
        markerId: MarkerId(hospital.id),
        position: LatLng(hospital.latitude, hospital.longitude),
        infoWindow: InfoWindow(
          title: hospital.name,
          snippet: hospital.address,
        ),
        onTap: () {
          setState(() {
            _selectedHospital = hospital;
          });
        },
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueRed,
        ),
      );
      newMarkers.add(marker);
    }

    setState(() {
      _markers = newMarkers;
    });
  }

  /// 현재 위치로 이동
  void _moveToCurrentLocation(LocationState locationState) {
    if (locationState.currentPosition != null && _mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              locationState.currentPosition!.latitude,
              locationState.currentPosition!.longitude,
            ),
            zoom: 14,
          ),
        ),
      );
    }
  }

  /// 선택된 병원 카드
  Widget _buildSelectedHospitalCard(Hospital hospital) {
    final bookmarkState = ref.watch(bookmarkNotifierProvider);
    final locationState = ref.watch(locationNotifierProvider);
    final isBookmarked = bookmarkState.isBookmarked(hospital.id);
    final distance = locationState.hasLocation
        ? ref
            .read(locationNotifierProvider.notifier)
            .getDistanceToHospital(hospital)
        : null;

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 닫기 버튼
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    _selectedHospital = null;
                  });
                },
              ),
            ],
          ),

          // 병원 카드
          HospitalCard(
            hospital: hospital,
            isBookmarked: isBookmarked,
            distance: distance,
            onTap: () {
              Navigator.pushNamed(
                context,
                '/hospital-detail',
                arguments: hospital,
              );
            },
            onBookmarkTap: () {
              ref
                  .read(bookmarkNotifierProvider.notifier)
                  .toggleBookmark(hospital.id);
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
