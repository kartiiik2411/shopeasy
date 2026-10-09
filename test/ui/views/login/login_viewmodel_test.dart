import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopeasy_app/app/app.router.dart';
import 'package:shopeasy_app/core/network/api_exception.dart';
import 'package:shopeasy_app/domain/entities/auth_user.dart';
import 'package:shopeasy_app/domain/repositories/auth_repository.dart';
import 'package:shopeasy_app/domain/use_cases/login_use_case.dart';
import 'package:shopeasy_app/ui/views/login/login_viewmodel.dart';
import 'package:stacked_services/stacked_services.dart';

void main() {
  group('LoginViewModel.login', () {
    test('uses credentials and navigates to the catalogue on success', () async {
      final repository = _FakeAuthRepository();
      final navigationService = _RecordingNavigationService();
      final viewModel = LoginViewModel(
        loginUseCase: LoginUseCase(repository),
        navigationService: navigationService,
      );
      viewModel.usernameController.text = 'emilys';
      viewModel.passwordController.text = 'emilyspass';

      final error = await viewModel.login();

      expect(error, isNull);
      expect(repository.username, 'emilys');
      expect(repository.password, 'emilyspass');
      expect(navigationService.replacedRoute, Routes.homeView);
      expect(viewModel.isBusy, isFalse);
      viewModel.dispose();
    });

    test('returns API login errors for the error dialog', () async {
      final viewModel = LoginViewModel(
        loginUseCase: LoginUseCase(
          _FakeAuthRepository(error: const ApiException('Invalid credentials')),
        ),
        navigationService: NavigationService(),
      );
      viewModel.usernameController.text = 'wrong';
      viewModel.passwordController.text = 'wrong';

      final error = await viewModel.login();

      expect(error, 'Invalid credentials');
      expect(viewModel.isBusy, isFalse);
      viewModel.dispose();
    });
  });
}

class _RecordingNavigationService extends NavigationService {
  String? replacedRoute;

  @override
  Future<T?>? replaceWith<T>(
    String routeName, {
    dynamic arguments,
    int? id,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    RouteTransitionsBuilder? transition,
  }) {
    replacedRoute = routeName;
    return Future<T?>.value();
  }
}

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({this.error});

  final Object? error;
  String? username;
  String? password;

  @override
  Future<AuthUser?> getCurrentUser() async => null;

  @override
  Future<AuthUser> login({
    required String username,
    required String password,
  }) async {
    if (error case final failure?) throw failure;
    this.username = username;
    this.password = password;
    return const AuthUser(id: '1', email: 'emily@example.com');
  }

  @override
  Future<void> signOut() async {}
}
