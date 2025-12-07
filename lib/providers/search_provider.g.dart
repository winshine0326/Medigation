// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$searchNotifierHash() => r'd0ba316e5177b1d91374873aeaac33380660cf11';

/// 검색 Notifier
/// 검색어 및 검색 히스토리를 관리합니다
///
/// Copied from [SearchNotifier].
@ProviderFor(SearchNotifier)
final searchNotifierProvider =
    AutoDisposeNotifierProvider<SearchNotifier, SearchState>.internal(
      SearchNotifier.new,
      name: r'searchNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$searchNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SearchNotifier = AutoDisposeNotifier<SearchState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
