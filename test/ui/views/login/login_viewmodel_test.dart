import 'package:flutter_test/flutter_test.dart';
import 'package:shopeasy_app/domain/entities/auth_exception.dart';
import 'package:shopeasy_app/domain/entities/auth_user.dart';
import 'package:shopeasy_app/domain/repositories/auth_repository.dart';
import 'package:shopeasy_app/domain/use_cases/sign_in_with_google_use_case.dart';
import 'package:shopeasy_app/ui/views/login/login_viewmodel.dart';
import 'package:stacked_services/stacked_services.dart';

void main() {
  group('LoginViewModel.signIn', () {
    test('explains Firebase CONFIGURATION_NOT_FOUND errors', () async {
      final viewModel = LoginViewModel(
        signInWithGoogle: _FailingSignIn(
          const AuthException(
            code: 'internal-error',
            message: 'An internal error occurred. [ CONFIGURATION_NOT_FOUND ]',
          ),
        ),
        navigationService: NavigationService(),
      );

      await viewModel.signIn();

      expect(
        viewModel.modelError,
        contains('Enable Google in Firebase Console'),
      );
      expect(viewModel.isBusy, isFalse);
    });
  });
}

class _FailingSignIn extends SignInWithGoogleUseCase {
  _FailingSignIn(this._error) : super(_FakeAuthRepository());

  final AuthException _error;

  @override
  Future<AuthUser> call() => Future<AuthUser>.error(_error);
}

class _FakeAuthRepository implements AuthRepository {
  @override
  Future<AuthUser?> getCurrentUser() async => null;

  @override
  Future<AuthUser> signInWithGoogle() async =>
      throw StateError('Not used by this test.');

  @override
  Future<void> signOut() async {}
}
