import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:shopeasy_app/ui/views/login/login_viewmodel.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

void main() {
  late MockFirebaseAuth mockAuth;
  late LoginViewModel viewModel;

  setUp(() {
    mockAuth = MockFirebaseAuth();

    viewModel = LoginViewModel(
      auth: mockAuth,
      navigationService: NavigationService(),
    );
  });

  tearDown(() {
    viewModel.dispose();
  });

  group('LoginViewModel validation', () {
    test('rejects an empty email', () {
      expect(viewModel.validateEmail(''), 'Email is required.');
    });

    test('rejects an invalid email', () {
      expect(
        viewModel.validateEmail('invalid-email'),
        'Enter a valid email address.',
      );
    });

    test('accepts a valid email', () {
      expect(viewModel.validateEmail('user@example.com'), isNull);
    });

    test('requires a full name while registering', () {
      viewModel.isRegisterMode = true;

      expect(viewModel.validateName(' A '), 'Enter your full name.');
      expect(viewModel.validateName(' Alex Johnson '), isNull);
    });

    test('rejects an empty password', () {
      expect(viewModel.validatePassword(''), 'Password is required.');
    });

    test('requires six characters for authentication', () {
      expect(
        viewModel.validatePassword('123'),
        'Password must contain at least 6 characters.',
      );
    });

    test('accepts a valid password', () {
      expect(viewModel.validatePassword('secure-password'), isNull);
    });

    test('toggles registration mode', () {
      expect(viewModel.isRegisterMode, isFalse);

      viewModel.toggleMode();

      expect(viewModel.isRegisterMode, isTrue);
    });

    test('toggles password visibility', () {
      expect(viewModel.obscurePassword, isTrue);

      viewModel.togglePasswordVisibility();

      expect(viewModel.obscurePassword, isFalse);
    });
  });

  test('shows a friendly message when Google sign-in is cancelled', () async {
    final googleViewModel = LoginViewModel(
      auth: mockAuth,
      navigationService: NavigationService(),
      googleCredentialProvider: () async {
        throw const GoogleSignInException(
          code: GoogleSignInExceptionCode.canceled,
        );
      },
    );

    await googleViewModel.signInWithGoogle();

    expect(googleViewModel.errorMessage, 'Sign-in was cancelled.');
    expect(googleViewModel.isSubmitting, isFalse);
    googleViewModel.dispose();
  });
}
