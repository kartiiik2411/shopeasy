import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../core/theme/app_color.dart';
import '../../../core/theme/app_size.dart';
import 'home_viewmodel.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({super.key});

  @override
  HomeViewModel viewModelBuilder(BuildContext context) => HomeViewModel();

  @override
  Widget builder(BuildContext context, HomeViewModel viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSize.paddingL),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: AppSize.spaceXL),
                    _buildWelcome(),
                    const SizedBox(height: AppSize.spaceL),
                    _buildSearch(viewModel),
                    const SizedBox(height: AppSize.spaceXL),
                    _buildBanner(),
                    const SizedBox(height: AppSize.spaceXXL),
                    _buildSectionTitle('Categories', 'Explore'),
                    const SizedBox(height: AppSize.spaceM),
                    _buildCategories(viewModel),
                    const SizedBox(height: AppSize.spaceXXL),
                    _buildSectionTitle(
                      viewModel.selectedNavIndex == 2
                          ? 'My Wishlist'
                          : 'Popular Products',
                      '${viewModel.visibleProducts.length} items',
                    ),
                    const SizedBox(height: AppSize.spaceM),
                  ],
                ),
              ),
            ),
            if (viewModel.visibleProducts.isEmpty)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: Text('No products found.')),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSize.paddingL,
                ),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildProductCard(
                      viewModel,
                      viewModel.visibleProducts[index],
                    ),
                    childCount: viewModel.visibleProducts.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: AppSize.spaceM,
                    mainAxisSpacing: AppSize.spaceM,
                    mainAxisExtent: 290,
                  ),
                ),
              ),
            const SliverToBoxAdapter(child: SizedBox(height: AppSize.spaceXXL)),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(viewModel),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          height: 46,
          width: 46,
          decoration: BoxDecoration(
            gradient: AppColors.buttonGradient,
            borderRadius: BorderRadius.circular(AppSize.radiusL),
          ),
          child: const Icon(
            Icons.shopping_bag_outlined,
            color: AppColors.white,
            size: AppSize.iconL,
          ),
        ),
        const SizedBox(width: AppSize.spaceM),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ShopEasy',
                style: TextStyle(
                  color: AppColors.primaryPurple,
                  fontSize: AppSize.fontXXL,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Good things, great prices.',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: AppSize.fontXS,
                ),
              ),
            ],
          ),
        ),
        _iconButton(Icons.notifications_none_rounded, () {}),
      ],
    );
  }

  Widget _buildWelcome() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome back 👋',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: AppSize.fontM,
          ),
        ),
        SizedBox(height: AppSize.spaceXS),
        Text(
          'Find your next favorite',
          style: TextStyle(
            color: AppColors.black,
            fontSize: AppSize.fontHeading,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSearch(HomeViewModel viewModel) {
    return Container(
      height: AppSize.inputHeight,
      padding: const EdgeInsets.symmetric(horizontal: AppSize.paddingL),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSize.inputRadius),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, color: AppColors.textTertiary),
          const SizedBox(width: AppSize.spaceM),
          Expanded(
            child: TextField(
              onChanged: viewModel.search,
              decoration: const InputDecoration(
                hintText: 'Search products...',
                hintStyle: TextStyle(
                  color: AppColors.textTertiary,
                  fontSize: AppSize.fontM,
                ),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          const Icon(Icons.tune_rounded, color: AppColors.primaryPurple),
        ],
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSize.paddingXXL),
      decoration: BoxDecoration(
        gradient: AppColors.purplePinkGradient,
        borderRadius: BorderRadius.circular(AppSize.radiusXXL),
        boxShadow: const [
          BoxShadow(
            color: AppColors.primaryPurpleShadow,
            blurRadius: AppSize.elevationL,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSize.paddingM,
              vertical: AppSize.paddingS,
            ),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppSize.radiusCircular),
            ),
            child: const Text(
              'YOUR NEXT GREAT FIND',
              style: TextStyle(
                color: AppColors.white,
                fontSize: AppSize.fontXS,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
          const SizedBox(height: AppSize.spaceL),
          const Text(
            'Discover more.\nSpend less.',
            style: TextStyle(
              color: AppColors.white,
              fontSize: AppSize.fontTitle,
              height: 1.2,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSize.spaceS),
          const Text(
            'Explore everyday essentials and new arrivals.',
            style: TextStyle(color: AppColors.white, fontSize: AppSize.fontS),
          ),
          const SizedBox(height: AppSize.spaceL),
          FilledButton(
            onPressed: () {},
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.white,
              foregroundColor: AppColors.primaryPurple,
              minimumSize: const Size(140, AppSize.buttonHeightS),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSize.buttonRadius),
              ),
            ),
            child: const Text(
              'Explore now  →',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, String action) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.black,
            fontSize: AppSize.fontXXL,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          action,
          style: const TextStyle(
            color: AppColors.primaryPurple,
            fontSize: AppSize.fontS,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildCategories(HomeViewModel viewModel) {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: viewModel.categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSize.spaceS),
        itemBuilder: (context, index) {
          final category = viewModel.categories[index];
          final selected = viewModel.selectedCategory == category;

          return ChoiceChip(
            label: Text(category),
            selected: selected,
            onSelected: (_) => viewModel.selectCategory(category),
            backgroundColor: AppColors.white,
            selectedColor: AppColors.primaryPurple,
            side: BorderSide(
              color: selected ? AppColors.primaryPurple : AppColors.border,
            ),
            labelStyle: TextStyle(
              color: selected ? AppColors.white : AppColors.textSecondary,
              fontSize: AppSize.fontS,
              fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSize.radiusCircular),
            ),
            showCheckmark: false,
          );
        },
      ),
    );
  }

  Widget _buildProductCard(
    HomeViewModel viewModel,
    Map<String, dynamic> product,
  ) {
    final id = product['id'] as int;
    final wishlisted = viewModel.isWishlisted(id);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSize.radiusL),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(AppSize.radiusL),
                    ),
                    child: Image.network(
                      product['image'] as String,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(
                        color: AppColors.illustrationBackground,
                        child: const Icon(
                          Icons.image_not_supported_outlined,
                          color: AppColors.primaryPurple,
                          size: AppSize.iconXXL,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: AppSize.paddingS,
                  right: AppSize.paddingS,
                  child: Material(
                    color: AppColors.white,
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () => viewModel.toggleWishlist(id),
                      child: Padding(
                        padding: const EdgeInsets.all(AppSize.paddingS),
                        child: Icon(
                          wishlisted ? Icons.favorite : Icons.favorite_border,
                          color: wishlisted
                              ? AppColors.primaryPink
                              : AppColors.textSecondary,
                          size: AppSize.iconS,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSize.paddingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['category'] as String,
                  style: const TextStyle(
                    color: AppColors.textTertiary,
                    fontSize: AppSize.fontXS,
                  ),
                ),
                const SizedBox(height: AppSize.spaceXS),
                Text(
                  product['name'] as String,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.black,
                    fontSize: AppSize.fontM,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSize.spaceS),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '₹${(product['price'] as num).toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: AppColors.primaryPurple,
                          fontSize: AppSize.fontL,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.star_rounded,
                      color: AppColors.accentYellow,
                      size: AppSize.iconS,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '${product['rating']}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: AppSize.fontS,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation(HomeViewModel viewModel) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: BottomNavigationBar(
        currentIndex: viewModel.selectedNavIndex,
        onTap: viewModel.setNavigationIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.primaryPurple,
        unselectedItemColor: AppColors.textTertiary,
        selectedFontSize: AppSize.fontXS,
        unselectedFontSize: AppSize.fontXS,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_rounded),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border_rounded),
            activeIcon: Icon(Icons.favorite_rounded),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _iconButton(IconData icon, VoidCallback onPressed) {
    return Material(
      color: AppColors.white,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: Container(
          height: AppSize.avatarM,
          width: AppSize.avatarM,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.border),
          ),
          child: Icon(icon, color: AppColors.black, size: AppSize.iconM),
        ),
      ),
    );
  }
}
