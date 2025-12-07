import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase_provider.g.dart';

/// Firestore 인스턴스를 제공하는 Provider
@riverpod
FirebaseFirestore firestore(FirestoreRef ref) {
  return FirebaseFirestore.instance;
}

/// 병원 컬렉션 참조를 제공하는 Provider
@riverpod
CollectionReference<Map<String, dynamic>> hospitalsCollection(
  HospitalsCollectionRef ref,
) {
  final firestore = ref.watch(firestoreProvider);
  return firestore.collection('hospitals');
}
