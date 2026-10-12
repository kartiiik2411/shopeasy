import 'dart:async';

import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';

class SplashViewModel extends BaseViewModel {
  SplashViewModel({NavigationService? navigationService})
    : _navigationService = navigationService ?? locator<NavigationService>();

  final NavigationService _navigationService;

  Timer? _timer;
  bool _hasStarted = false;

  void startSplashTimer() {
    if (_hasStarted) return;

    _hasStarted = true;

    _timer = Timer(const Duration(milliseconds: 2600), () {
      _navigationService.replaceWith(Routes.onboardingView);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
