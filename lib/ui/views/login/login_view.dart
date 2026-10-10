import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../core/theme/app_color.dart';
import '../../../core/theme/app_size.dart';
import '../../common/app_dialog.dart';
import '../../common/app_text_field.dart';
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
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSize.paddingXXXL),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Form(
                key: viewModel.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: AppSize.imageS,
                      height: AppSize.imageS,
                      decoration: BoxDecoration(
                        color: AppColors.illustrationBackground,
                        borderRadius: BorderRadius.circular(AppSize.radiusL),
                      ),
                      child: const Icon(
                        Icons.shopping_bag_rounded,
                        color: AppColors.primaryPurple,
                        size: AppSize.iconXXL,
                      ),
                    ),
                    const SizedBox(height: AppSize.spaceL),
                    const Text(
                      'ShopEasy',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: AppSize.fontTitle,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: AppSize.spaceS),
                    const Text(
                      'Sign in to find your next favorite.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: AppSize.fontL,
                      ),
                    ),
                    const SizedBox(height: AppSize.spaceXXL),
                    AppTextField(
                      controller: viewModel.usernameController,
                      label: 'Username',
                      hintText: 'Enter your username',
                      prefixIcon: Icons.person_outline_rounded,
                      textInputAction: TextInputAction.next,
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                          ? 'Enter your username.'
                          : null,
                    ),
                    const SizedBox(height: AppSize.spaceL),
                    AppTextField(
                      controller: viewModel.passwordController,
                      label: 'Password',
                      hintText: 'Enter your password',
                      prefixIcon: Icons.lock_outline_rounded,
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Enter your password.'
                          : null,
                      onFieldSubmitted: (_) => _submit(context, viewModel),
                    ),
                    const SizedBox(height: AppSize.spaceXL),
                    SizedBox(
                      height: AppSize.buttonHeightL,
                      child: FilledButton(
                        onPressed: viewModel.isBusy
                            ? null
                            : () => _submit(context, viewModel),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primaryPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppSize.radiusM,
                            ),
                          ),
                        ),
                        child: viewModel.isBusy
                            ? const SizedBox(
                                width: AppSize.iconS,
                                height: AppSize.iconS,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.white,
                                ),
                              )
                            : const Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: AppSize.fontL,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: AppSize.spaceL),
                    const Text(
                      'Demo accounts: emilys / emilyspass · '
                      'michaelw / michaelwpass · sophiab / sophiabpass',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textTertiary,
                        fontSize: AppSize.fontS,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit(BuildContext context, LoginViewModel viewModel) async {
    if (viewModel.formKey.currentState?.validate() != true) return;
    final error = await viewModel.login();
    if (error != null && context.mounted) {
      await AppDialog.showError(context, error);
    }
  }

  @override
  LoginViewModel viewModelBuilder(BuildContext context) => LoginViewModel();
}
