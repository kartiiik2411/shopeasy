import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';

class LoginViewModel extends BaseViewModel {
  LoginViewModel({FirebaseAuth? auth, NavigationService? navigationService})
    : _auth = auth ?? FirebaseAuth.instance,
      _navigationService = navigationService ?? locator<NavigationService>();

  final FirebaseAuth _auth;
  final NavigationService _navigationService;

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
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      return 'Enter a valid email address.';
    }
    return null;
  }

  String? validatePassword(String? value) {
    final password = value ?? '';
    if (password.isEmpty) return 'Password is required.';
    if (isRegisterMode && password.length < 6) {
      return 'Password must contain at least 6 characters.';
    }
    return null;
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
      await _auth.signInWithProvider(GoogleAuthProvider());
      await _navigationService.replaceWith(Routes.homeView);
    } on FirebaseAuthException catch (e) {
      errorMessage = _friendlyError(e.code);
    } catch (_) {
      errorMessage = 'Google sign-in failed. Please try again.';
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  Future<void> forgotPassword() async {
    final email = emailController.text.trim();

    if (email.isEmpty ||
        !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
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
      case 'network-request-failed':
        return 'Network error. Check your connection.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'account-exists-with-different-credential':
        return 'This email uses a different sign-in method.';
      case 'popup-closed-by-user':
        return 'Sign-in was cancelled.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
