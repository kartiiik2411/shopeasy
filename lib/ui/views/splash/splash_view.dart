import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../core/theme/app_color.dart';
import '../../../core/theme/app_size.dart';
import 'splash_viewmodel.dart';

class SplashView extends StackedView<SplashViewModel> {
  const SplashView({super.key});

  @override
  Widget builder(
    BuildContext context,
    SplashViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: AppColors.primaryPurple,
      body: SafeArea(
        child: Center(
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.85, end: 1.0),
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeOutBack,
            builder: (context, scale, child) {
              return Transform.scale(scale: scale, child: child);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(AppSize.radiusL),
                  ),
                  child: const Icon(
                    Icons.shopping_bag_outlined,
                    color: AppColors.primaryPurple,
                    size: AppSize.iconXXL,
                  ),
                ),
                const SizedBox(height: AppSize.spaceL),
                const Text(
                  'ShopEasy',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.7,
                  ),
                ),
                const SizedBox(height: AppSize.spaceXS),
                const Text(
                  'Shop smarter, live better',
                  style: TextStyle(
                    color: Color(0xFFD5CBEF),
                    fontSize: AppSize.fontS,
                  ),
                ),
                const SizedBox(height: AppSize.spaceL),
                const _LoadingDots(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  SplashViewModel viewModelBuilder(BuildContext context) {
    return SplashViewModel();
  }

  @override
  void onViewModelReady(SplashViewModel viewModel) {
    viewModel.startSplashTimer();
  }
}

class _LoadingDots extends StatefulWidget {
  const _LoadingDots();

  @override
  State<_LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<_LoadingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            final phase = (_controller.value + index * 0.22) % 1.0;

            final opacity = (0.35 + phase * 0.65).clamp(0.35, 1.0).toDouble();

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: opacity),
                shape: BoxShape.circle,
              ),
            );
          }),
        );
      },
    );
  }
}
