import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../core/theme/app_color.dart';
import '../../../core/theme/app_size.dart';
import 'login_viewmodel.dart';

class LoginView extends StackedView<LoginViewModel> {
  const LoginView({super.key});

  @override
  Widget builder(
    BuildContext context,
    LoginViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSize.paddingXXXL,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSize.spaceXXL),
                    const _BrandHeader(),
                    const SizedBox(height: AppSize.spaceXXXL),
                    const _ShoppingIllustration(),
                    const SizedBox(height: AppSize.spaceXXL),
                    const Text(
                      'Good finds.\nDelivered easy.',
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: AppSize.fontTitle + AppSize.paddingXS,
                        height: 1.08,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1.5,
                      ),
                    ),
                    const SizedBox(height: AppSize.spaceM),
                    const Text(
                      'Sign in to discover everyday essentials and little things you’ll love.',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: AppSize.fontL,
                        height: 1.55,
                      ),
                    ),
                    const SizedBox(height: AppSize.spaceXL),
                    if (viewModel.hasError) ...[
                      _SignInError(message: viewModel.modelError.toString()),
                      const SizedBox(height: AppSize.spaceM),
                    ],
                    SizedBox(
                      width: double.infinity,
                      height: AppSize.buttonHeightL,
                      child: OutlinedButton(
                        onPressed: viewModel.isBusy ? null : viewModel.signIn,
                        style: OutlinedButton.styleFrom(
                          backgroundColor: AppColors.white,
                          foregroundColor: AppColors.black,
                          side: const BorderSide(color: AppColors.border),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppSize.radiusL,
                            ),
                          ),
                        ),
                        child: viewModel.isBusy
                            ? const SizedBox(
                                width: AppSize.iconM,
                                height: AppSize.iconM,
                                child: CircularProgressIndicator(
                                  strokeWidth: AppSize.paddingXS / 2,
                                  color: AppColors.primaryPurple,
                                ),
                              )
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _GoogleMark(),
                                  SizedBox(width: AppSize.spaceM),
                                  Text(
                                    'Continue with Google',
                                    style: TextStyle(
                                      fontSize: AppSize.fontL,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(height: AppSize.spaceL),
                    const Center(
                      child: Text(
                        'Secure sign-in powered by Google.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textTertiary,
                          fontSize: AppSize.fontS,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSize.spaceXL),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  LoginViewModel viewModelBuilder(BuildContext context) => LoginViewModel();
}

class _BrandHeader extends StatelessWidget {
  const _BrandHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: AppSize.iconXL,
          height: AppSize.iconXL,
          decoration: const BoxDecoration(
            color: AppColors.illustrationBackground,
            borderRadius: BorderRadius.all(
              Radius.circular(AppSize.radiusM - AppSize.paddingXS / 4),
            ),
          ),
          child: const Icon(
            Icons.shopping_bag_rounded,
            color: AppColors.primaryPurple,
            size: AppSize.iconS,
          ),
        ),
        const SizedBox(width: AppSize.paddingM - AppSize.paddingXS / 2),
        const Text(
          'ShopEasy',
          style: TextStyle(
            color: AppColors.black,
            fontSize: AppSize.fontXXL,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }
}

class _ShoppingIllustration extends StatelessWidget {
  const _ShoppingIllustration();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: AppSize.imageXL,
        height: AppSize.imageXL,
        decoration: BoxDecoration(
          color: AppColors.illustrationBackground,
          borderRadius: BorderRadius.circular(AppSize.radiusXXL),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: AppSize.imageL,
              height: AppSize.imageL,
              decoration: const BoxDecoration(
                color: AppColors.illustrationCircle,
                shape: BoxShape.circle,
              ),
            ),
            const Icon(
              Icons.shopping_bag_rounded,
              color: AppColors.primaryPurple,
              size: AppSize.iconXXXL + AppSize.iconXXL,
            ),
            Positioned(
              right: AppSize.paddingXXL,
              top: AppSize.paddingXXL,
              child: Container(
                padding: const EdgeInsets.all(
                  AppSize.paddingM - AppSize.paddingXS / 2,
                ),
                decoration: const BoxDecoration(
                  color: AppColors.accentYellow,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  size: AppSize.iconS,
                  color: AppColors.accentBrown,
                ),
              ),
            ),
            const Positioned(
              left: AppSize.paddingXXL,
              bottom: AppSize.paddingXXL,
              child: Icon(
                Icons.favorite_rounded,
                color: AppColors.accentCoral,
                size: AppSize.iconM,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoogleMark extends StatelessWidget {
  const _GoogleMark();

  @override
  Widget build(BuildContext context) {
    return Text(
      'G',
      style: TextStyle(
        fontSize: AppSize.fontXXXL,
        fontWeight: FontWeight.w800,
        color: AppColors.googleBlue,
        height: 1,
      ),
    );
  }
}

class _SignInError extends StatelessWidget {
  const _SignInError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSize.paddingM),
      decoration: BoxDecoration(
        color: AppColors.errorBackground,
        borderRadius: BorderRadius.circular(AppSize.radiusM),
      ),
      child: Text(
        message,
        style: const TextStyle(
          color: AppColors.errorText,
          height: AppSize.paddingM / AppSize.paddingS,
        ),
      ),
    );
  }
}
