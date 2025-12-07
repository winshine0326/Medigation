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
    r'b2a00a443211b7b46a9f30499af7a70af10a4035';

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
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
