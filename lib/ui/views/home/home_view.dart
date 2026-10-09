import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../core/theme/app_color.dart';
import '../../../core/theme/app_size.dart';
import 'home_viewmodel.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({super.key});

  @override
  void onViewModelReady(HomeViewModel viewModel) {
    viewModel.loadUser();
  }

  @override
  Widget builder(BuildContext context, HomeViewModel viewModel, Widget? child) {
    final displayName = viewModel.user?.displayName;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('ShopEasy'),
        backgroundColor: AppColors.background,
        actions: [
          IconButton(
            tooltip: 'Sign out',
            onPressed: viewModel.isBusy ? null : viewModel.signOut,
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
      ),
      body: Center(
        child: viewModel.isBusy
            ? const CircularProgressIndicator()
            : viewModel.hasError
            ? Padding(
                padding: const EdgeInsets.all(AppSize.paddingXXL),
                child: Text(
                  viewModel.modelError.toString(),
                  textAlign: TextAlign.center,
                ),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (viewModel.user?.photoUrl case final photoUrl?)
                    CircleAvatar(
                      radius: AppSize.avatarL,
                      backgroundImage: NetworkImage(photoUrl),
                    )
                  else
                    const CircleAvatar(
                      radius: AppSize.avatarL,
                      backgroundColor: AppColors.illustrationBackground,
                      child: Icon(
                        Icons.person_rounded,
                        size: AppSize.iconXXL,
                        color: AppColors.primaryPurple,
                      ),
                    ),
                  const SizedBox(height: AppSize.spaceL),
                  Text(
                    displayName == null || displayName.isEmpty
                        ? 'Welcome!'
                        : 'Welcome, $displayName!',
                    style: const TextStyle(
                      color: AppColors.black,
                      fontSize: AppSize.fontXXL,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSize.spaceS),
                  const Text(
                    'You’re signed in and ready to shop.',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
      ),
    );
  }

  @override
  HomeViewModel viewModelBuilder(BuildContext context) => HomeViewModel();
}
