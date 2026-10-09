import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../domain/entities/auth_exception.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _firebaseAuth;

  @override
  Future<AuthUser?> getCurrentUser() async {
    try {
      final user = _firebaseAuth.currentUser;
      return user == null ? null : _toAuthUser(user);
    } on FirebaseAuthException catch (error) {
      throw _toAuthException(error);
    }
  }

  @override
  Future<AuthUser> signInWithGoogle() async {
    final provider = GoogleAuthProvider();
    final UserCredential credential;
    try {
      credential = kIsWeb
          ? await _firebaseAuth.signInWithPopup(provider)
          : await _firebaseAuth.signInWithProvider(provider);
    } on FirebaseAuthException catch (error) {
      throw _toAuthException(error);
    }
    final user = credential.user;
    if (user == null) {
      throw const AuthException(
        code: 'missing-user',
        message: 'Google sign-in completed without returning a user.',
      );
    }
    return _toAuthUser(user);
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (error) {
      throw _toAuthException(error);
    }
  }

  AuthUser _toAuthUser(User user) => AuthUser(
    id: user.uid,
    email: user.email ?? '',
    displayName: user.displayName,
    photoUrl: user.photoURL,
  );

  AuthException _toAuthException(FirebaseAuthException error) => AuthException(
    code: error.code,
    message: error.message ?? 'Firebase authentication failed.',
  );
}
