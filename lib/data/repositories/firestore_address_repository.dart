import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/delivery_address.dart';

class FirestoreAddressRepository {
  FirestoreAddressRepository({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  Future<DocumentReference<Map<String, dynamic>>>
  _getAddressDocument() async {
    final user = _auth.currentUser ?? await _auth.authStateChanges().first;
    if (user == null) {
      throw StateError('Sign in before saving a delivery address.');
    }

    return _firestore.collection('addresses').doc(user.uid);
  }

  Future<DeliveryAddress?> getDefaultAddress() async {
    final document = await _getAddressDocument();
    final snapshot = await document.get();
    final data = snapshot.data();
    return data == null ? null : DeliveryAddress.fromFirestore(data);
  }

  Future<void> saveDefaultAddress(DeliveryAddress address) async {
    final document = await _getAddressDocument();
    await document.set({
      ...address.toFirestore(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteDefaultAddress() async {
    final document = await _getAddressDocument();
    await document.delete();
  }
}
