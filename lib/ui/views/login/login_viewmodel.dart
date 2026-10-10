import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../core/network/api_exception.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../domain/use_cases/login_use_case.dart';

class LoginViewModel extends BaseViewModel {
  LoginViewModel({
    LoginUseCase? loginUseCase,
    NavigationService? navigationService,
  }) : _loginUseCase =
           loginUseCase ?? LoginUseCase(locator<AuthRepository>()),
       _navigationService = navigationService ?? locator<NavigationService>();

  final LoginUseCase _loginUseCase;
  final NavigationService _navigationService;
  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  Future<String?> login() async {
    setBusy(true);
    try {
      await _loginUseCase(
        username: usernameController.text.trim(),
        password: passwordController.text,
      );
      await _navigationService.replaceWith(Routes.homeView);
      return null;
    } on ApiException catch (error) {
      return error.message;
    } catch (error) {
      return 'Could not log in. Please check your connection and try again.';
    } finally {
      setBusy(false);
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
