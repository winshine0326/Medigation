import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../constants/api_constants.dart';
import '../models/hospital_evaluation.dart';
import '../models/non_covered_price.dart';

part 'hira_api_provider.g.dart';

/// 건강보험심사평가원 (HIRA) API Provider
/// 병원 평가 데이터 및 비급여 가격 데이터를 제공
class HiraApiProvider {
  final Dio _dio;
  final String? _apiKey;

  HiraApiProvider(this._dio, this._apiKey) {
    // API 키가 없으면 경고
    if (_apiKey == null || _apiKey == 'YOUR_HIRA_API_KEY_HERE') {
      print('⚠️ HIRA API 키가 설정되지 않았습니다. .env 파일을 확인하세요.');
    }
  }

  /// 병원 평가 정보 조회
  ///
  /// [hospitalId] 요양기관번호
  /// Returns: 병원 평가 목록
  Future<List<HospitalEvaluation>> getHospitalEvaluations(
    String hospitalId,
  ) async {
    try {
      final response = await _dio.get(
        '${ApiConstants.hiraBaseUrl}${ApiConstants.hiraHospitalEvaluationEndpoint}',
        queryParameters: {
          'serviceKey': _apiKey,
          'ykiho': hospitalId, // 요양기관번호
          'numOfRows': ApiConstants.itemsPerPage,
          'pageNo': 1,
          '_type': ApiConstants.responseFormat,
        },
        options: Options(
          sendTimeout: Duration(milliseconds: ApiConstants.apiTimeout),
          receiveTimeout: Duration(milliseconds: ApiConstants.apiTimeout),
        ),
      );

      if (response.statusCode == 200) {
        return _parseEvaluationResponse(response.data);
      } else {
        throw Exception('병원 평가 정보 조회 실패: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('네트워크 오류: ${e.message}');
    } catch (e) {
      throw Exception('병원 평가 정보 처리 오류: $e');
    }
  }

  /// 병원 평가 응답 파싱
  List<HospitalEvaluation> _parseEvaluationResponse(dynamic data) {
    try {
      // HIRA API 응답 구조에 맞게 파싱
      // 실제 API 응답 구조에 따라 수정 필요
      final items = data['response']?['body']?['items']?['item'];

      if (items == null) {
        return [];
      }

      final List itemList = items is List ? items : [items];

      return itemList.map((item) {
        return HospitalEvaluation(
          evaluationItem: item['evlItem'] ?? '평가 항목',
          grade: item['evlGrade'] ?? '등급 정보 없음',
          badges: _generateBadgesFromEvaluation(
            item['evlItem'] ?? '',
            item['evlGrade'] ?? '',
          ),
        );
      }).toList();
    } catch (e) {
      print('평가 데이터 파싱 오류: $e');
      return [];
    }
  }

  /// 평가 데이터로부터 배지 생성
  /// 나중에 badge_generator.dart로 분리 예정
  List<String> _generateBadgesFromEvaluation(
    String evaluationItem,
    String grade,
  ) {
    final badges = <String>[];

    // 1등급인 경우 배지 생성
    if (grade.contains('1등급')) {
      if (evaluationItem.contains('뇌졸중')) {
        badges.add('뇌졸중 수술 전문');
      } else if (evaluationItem.contains('심근경색')) {
        badges.add('심근경색 치료 전문');
      } else if (evaluationItem.contains('폐렴')) {
        badges.add('폐렴 치료 전문');
      } else if (evaluationItem.contains('응급')) {
        badges.add('응급 치료 전문');
      }
    }

    return badges;
  }

  /// 비급여 가격 정보 조회
  ///
  /// [hospitalId] 요양기관번호
  /// Returns: 비급여 가격 목록
  Future<List<NonCoveredPrice>> getNonCoveredPrices(
    String hospitalId,
  ) async {
    try {
      final response = await _dio.get(
        '${ApiConstants.hiraBaseUrl}${ApiConstants.hiraNonCoveredPriceEndpoint}',
        queryParameters: {
          'serviceKey': _apiKey,
          'ykiho': hospitalId, // 요양기관번호
          'numOfRows': ApiConstants.itemsPerPage,
          'pageNo': 1,
          '_type': ApiConstants.responseFormat,
        },
        options: Options(
          sendTimeout: Duration(milliseconds: ApiConstants.apiTimeout),
          receiveTimeout: Duration(milliseconds: ApiConstants.apiTimeout),
        ),
      );

      if (response.statusCode == 200) {
        return _parseNonCoveredPriceResponse(response.data);
      } else {
        throw Exception('비급여 가격 정보 조회 실패: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('네트워크 오류: ${e.message}');
    } catch (e) {
      throw Exception('비급여 가격 정보 처리 오류: $e');
    }
  }

  /// 비급여 가격 응답 파싱
  List<NonCoveredPrice> _parseNonCoveredPriceResponse(dynamic data) {
    try {
      // HIRA API 응답 구조에 맞게 파싱
      // 실제 API 응답 구조에 따라 수정 필요
      final items = data['response']?['body']?['items']?['item'];

      if (items == null) {
        return [];
      }

      final List itemList = items is List ? items : [items];

      return itemList.map((item) {
        // 가격 문자열을 정수로 변환
        int price = 0;
        try {
          final priceStr = item['price']?.toString() ?? '0';
          price = int.parse(priceStr.replaceAll(RegExp(r'[^0-9]'), ''));
        } catch (e) {
          print('가격 파싱 오류: $e');
        }

        return NonCoveredPrice(
          item: item['itemName'] ?? '비급여 항목',
          price: price,
        );
      }).toList();
    } catch (e) {
      print('비급여 가격 데이터 파싱 오류: $e');
      return [];
    }
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
