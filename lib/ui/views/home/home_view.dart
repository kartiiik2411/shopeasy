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
  void onViewModelReady(HomeViewModel viewModel) {
    super.onViewModelReady(viewModel);
    viewModel.loadUser();
  }

  @override
  Widget builder(BuildContext context, HomeViewModel viewModel, Widget? child) {
    final user = viewModel.user;

    // AuthUser field names used here must match your entity.
    final displayName = user?.displayName;
    final photoUrl = user?.photoUrl;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSize.paddingL),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSize.paddingM),
                      decoration: BoxDecoration(
                        gradient: AppColors.buttonGradient,
                        borderRadius: BorderRadius.circular(AppSize.radiusM),
                      ),
                      child: const Icon(
                        Icons.shopping_bag_rounded,
                        color: AppColors.white,
                        size: AppSize.iconL,
                      ),
                    ),
                    const SizedBox(width: AppSize.spaceM),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            displayName == null || displayName.trim().isEmpty
                                ? 'ShopEasy'
                                : 'Hi, $displayName',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.black,
                              fontSize: AppSize.fontXXL,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'Discover your next favorite',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: AppSize.fontXS,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Wishlist',
                      onPressed: () => viewModel.setNavigationIndex(2),
                      icon: const Icon(
                        Icons.favorite_border_rounded,
                        color: AppColors.primaryPurple,
                      ),
                    ),
                    IconButton(
                      tooltip: 'Sign out',
                      onPressed: viewModel.isBusy ? null : viewModel.signOut,
                      icon: const Icon(
                        Icons.logout_rounded,
                        color: AppColors.primaryPurple,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Account details
            if (viewModel.selectedNavIndex == 3)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSize.paddingL,
                  ),
                  child: Card(
                    color: AppColors.white,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.illustrationBackground,
                        backgroundImage: photoUrl == null || photoUrl.isEmpty
                            ? null
                            : NetworkImage(photoUrl),
                        child: photoUrl == null || photoUrl.isEmpty
                            ? const Icon(
                                Icons.person_outline_rounded,
                                color: AppColors.primaryPurple,
                              )
                            : null,
                      ),
                      title: Text(
                        displayName?.isNotEmpty == true
                            ? displayName!
                            : 'ShopEasy account',
                      ),
                      subtitle: Text(user?.email ?? ''),
                      trailing: const Icon(
                        Icons.verified_user_outlined,
                        color: AppColors.primaryPurple,
                      ),
                    ),
                  ),
                ),
              ),

            // Search bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSize.paddingL,
                  AppSize.paddingS,
                  AppSize.paddingL,
                  AppSize.paddingL,
                ),
                child: TextField(
                  onChanged: viewModel.search,
                  decoration: InputDecoration(
                    hintText: 'Search products...',
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: AppColors.primaryPurple,
                    ),
                    suffixIcon: viewModel.searchQuery.isNotEmpty
                        ? IconButton(
                            onPressed: () => viewModel.search(''),
                            icon: const Icon(Icons.close),
                          )
                        : const Icon(
                            Icons.tune_rounded,
                            color: AppColors.primaryPurple,
                          ),
                    filled: true,
                    fillColor: AppColors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: AppSize.paddingL,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSize.inputRadius),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSize.inputRadius),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSize.inputRadius),
                      borderSide: const BorderSide(
                        color: AppColors.primaryPurple,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Promotional banner
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSize.paddingL,
                ),
                child: Container(
                  padding: const EdgeInsets.all(AppSize.paddingXL),
                  decoration: BoxDecoration(
                    gradient: AppColors.purplePinkGradient,
                    borderRadius: BorderRadius.circular(AppSize.radiusXXL),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.primaryPurpleShadow,
                        blurRadius: AppSize.elevationL,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'SPECIAL COLLECTION',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: AppSize.fontXS,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                            SizedBox(height: AppSize.spaceM),
                            Text(
                              'Find your style.\nLove your choice.',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: AppSize.fontXXL,
                                height: 1.25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: AppSize.spaceS),
                            Text(
                              'Explore products picked for you.',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: AppSize.fontXS,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSize.spaceS),
                      const Icon(
                        Icons.shopping_bag_rounded,
                        color: AppColors.white,
                        size: AppSize.iconXXXL,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Categories heading
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSize.paddingL,
                  AppSize.paddingXXL,
                  AppSize.paddingL,
                  AppSize.paddingM,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Categories',
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: AppSize.fontXXL,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () => viewModel.setNavigationIndex(1),
                      child: const Text(
                        'View all',
                        style: TextStyle(color: AppColors.primaryPurple),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Category chips
            SliverToBoxAdapter(
              child: SizedBox(
                height: 44,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSize.paddingL,
                  ),
                  scrollDirection: Axis.horizontal,
                  itemCount: HomeViewModel.categories.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(width: AppSize.spaceS),
                  itemBuilder: (context, index) {
                    final category = HomeViewModel.categories[index];
                    final selected = viewModel.selectedCategory == category;

                    return ChoiceChip(
                      label: Text(category),
                      selected: selected,
                      onSelected: (_) => viewModel.selectCategory(category),
                      selectedColor: AppColors.primaryPurple,
                      backgroundColor: AppColors.white,
                      side: BorderSide(
                        color: selected
                            ? AppColors.primaryPurple
                            : AppColors.border,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppSize.radiusCircular,
                        ),
                      ),
                      showCheckmark: false,
                      labelStyle: TextStyle(
                        color: selected
                            ? AppColors.white
                            : AppColors.textSecondary,
                        fontSize: AppSize.fontS,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  },
                ),
              ),
            ),

            // Product section heading
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSize.paddingL,
                  AppSize.paddingXXL,
                  AppSize.paddingL,
                  AppSize.paddingM,
                ),
                child: Text(
                  viewModel.selectedNavIndex == 2
                      ? 'My Wishlist'
                      : viewModel.searchQuery.isNotEmpty
                      ? 'Search Results'
                      : viewModel.selectedNavIndex == 1
                      ? 'Browse Products'
                      : 'Popular Products',
                  style: const TextStyle(
                    color: AppColors.black,
                    fontSize: AppSize.fontXXL,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // Product grid
            if (viewModel.visibleProducts.isEmpty)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(AppSize.paddingXXXL),
                  child: Center(
                    child: Text(
                      'No products found.',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: AppSize.fontM,
                      ),
                    ),
                  ),
                ),
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

      // Bottom navigation
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: viewModel.selectedNavIndex,
        onTap: viewModel.setNavigationIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.primaryPurple,
        unselectedItemColor: AppColors.textTertiary,
        selectedFontSize: AppSize.fontXS,
        unselectedFontSize: AppSize.fontXS,
        elevation: AppSize.elevationS,
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
            activeIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(
    HomeViewModel viewModel,
    Map<String, Object> product,
  ) {
    final id = product['id']! as int;
    final title = product['title']! as String;
    final category = product['category']! as String;
    final price = product['price']! as num;
    final rating = product['rating']! as num;
    final image = product['image']! as String;
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
                      image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppColors.illustrationBackground,
                          child: const Center(
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              color: AppColors.primaryPurple,
                              size: AppSize.iconXXL,
                            ),
                          ),
                        );
                      },
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
                          wishlisted
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
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
                  category,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textTertiary,
                    fontSize: AppSize.fontXS,
                  ),
                ),
                const SizedBox(height: AppSize.spaceXS),
                Text(
                  title,
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
                        '\$${price.toStringAsFixed(2)}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
                      rating.toString(),
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
}
