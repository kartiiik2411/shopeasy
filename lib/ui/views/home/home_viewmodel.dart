import 'package:stacked_services/stacked_services.dart';
import 'package:stacked/stacked.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../domain/entities/auth_user.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../domain/use_cases/get_current_user_use_case.dart';
import '../../../domain/use_cases/sign_out_use_case.dart';

class HomeViewModel extends BaseViewModel {
  HomeViewModel({
    GetCurrentUserUseCase? getCurrentUser,
    SignOutUseCase? signOut,
    NavigationService? navigationService,
  }) : _getCurrentUser =
           getCurrentUser ?? GetCurrentUserUseCase(locator<AuthRepository>()),
       _signOut = signOut ?? SignOutUseCase(locator<AuthRepository>()),
       _navigationService = navigationService ?? locator<NavigationService>();

  final GetCurrentUserUseCase _getCurrentUser;
  final SignOutUseCase _signOut;
  final NavigationService _navigationService;

  AuthUser? user;

  Future<void> loadUser() async {
    setBusy(true);
    try {
      user = await _getCurrentUser();
    } catch (error) {
      setError(error);
    } finally {
      setBusy(false);
    }
  }

  Future<void> signOut() async {
    setBusy(true);
    try {
      await _signOut();
      await _navigationService.replaceWith(Routes.loginView);
    } catch (error) {
      setError(error);
    } finally {
      setBusy(false);
    }
  }
}
