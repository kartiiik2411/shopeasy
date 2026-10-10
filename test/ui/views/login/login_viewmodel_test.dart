import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

    test('rejects an empty password', () {
      expect(viewModel.validatePassword(''), 'Password is required.');
    });

    test('requires six characters during registration', () {
      viewModel.isRegisterMode = true;

      expect(
        viewModel.validatePassword('123'),
        'Password must contain at least 6 characters.',
      );
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
}
