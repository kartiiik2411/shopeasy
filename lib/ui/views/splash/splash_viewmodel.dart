import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../domain/use_cases/get_current_user_use_case.dart';

class SplashViewModel extends BaseViewModel {
  SplashViewModel({
    GetCurrentUserUseCase? getCurrentUser,
    NavigationService? navigationService,
  }) : _getCurrentUser =
           getCurrentUser ?? GetCurrentUserUseCase(locator<AuthRepository>()),
       _navigationService = navigationService ?? locator<NavigationService>();

  final GetCurrentUserUseCase _getCurrentUser;
  final NavigationService _navigationService;

  Future<void> initialise() async {
    setBusy(true);
    try {
      final user = await _getCurrentUser();
      await Future<void>.delayed(const Duration(milliseconds: 900));
      if (user == null) {
        await _navigationService.replaceWith(Routes.loginView);
      } else {
        await _navigationService.replaceWith(Routes.homeView);
      }
    } catch (error) {
      setError(error);
    } finally {
      setBusy(false);
    }
  }

  Future<void> retry() => initialise();
}
