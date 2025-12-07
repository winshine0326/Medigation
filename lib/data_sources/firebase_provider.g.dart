// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$firestoreHash() => r'ef4a6b0737caace50a6d79dd3e4e2aa1bc3031d5';

/// Firestore 인스턴스를 제공하는 Provider
///
/// Copied from [firestore].
@ProviderFor(firestore)
final firestoreProvider = AutoDisposeProvider<FirebaseFirestore>.internal(
  firestore,
  name: r'firestoreProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$firestoreHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FirestoreRef = AutoDisposeProviderRef<FirebaseFirestore>;
String _$hospitalsCollectionHash() =>
    r'08a36286be4729766a19d5e40986abeaa62f884c';

/// 병원 컬렉션 참조를 제공하는 Provider
///
/// Copied from [hospitalsCollection].
@ProviderFor(hospitalsCollection)
final hospitalsCollectionProvider =
    AutoDisposeProvider<CollectionReference<Map<String, dynamic>>>.internal(
      hospitalsCollection,
      name: r'hospitalsCollectionProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$hospitalsCollectionHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HospitalsCollectionRef =
    AutoDisposeProviderRef<CollectionReference<Map<String, dynamic>>>;
String _$bookmarksCollectionHash() =>
    r'2e3e8385a4ee126125ed6380ab19c1c4425e0714';

/// 북마크 컬렉션 참조를 제공하는 Provider
///
/// Copied from [bookmarksCollection].
@ProviderFor(bookmarksCollection)
final bookmarksCollectionProvider =
    AutoDisposeProvider<CollectionReference<Map<String, dynamic>>>.internal(
      bookmarksCollection,
      name: r'bookmarksCollectionProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$bookmarksCollectionHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BookmarksCollectionRef =
    AutoDisposeProviderRef<CollectionReference<Map<String, dynamic>>>;
String _$searchHistoryCollectionHash() =>
    r'8cfa0acce51d36f7d521086cfbf7373053482066';

/// 검색 히스토리 컬렉션 참조를 제공하는 Provider
///
/// Copied from [searchHistoryCollection].
@ProviderFor(searchHistoryCollection)
final searchHistoryCollectionProvider =
    AutoDisposeProvider<CollectionReference<Map<String, dynamic>>>.internal(
      searchHistoryCollection,
      name: r'searchHistoryCollectionProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$searchHistoryCollectionHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SearchHistoryCollectionRef =
    AutoDisposeProviderRef<CollectionReference<Map<String, dynamic>>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
