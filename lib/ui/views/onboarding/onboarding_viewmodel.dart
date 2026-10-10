import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';

class OnboardingViewModel extends BaseViewModel {
  OnboardingViewModel({NavigationService? navigationService})
    : _navigationService = navigationService ?? locator<NavigationService>();

  final NavigationService _navigationService;

  final PageController pageController = PageController();

  int currentPage = 0;

  static const int totalPages = 3;

  void onPageChanged(int index) {
    currentPage = index;
    notifyListeners();
  }

  Future<void> nextPage() async {
    if (currentPage < totalPages - 1) {
      await pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
      );
    } else {
      openLogin();
    }
  }

  void skipOnboarding() {
    openLogin();
  }

  void openLogin() {
    _navigationService.replaceWith(Routes.loginView);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
