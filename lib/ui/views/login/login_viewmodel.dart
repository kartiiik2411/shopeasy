import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';

class LoginViewModel extends BaseViewModel {
  LoginViewModel({
    FirebaseAuth? auth,
    NavigationService? navigationService,
    Future<AuthCredential> Function()? googleCredentialProvider,
  }) : _auth = auth ?? FirebaseAuth.instance,
       _navigationService = navigationService ?? locator<NavigationService>(),
       _googleCredentialProvider =
           googleCredentialProvider ?? _createGoogleCredential;

  final FirebaseAuth _auth;
  final NavigationService _navigationService;
  final Future<AuthCredential> Function() _googleCredentialProvider;

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isRegisterMode = false;
  bool obscurePassword = true;
  String? errorMessage;
  bool isSubmitting = false;

  void toggleMode() {
    isRegisterMode = !isRegisterMode;
    errorMessage = null;
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    notifyListeners();
  }

  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  String? validateName(String? value) {
    if (!isRegisterMode) return null;
    if (value == null || value.trim().length < 2) {
      return 'Enter your full name.';
    }
    return null;
  }

  String? validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Email is required.';
    return _isValidEmail(email) ? null : 'Enter a valid email address.';
  }

  String? validatePassword(String? value) {
    final password = value ?? '';
    if (password.isEmpty) return 'Password is required.';
    if (password.length < 6) {
      return 'Password must contain at least 6 characters.';
    }
    return null;
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
  }

  Future<void> submit() async {
    if (isSubmitting || !(formKey.currentState?.validate() ?? false)) {
      return;
    }

    errorMessage = null;
    isSubmitting = true;
    notifyListeners();

    try {
      if (isRegisterMode) {
        await _register();
      } else {
        await _login();
      }

      await _navigationService.replaceWith(Routes.homeView);
    } on FirebaseAuthException catch (e) {
      errorMessage = _friendlyError(e.code);
    } catch (_) {
      errorMessage = 'Something went wrong. Please try again.';
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  Future<void> _login() async {
    await _auth.signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text,
    );
  }

  Future<void> _register() async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text,
    );

    await credential.user?.updateDisplayName(nameController.text.trim());
    await credential.user?.reload();
  }

  Future<void> signInWithGoogle() async {
    if (isSubmitting) return;

    errorMessage = null;
    isSubmitting = true;
    notifyListeners();

    try {
      if (kIsWeb || defaultTargetPlatform == TargetPlatform.iOS) {
        await _auth.signInWithProvider(GoogleAuthProvider());
      } else {
        final credential = await _googleCredentialProvider();
        await _auth.signInWithCredential(credential);
      }
      await _navigationService.replaceWith(Routes.homeView);
    } on GoogleSignInException catch (e) {
      errorMessage = _friendlyGoogleError(e.code);
    } on FirebaseAuthException catch (e) {
      errorMessage = _friendlyError(e.code);
    } catch (_) {
      errorMessage = 'Google sign-in failed. Please try again.';
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  static Future<AuthCredential> _createGoogleCredential() async {
    final googleSignIn = GoogleSignIn.instance;
    await googleSignIn.initialize();

    final account = await googleSignIn.authenticate();
    final idToken = account.authentication.idToken;
    if (idToken == null) {
      throw StateError('Google sign-in did not return an ID token.');
    }

    return GoogleAuthProvider.credential(idToken: idToken);
  }

  Future<void> forgotPassword() async {
    final email = emailController.text.trim();

    if (email.isEmpty || !_isValidEmail(email)) {
      errorMessage = 'Enter your email address first.';
      notifyListeners();
      return;
    }

    errorMessage = null;
    isSubmitting = true;
    notifyListeners();

    try {
      await _auth.sendPasswordResetEmail(email: email);
      errorMessage = 'Password reset email sent. Check your inbox.';
    } on FirebaseAuthException catch (e) {
      errorMessage = _friendlyError(e.code);
    } catch (_) {
      errorMessage = 'Could not send reset email. Please try again.';
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  String _friendlyError(String code) {
    switch (code) {
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'email-already-in-use':
        return 'An account already exists for this email.';
      case 'weak-password':
        return 'Choose a stronger password.';
      case 'invalid-credential':
        return 'Incorrect email or password.';
      case 'user-not-found':
        return 'No account found for this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'operation-not-allowed':
        return 'Enable this sign-in method in Firebase Console.';
      case 'unsupported-platform':
        return 'Google sign-in is unavailable on this platform.';
      case 'network-request-failed':
        return 'Network error. Check your connection.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'account-exists-with-different-credential':
        return 'This email uses a different sign-in method.';
      case 'popup-closed-by-user':
      case 'web-context-cancelled':
        return 'Sign-in was cancelled.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }

  String _friendlyGoogleError(GoogleSignInExceptionCode code) {
    if (code == GoogleSignInExceptionCode.canceled) {
      return 'Sign-in was cancelled.';
    }
    if (code == GoogleSignInExceptionCode.interrupted) {
      return 'Sign-in was interrupted. Please try again.';
    }
    if (code == GoogleSignInExceptionCode.uiUnavailable) {
      return 'Google sign-in is unavailable on this device.';
    }
    if (code == GoogleSignInExceptionCode.clientConfigurationError ||
        code == GoogleSignInExceptionCode.providerConfigurationError) {
      return 'Google sign-in is missing platform OAuth configuration.';
    }
    if (code == GoogleSignInExceptionCode.userMismatch) {
      return 'The selected Google account is no longer signed in.';
    }
    return 'Google sign-in failed. Please try again.';
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
