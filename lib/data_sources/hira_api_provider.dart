import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../constants/api_constants.dart';
import '../models/hospital.dart';

part 'hira_api_provider.g.dart';

/// 건강보험심사평가원 (HIRA) API Provider
/// 병원 기본 정보, 평가 데이터, 비급여 가격 데이터를 제공
class HiraApiProvider {
  final Dio _dio;
  final String? _apiKey;

  HiraApiProvider(this._dio, this._apiKey) {
    // API 키가 없으면 경고
    if (_apiKey == null || _apiKey == 'YOUR_HIRA_API_KEY_HERE') {
      print('⚠️ HIRA API 키가 설정되지 않았습니다. .env 파일을 확인하세요.');
    }
  }

  /// 병원 기본 정보 목록 조회
  ///
  /// [pageNo] 페이지 번호 (기본값: 1)
  /// [numOfRows] 한 페이지 결과 수 (기본값: 20)
  /// [sidoCd] 시도코드 (선택)
  /// [sgguCd] 시군구코드 (선택)
  /// [yadmNm] 병원명 (선택, UTF-8 인코딩 필요)
  /// [xPos] x좌표 (선택, 소수점 15자리)
  /// [yPos] y좌표 (선택, 소수점 15자리)
  /// [radius] 반경 (선택, 단위: 미터)
  Future<List<Hospital>> getHospitalList({
    int pageNo = 1,
    int numOfRows = 20,
    String? sidoCd,
    String? sgguCd,
    String? yadmNm,
    double? xPos,
    double? yPos,
    int? radius,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'ServiceKey': _apiKey,
        'pageNo': pageNo.toString(),
        'numOfRows': numOfRows.toString(),
        '_type': 'json', // JSON 응답 요청
      };

      // 선택적 파라미터 추가
      if (sidoCd != null) queryParams['sidoCd'] = sidoCd;
      if (sgguCd != null) queryParams['sgguCd'] = sgguCd;
      if (yadmNm != null) queryParams['yadmNm'] = Uri.encodeComponent(yadmNm);
      if (xPos != null) queryParams['xPos'] = xPos.toStringAsFixed(15);
      if (yPos != null) queryParams['yPos'] = yPos.toStringAsFixed(15);
      if (radius != null) queryParams['radius'] = radius.toString();

      final response = await _dio.get(
        '${ApiConstants.hiraBaseUrl}${ApiConstants.hiraHospitalInfoEndpoint}',
        queryParameters: queryParams,
        options: Options(
          sendTimeout: Duration(milliseconds: ApiConstants.apiTimeout),
          receiveTimeout: Duration(milliseconds: ApiConstants.apiTimeout),
          responseType: ResponseType.json,
        ),
      );

      if (response.statusCode == 200) {
        print('✅ HIRA API 응답 성공');
        print('응답 데이터 타입: ${response.data.runtimeType}');
        print('응답 데이터: ${response.data}');
        return _parseHospitalListResponse(response.data);
      } else {
        throw Exception('병원 정보 조회 실패: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('HIRA API 네트워크 오류: ${e.message}');
      throw Exception('네트워크 오류: ${e.message}');
    } catch (e) {
      print('병원 정보 처리 오류: $e');
      throw Exception('병원 정보 처리 오류: $e');
    }
  }

  /// 병원 목록 응답 파싱
  List<Hospital> _parseHospitalListResponse(dynamic data) {
    try {
      print('📋 파싱 시작...');
      print('데이터 키들: ${data.keys}');

      // API 응답 구조 확인
      final response = data['response'];
      if (response == null) {
        print('❌ response 키가 없습니다. 전체 데이터: $data');
        return [];
      }

      print('response 키들: ${response.keys}');

      final header = response['header'];
      final body = response['body'];

      if (header != null) {
        print('📌 Header - resultCode: ${header['resultCode']}, resultMsg: ${header['resultMsg']}');
      }

      if (body == null) {
        print('❌ body가 없습니다.');
        return [];
      }

      print('body 키들: ${body.keys}');
      print('totalCount: ${body['totalCount']}, pageNo: ${body['pageNo']}, numOfRows: ${body['numOfRows']}');

      final items = body['items'];

      if (items == null) {
        print('❌ items가 없습니다.');
        return [];
      }

      print('items 타입: ${items.runtimeType}');
      print('items 내용: $items');

      // items가 빈 문자열인 경우 처리
      if (items is String && items.isEmpty) {
        print('⚠️ items가 빈 문자열입니다. 검색 결과 없음.');
        return [];
      }

      final item = items['item'];

      if (item == null) {
        print('❌ item이 없습니다.');
        return [];
      }

      print('item 타입: ${item.runtimeType}');

      final List itemList = item is List ? item : [item];
      print('✅ ${itemList.length}개 병원 데이터 파싱 시작');

      final hospitals = <Hospital>[];

      for (var i = 0; i < itemList.length; i++) {
        try {
          final hospitalData = itemList[i];
          print('[$i] 병원 데이터: ${hospitalData.keys}');

          // 좌표 파싱
          double latitude = 0.0;
          double longitude = 0.0;

          try {
            final yPos = hospitalData['YPos']?.toString() ?? '0.0';
            final xPos = hospitalData['XPos']?.toString() ?? '0.0';
            latitude = double.parse(yPos);
            longitude = double.parse(xPos);
            print('[$i] 좌표: ($latitude, $longitude)');
          } catch (e) {
            print('[$i] 좌표 파싱 오류: $e');
          }

          final hospital = Hospital(
            id: hospitalData['ykiho']?.toString() ?? 'unknown_$i',
            name: hospitalData['yadmNm']?.toString() ?? '병원명 없음',
            address: hospitalData['addr']?.toString() ?? '주소 정보 없음',
            latitude: latitude,
            longitude: longitude,
            evaluations: [],
            nonCoveredPrices: [],
            reviewStatistics: null,
          );

          print('[$i] ✅ 병원 생성: ${hospital.name}');
          hospitals.add(hospital);
        } catch (e, stackTrace) {
          print('[$i] ❌ 병원 데이터 파싱 오류: $e');
          print('스택 트레이스: $stackTrace');
        }
      }

      print('✅ 파싱 완료: ${hospitals.length}개 병원');
      return hospitals;
    } catch (e, stackTrace) {
      print('❌ 병원 목록 파싱 전체 오류: $e');
      print('스택 트레이스: $stackTrace');
      return [];
    }
  }

  /// 주변 병원 검색 (좌표 기반)
  ///
  /// [latitude] 위도
  /// [longitude] 경도
  /// [radiusInMeters] 반경 (미터, 기본값: 5000m = 5km)
  /// [numOfRows] 결과 수 (기본값: 20)
  Future<List<Hospital>> searchNearbyHospitals({
    required double latitude,
    required double longitude,
    int radiusInMeters = 5000,
    int numOfRows = 20,
  }) async {
    return getHospitalList(
      xPos: longitude,
      yPos: latitude,
      radius: radiusInMeters,
      numOfRows: numOfRows,
    );
  }

  /// 병원명으로 검색
  ///
  /// [hospitalName] 병원명
  /// [numOfRows] 결과 수 (기본값: 20)
  Future<List<Hospital>> searchByName({
    required String hospitalName,
    int numOfRows = 20,
  }) async {
    return getHospitalList(
      yadmNm: hospitalName,
      numOfRows: numOfRows,
    );
  }

  /// 시도/시군구 코드로 검색
  ///
  /// [sidoCd] 시도코드
  /// [sgguCd] 시군구코드 (선택)
  /// [numOfRows] 결과 수 (기본값: 20)
  Future<List<Hospital>> searchByRegion({
    required String sidoCd,
    String? sgguCd,
    int numOfRows = 20,
  }) async {
    return getHospitalList(
      sidoCd: sidoCd,
      sgguCd: sgguCd,
      numOfRows: numOfRows,
    );
  }
}

/// Dio 인스턴스 Provider
@riverpod
Dio dio(DioRef ref) {
  return Dio(
    BaseOptions(
      connectTimeout: Duration(milliseconds: ApiConstants.apiTimeout),
      receiveTimeout: Duration(milliseconds: ApiConstants.apiTimeout),
    ),
  );
}

/// HIRA API Provider
@riverpod
HiraApiProvider hiraApiProvider(HiraApiProviderRef ref) {
  final dio = ref.watch(dioProvider);
  final apiKey = dotenv.env['HIRA_API_KEY'];
  return HiraApiProvider(dio, apiKey);
}
