import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../domain/entities/auth_exception.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../domain/use_cases/sign_in_with_google_use_case.dart';

class LoginViewModel extends BaseViewModel {
  LoginViewModel({
    SignInWithGoogleUseCase? signInWithGoogle,
    NavigationService? navigationService,
  }) : _signInWithGoogle =
           signInWithGoogle ??
           SignInWithGoogleUseCase(locator<AuthRepository>()),
       _navigationService = navigationService ?? locator<NavigationService>();

  final SignInWithGoogleUseCase _signInWithGoogle;
  final NavigationService _navigationService;

  Future<void> signIn() async {
    setBusy(true);
    setError(null);
    try {
      await _signInWithGoogle();
      await _navigationService.replaceWith(Routes.homeView);
    } on AuthException catch (error) {
      if (error.code == 'canceled' ||
          error.code == 'popup-closed-by-user' ||
          error.code == 'web-context-canceled') {
        return;
      }
      setError(_messageFor(error));
    } catch (error) {
      setError(error.toString());
    } finally {
      setBusy(false);
    }
  }

  String _messageFor(AuthException error) {
    final message = error.message.toUpperCase();
    if (error.code == 'configuration-not-found' ||
        error.code == 'missing-client-identifier' ||
        error.code == 'clientConfigurationError' ||
        error.code == 'providerConfigurationError' ||
        message.contains('CONFIGURATION_NOT_FOUND')) {
      return 'Google sign-in is not configured for this Firebase project. '
          'Enable Google in Firebase Console under Authentication > '
          'Sign-in method, set a support email, and download updated app '
          'configuration files.';
    }
    if (error.code == 'operation-not-allowed') {
      return 'Google sign-in is not enabled for this Firebase project yet.';
    }
    if (error.code == 'unauthorized-domain') {
      return 'Add this website domain to Firebase Authentication authorized domains.';
    }
    return error.message;
  }
}
