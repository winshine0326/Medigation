// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hospital_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$hospitalListNotifierHash() =>
    r'26cf95189955a132ce1ebec49827ba23929e6a5c';

/// 병원 목록 Notifier
/// 병원 목록 상태를 관리하고 페이지네이션을 처리합니다
///
/// Copied from [HospitalListNotifier].
@ProviderFor(HospitalListNotifier)
final hospitalListNotifierProvider = AutoDisposeNotifierProvider<
  HospitalListNotifier,
  HospitalListState
>.internal(
  HospitalListNotifier.new,
  name: r'hospitalListNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$hospitalListNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$HospitalListNotifier = AutoDisposeNotifier<HospitalListState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
