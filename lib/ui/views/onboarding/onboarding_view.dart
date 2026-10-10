import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../core/theme/app_color.dart';
import 'onboarding_viewmodel.dart';

class OnboardingView extends StackedView<OnboardingViewModel> {
  const OnboardingView({super.key});

  static const Color _purple = Color(0xFF6750A4);
  static const Color _background = Color(0xFFF8F7FC);
  static const Color _foreground = Color(0xFF201A2C);
  static const Color _secondaryText = Color(0xFF716B7C);
  static const Color _border = Color(0xFFE9E5F0);

  static const List<_OnboardingPageData> _pages = [
    _OnboardingPageData(
      title: 'Discover Amazing Products',
      description:
          "Explore thousands of curated items from the world's top brands, all in one place.",
      image: 'assets/images/onboarding/discover_products.jpg',
      backgroundColor: _purple,
    ),
    _OnboardingPageData(
      title: 'Shop with Confidence',
      description:
          'Secure payments, genuine products, and hassle-free 30-day returns — always guaranteed.',
      image: 'assets/images/onboarding/shop_confidently.jpg',
      backgroundColor: Color(0xFFE65366),
    ),
    _OnboardingPageData(
      title: 'Fast Free Delivery',
      description:
          'Lightning-fast shipping to your doorstep. Free on orders over \$50.',
      image: 'assets/images/onboarding/fast_delivery.jpg',
      backgroundColor: Color(0xFFF5B84B),
    ),
  ];

  @override
  OnboardingViewModel viewModelBuilder(BuildContext context) =>
      OnboardingViewModel();

  @override
  Widget builder(
    BuildContext context,
    OnboardingViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double screenHeight = constraints.maxHeight;
            final double screenWidth = constraints.maxWidth;

            final double horizontalPadding = (screenWidth * 0.065).clamp(
              18.0,
              32.0,
            );

            final double imageHeight = (screenHeight * 0.43).clamp(
              200.0,
              390.0,
            );

            return Column(
              children: [
                // Top bar
                SizedBox(
                  height: 56,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: horizontalPadding),
                      child: TextButton(
                        onPressed: viewModel.skipOnboarding,
                        style: TextButton.styleFrom(
                          foregroundColor: _foreground,
                          backgroundColor: Colors.white.withValues(alpha: 0.88),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 9,
                          ),
                          shape: const StadiumBorder(),
                        ),
                        child: const Text(
                          'Skip',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Swipeable onboarding images
                Expanded(
                  flex: 6,
                  child: PageView.builder(
                    controller: viewModel.pageController,
                    itemCount: _pages.length,
                    onPageChanged: viewModel.onPageChanged,
                    itemBuilder: (context, index) {
                      final page = _pages[index];

                      return Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: horizontalPadding,
                            vertical: 8,
                          ),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: 520,
                              maxHeight: imageHeight,
                            ),
                            child: AspectRatio(
                              aspectRatio: 1.05,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(26),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.8),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.12,
                                      ),
                                      blurRadius: 22,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: Image.asset(
                                    page.image,
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.white,
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.all(20),
                                        child: const Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons
                                                  .image_not_supported_outlined,
                                              size: 42,
                                              color: _secondaryText,
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              'Image not found. Check the asset path.',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: _secondaryText,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Information panel
                Expanded(
                  flex: 5,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      18,
                      horizontalPadding,
                      12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                      border: Border.all(color: _border),
                      boxShadow: [
                        BoxShadow(
                          color: _purple.withValues(alpha: 0.05),
                          blurRadius: 20,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 8),

                        // Active page indicator
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(_pages.length, (index) {
                            final bool isActive =
                                viewModel.currentPage == index;

                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeInOut,
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: isActive ? 28 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: isActive
                                    ? _purple
                                    : const Color(0xFFD9D3E7),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            );
                          }),
                        ),

                        const SizedBox(height: 20),

                        // Title and description follow the selected page.
                        Expanded(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            switchInCurve: Curves.easeOut,
                            switchOutCurve: Curves.easeIn,
                            child: _buildPageText(
                              _pages[viewModel.currentPage],
                              screenWidth,
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Next / Get Started
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton(
                            onPressed: viewModel.nextPage,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _purple,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  viewModel.currentPage ==
                                          OnboardingViewModel.totalPages - 1
                                      ? 'Get Started'
                                      : 'Next',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildPageText(_OnboardingPageData page, double screenWidth) {
    final double titleSize = (screenWidth * 0.065).clamp(22.0, 30.0);
    final double descriptionSize = (screenWidth * 0.037).clamp(14.0, 17.0);

    return Center(
      key: ValueKey(page.title),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              page.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _foreground,
                fontSize: titleSize,
                fontWeight: FontWeight.w800,
                height: 1.18,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              page.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _secondaryText,
                fontSize: descriptionSize,
                height: 1.55,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPageData {
  const _OnboardingPageData({
    required this.title,
    required this.description,
    required this.image,
    required this.backgroundColor,
  });

  final String title;
  final String description;
  final String image;
  final Color backgroundColor;
}
