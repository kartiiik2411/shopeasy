import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../domain/entities/auth_exception.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _firebaseAuth;
  Future<void>? _googleSignInInitialization;

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
    final UserCredential credential;
    if (kIsWeb) {
      try {
        credential = await _firebaseAuth.signInWithPopup(GoogleAuthProvider());
      } on FirebaseAuthException catch (error) {
        throw _toAuthException(error);
      }
    } else {
      final GoogleSignInAccount account;
      try {
        await _initializeGoogleSignIn();
        account = await GoogleSignIn.instance.authenticate();
      } on GoogleSignInException catch (error) {
        throw AuthException(
          code: error.code.name,
          message:
              error.description ?? 'Could not open Google account selection.',
        );
      }

      final idToken = account.authentication.idToken;
      if (idToken == null) {
        throw const AuthException(
          code: 'missing-client-identifier',
          message:
              'Google did not return an ID token. Check the Google OAuth client configuration.',
        );
      }

      try {
        credential = await _firebaseAuth.signInWithCredential(
          GoogleAuthProvider.credential(idToken: idToken),
        );
      } on FirebaseAuthException catch (error) {
        throw _toAuthException(error);
      }
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
    if (!kIsWeb) {
      try {
        await GoogleSignIn.instance.signOut();
      } on GoogleSignInException catch (error) {
        throw AuthException(
          code: error.code.name,
          message: error.description ?? 'Could not sign out of Google.',
        );
      }
    }
  }

  Future<void> _initializeGoogleSignIn() async {
    final initialization =
        _googleSignInInitialization ??= GoogleSignIn.instance.initialize();
    try {
      await initialization;
    } catch (_) {
      _googleSignInInitialization = null;
      rethrow;
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
