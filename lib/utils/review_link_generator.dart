import 'package:medigation/models/hospital.dart';
import 'package:url_launcher/url_launcher.dart';

/// 외부 리뷰 플랫폼 링크 생성 및 실행 유틸리티
class ReviewLinkGenerator {
  /// 네이버 지도 검색 URL 생성
  ///
  /// 병원 이름과 주소로 네이버 지도 검색 페이지를 엽니다.
  static String generateNaverMapUrl(Hospital hospital) {
    // 병원 이름 + 주소로 검색 쿼리 구성
    final query = Uri.encodeComponent('${hospital.name} ${hospital.address}');
    return 'https://m.map.naver.com/search2/search.naver?query=$query';
  }

  /// 네이버 지도 앱/웹 열기
  static Future<bool> openNaverMap(Hospital hospital) async {
    final url = generateNaverMapUrl(hospital);
    final uri = Uri.parse(url);

    // 먼저 앱으로 열기 시도 (nmap:// 스킴)
    final appUri = Uri.parse(
        'nmap://search?query=${Uri.encodeComponent(hospital.name)}&appname=com.medigation');

    try {
      if (await canLaunchUrl(appUri)) {
        return await launchUrl(appUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      // 앱 스킴 실패 시 웹으로 fallback
    }

    // 웹 브라우저로 열기
    if (await canLaunchUrl(uri)) {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    }

    return false;
  }

  /// 카카오맵 검색 URL 생성
  ///
  /// 병원 이름과 좌표로 카카오맵 검색 페이지를 엽니다.
  static String generateKakaoMapUrl(Hospital hospital) {
    // 병원 이름으로 검색
    final query = Uri.encodeComponent(hospital.name);
    return 'https://map.kakao.com/?q=$query';
  }

  /// 카카오맵 앱/웹 열기
  static Future<bool> openKakaoMap(Hospital hospital) async {
    final url = generateKakaoMapUrl(hospital);
    final uri = Uri.parse(url);

    // 먼저 앱으로 열기 시도 (kakaomap:// 스킴)
    final appUri = Uri.parse(
        'kakaomap://search?q=${Uri.encodeComponent(hospital.name)}&p=${hospital.latitude},${hospital.longitude}');

    try {
      if (await canLaunchUrl(appUri)) {
        return await launchUrl(appUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      // 앱 스킴 실패 시 웹으로 fallback
    }

    // 웹 브라우저로 열기
    if (await canLaunchUrl(uri)) {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    }

    return false;
  }

  /// Google Maps URL 생성 (보조 기능)
  static String generateGoogleMapUrl(Hospital hospital) {
    // 좌표로 Google Maps 열기
    return 'https://www.google.com/maps/search/?api=1&query=${hospital.latitude},${hospital.longitude}';
  }

  /// Google Maps 앱/웹 열기
  static Future<bool> openGoogleMap(Hospital hospital) async {
    final url = generateGoogleMapUrl(hospital);
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    }

    return false;
  }

  /// 전화 걸기 (병원 전화번호가 있을 경우)
  static Future<bool> makePhoneCall(String phoneNumber) async {
    // 전화번호에서 특수문자 제거
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    final uri = Uri.parse('tel:$cleanNumber');

    if (await canLaunchUrl(uri)) {
      return await launchUrl(uri);
    }

    return false;
  }

  /// 웹사이트 열기 (병원 웹사이트가 있을 경우)
  static Future<bool> openWebsite(String websiteUrl) async {
    final uri = Uri.parse(websiteUrl);

    if (await canLaunchUrl(uri)) {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    }

    return false;
  }

  /// 리뷰 플랫폼 이름 반환
  static String getPlatformName(ReviewPlatform platform) {
    switch (platform) {
      case ReviewPlatform.naver:
        return '네이버 지도';
      case ReviewPlatform.kakao:
        return '카카오맵';
      case ReviewPlatform.google:
        return 'Google Maps';
    }
  }

  /// 리뷰 플랫폼 아이콘 반환 (UI용)
  static String getPlatformIcon(ReviewPlatform platform) {
    switch (platform) {
      case ReviewPlatform.naver:
        return '🟢'; // 네이버 녹색
      case ReviewPlatform.kakao:
        return '🟡'; // 카카오 노란색
      case ReviewPlatform.google:
        return '🔵'; // 구글 파란색
    }
  }

  /// 리뷰 플랫폼별로 URL 열기
  static Future<bool> openPlatform(
      Hospital hospital, ReviewPlatform platform) async {
    switch (platform) {
      case ReviewPlatform.naver:
        return await openNaverMap(hospital);
      case ReviewPlatform.kakao:
        return await openKakaoMap(hospital);
      case ReviewPlatform.google:
        return await openGoogleMap(hospital);
    }
  }
}

/// 리뷰 플랫폼 enum
enum ReviewPlatform {
  naver, // 네이버 지도
  kakao, // 카카오맵
  google, // Google Maps
}

/// 리뷰 플랫폼 정보 클래스
class ReviewPlatformInfo {
  final ReviewPlatform platform;
  final String name;
  final String icon;
  final String Function(Hospital) urlGenerator;

  ReviewPlatformInfo({
    required this.platform,
    required this.name,
    required this.icon,
    required this.urlGenerator,
  });

  /// 모든 플랫폼 정보 반환
  static List<ReviewPlatformInfo> getAllPlatforms() {
    return [
      ReviewPlatformInfo(
        platform: ReviewPlatform.naver,
        name: '네이버 지도',
        icon: '🟢',
        urlGenerator: ReviewLinkGenerator.generateNaverMapUrl,
      ),
      ReviewPlatformInfo(
        platform: ReviewPlatform.kakao,
        name: '카카오맵',
        icon: '🟡',
        urlGenerator: ReviewLinkGenerator.generateKakaoMapUrl,
      ),
      ReviewPlatformInfo(
        platform: ReviewPlatform.google,
        name: 'Google Maps',
        icon: '🔵',
        urlGenerator: ReviewLinkGenerator.generateGoogleMapUrl,
      ),
    ];
  }
}
