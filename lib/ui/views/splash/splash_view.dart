import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../core/theme/app_color.dart';
import '../../../core/theme/app_size.dart';
import 'splash_viewmodel.dart';

class SplashView extends StackedView<SplashViewModel> {
  const SplashView({super.key});

  @override
  void onViewModelReady(SplashViewModel viewModel) {
    viewModel.initialise();
  }

  @override
  Widget builder(
    BuildContext context,
    SplashViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: viewModel.hasError
            ? _StartupError(
                message: viewModel.modelError.toString(),
                onRetry: viewModel.retry,
              )
            : const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _ShopEasyMark(size: AppSize.imageS + AppSize.iconXXL),
                  SizedBox(height: AppSize.spaceL + AppSize.paddingS / 2),
                  Text(
                    'ShopEasy',
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: AppSize.fontTitle,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1,
                    ),
                  ),
                  SizedBox(height: AppSize.spaceS),
                  Text(
                    'A little joy in every delivery.',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: AppSize.fontM,
                    ),
                  ),
                  SizedBox(height: AppSize.spaceXXL),
                  SizedBox(
                    width: AppSize.iconM,
                    height: AppSize.iconM,
                    child: CircularProgressIndicator(
                      strokeWidth: AppSize.paddingXS / 2,
                      color: AppColors.primaryPurple,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  @override
  SplashViewModel viewModelBuilder(BuildContext context) => SplashViewModel();
}

class _StartupError extends StatelessWidget {
  const _StartupError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSize.paddingXXXL),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _ShopEasyMark(size: AppSize.imageS + AppSize.paddingM),
          const SizedBox(height: AppSize.spaceXL),
          const Text(
            'Could not start ShopEasy',
            style: TextStyle(
              color: AppColors.black,
              fontSize: AppSize.fontXXL,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSize.spaceS),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: AppSize.spaceL + AppSize.paddingS / 2),
          FilledButton(onPressed: onRetry, child: const Text('Try again')),
        ],
      ),
    );
  }
}

class _ShopEasyMark extends StatelessWidget {
  const _ShopEasyMark({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.primaryPurple,
        borderRadius: BorderRadius.circular(size * 0.32),
        boxShadow: const [
          BoxShadow(
            color: AppColors.primaryPurpleShadow,
            blurRadius: AppSize.spaceL + AppSize.paddingM / 2,
            offset: Offset(0, AppSize.paddingM - AppSize.paddingXS / 2),
          ),
        ],
      ),
      child: Icon(
        Icons.shopping_bag_rounded,
        color: AppColors.white,
        size: size * 0.52,
      ),
    );
  }
}
