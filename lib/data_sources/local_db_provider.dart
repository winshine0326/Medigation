import 'dart:convert';
import 'package:path/path.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';
import '../constants/api_constants.dart';
import '../models/hospital.dart';

part 'local_db_provider.g.dart';

/// 로컬 데이터베이스 Provider
/// 병원 데이터를 SQLite에 캐시하여 오프라인 지원 및 성능 향상
class LocalDbProvider {
  Database? _database;

  /// 데이터베이스 초기화
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// 데이터베이스 초기화 및 테이블 생성
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, LocalDbConstants.dbName);

    return await openDatabase(
      path,
      version: LocalDbConstants.dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /// 테이블 생성
  Future<void> _onCreate(Database db, int version) async {
    // 병원 테이블
    await db.execute('''
      CREATE TABLE ${LocalDbConstants.hospitalsTable} (
        id TEXT PRIMARY KEY,
        data TEXT NOT NULL,
        cached_at INTEGER NOT NULL
      )
    ''');

    // 평가 데이터 테이블
    await db.execute('''
      CREATE TABLE ${LocalDbConstants.evaluationsTable} (
        hospital_id TEXT NOT NULL,
        data TEXT NOT NULL,
        cached_at INTEGER NOT NULL,
        PRIMARY KEY (hospital_id)
      )
    ''');

    // 비급여 가격 테이블
    await db.execute('''
      CREATE TABLE ${LocalDbConstants.pricesTable} (
        hospital_id TEXT NOT NULL,
        data TEXT NOT NULL,
        cached_at INTEGER NOT NULL,
        PRIMARY KEY (hospital_id)
      )
    ''');
  }

  /// 데이터베이스 업그레이드
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // 향후 스키마 변경 시 처리
  }

  /// 병원 데이터 캐시 저장
  Future<void> cacheHospital(Hospital hospital) async {
    final db = await database;
    final now = DateTime.now().millisecondsSinceEpoch;

    await db.insert(
      LocalDbConstants.hospitalsTable,
      {
        'id': hospital.id,
        'data': jsonEncode(hospital.toJson()),
        'cached_at': now,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// 병원 데이터 조회 (캐시)
  Future<Hospital?> getCachedHospital(String hospitalId) async {
    final db = await database;
    final results = await db.query(
      LocalDbConstants.hospitalsTable,
      where: 'id = ?',
      whereArgs: [hospitalId],
    );

    if (results.isEmpty) return null;

    final cachedAt = results.first['cached_at'] as int;
    if (_isCacheExpired(cachedAt)) {
      // 캐시 만료됨
      await deleteCachedHospital(hospitalId);
      return null;
    }

    final data = jsonDecode(results.first['data'] as String);
    return Hospital.fromJson(data as Map<String, dynamic>);
  }

  /// 모든 캐시된 병원 조회
  Future<List<Hospital>> getAllCachedHospitals() async {
    final db = await database;
    final results = await db.query(LocalDbConstants.hospitalsTable);

    final hospitals = <Hospital>[];
    for (final row in results) {
      final cachedAt = row['cached_at'] as int;
      if (!_isCacheExpired(cachedAt)) {
        final data = jsonDecode(row['data'] as String);
        hospitals.add(Hospital.fromJson(data as Map<String, dynamic>));
      }
    }

    return hospitals;
  }

  /// 캐시된 병원 삭제
  Future<void> deleteCachedHospital(String hospitalId) async {
    final db = await database;
    await db.delete(
      LocalDbConstants.hospitalsTable,
      where: 'id = ?',
      whereArgs: [hospitalId],
    );
  }

  /// 만료된 캐시 정리
  Future<void> clearExpiredCache() async {
    final db = await database;
    final expiryTime = DateTime.now()
        .subtract(Duration(hours: LocalDbConstants.cacheExpiryHours))
        .millisecondsSinceEpoch;

    await db.delete(
      LocalDbConstants.hospitalsTable,
      where: 'cached_at < ?',
      whereArgs: [expiryTime],
    );

    await db.delete(
      LocalDbConstants.evaluationsTable,
      where: 'cached_at < ?',
      whereArgs: [expiryTime],
    );

    await db.delete(
      LocalDbConstants.pricesTable,
      where: 'cached_at < ?',
      whereArgs: [expiryTime],
    );
  }

  /// 전체 캐시 삭제
  Future<void> clearAllCache() async {
    final db = await database;
    await db.delete(LocalDbConstants.hospitalsTable);
    await db.delete(LocalDbConstants.evaluationsTable);
    await db.delete(LocalDbConstants.pricesTable);
  }

  /// 캐시 만료 여부 확인
  bool _isCacheExpired(int cachedAtMillis) {
    final cachedAt = DateTime.fromMillisecondsSinceEpoch(cachedAtMillis);
    final now = DateTime.now();
    final difference = now.difference(cachedAt);

    return difference.inHours >= LocalDbConstants.cacheExpiryHours;
  }

  /// 데이터베이스 닫기
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}

/// LocalDbProvider Provider
@riverpod
LocalDbProvider localDbProvider(LocalDbProviderRef ref) {
  return LocalDbProvider();
}
