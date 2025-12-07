// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$locationNotifierHash() => r'c8af211633ab4420afaece13839499268ee94749';

/// 위치 Notifier
/// 현재 위치 및 위치 권한을 관리합니다
///
/// Copied from [LocationNotifier].
@ProviderFor(LocationNotifier)
final locationNotifierProvider =
    AutoDisposeNotifierProvider<LocationNotifier, LocationState>.internal(
      LocationNotifier.new,
      name: r'locationNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$locationNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$LocationNotifier = AutoDisposeNotifier<LocationState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
