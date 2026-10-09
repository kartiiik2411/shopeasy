import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../core/theme/app_color.dart';
import '../../../core/theme/app_size.dart';
import 'home_viewmodel.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({super.key});

  static const Color primary = AppColors.primaryPurple;
  static const Color pageBackground = AppColors.background;

  @override
  void onViewModelReady(HomeViewModel viewModel) {
    viewModel.loadUser();
  }

  @override
  Widget builder(BuildContext context, HomeViewModel viewModel, Widget? child) {
    final displayName = viewModel.user?.displayName;
    final photoUrl = viewModel.user?.photoUrl;
    return Scaffold(
      backgroundColor: pageBackground,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSize.paddingXL,
                  AppSize.paddingXL,
                  AppSize.paddingXL,
                  AppSize.paddingM,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(11),
                      decoration: BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(
                        Icons.shopping_bag_rounded,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                    const SizedBox(width: 11),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            displayName == null || displayName.isEmpty
                                ? 'ShopEasy'
                                : 'Hi, $displayName',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF252238),
                            ),
                          ),
                          const Text(
                            'Discover your next favorite',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => viewModel.setNavigationIndex(2),
                      icon: const Icon(
                        Icons.favorite_border_rounded,
                        color: primary,
                        size: 27,
                      ),
                    ),
                    IconButton(
                      tooltip: 'Sign out',
                      onPressed: viewModel.isBusy ? null : viewModel.signOut,
                      icon: const Icon(
                        Icons.logout_rounded,
                        color: Color(0xFF252238),
                        size: 23,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            if (viewModel.selectedNavIndex == 3)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSize.paddingXL,
                    AppSize.paddingS,
                    AppSize.paddingXL,
                    AppSize.paddingL,
                  ),
                  child: Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: photoUrl == null
                            ? null
                            : NetworkImage(photoUrl),
                        child: photoUrl == null
                            ? const Icon(Icons.person_outline_rounded)
                            : null,
                      ),
                      title: Text(displayName ?? 'ShopEasy account'),
                      subtitle: Text(viewModel.user?.email ?? ''),
                      trailing: const Icon(Icons.verified_user_outlined),
                    ),
                  ),
                ),
              ),

            // Search
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 18),
                child: TextField(
                  onChanged: viewModel.search,
                  decoration: InputDecoration(
                    hintText: 'Search products...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: viewModel.searchQuery.isNotEmpty
                        ? IconButton(
                            onPressed: () => viewModel.search(''),
                            icon: const Icon(Icons.close),
                          )
                        : const Icon(Icons.tune_rounded),
                  ),
                ),
              ),
            ),

            // Promotional banner
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(21),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6C3CE9), Color(0xFF9B75F5)],
                    ),
                    borderRadius: BorderRadius.circular(22),
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
                                color: Colors.white70,
                                fontSize: 10,
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Find your style.\nLove your choice.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 23,
                                height: 1.25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 9),
                            Text(
                              'Explore products picked for you.',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.shopping_bag_rounded,
                        color: Colors.white70,
                        size: 76,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Categories heading
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 25, 20, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Categories',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () => viewModel.setNavigationIndex(1),
                      child: const Text('View all'),
                    ),
                  ],
                ),
              ),
            ),

            // Category chips
            SliverToBoxAdapter(
              child: SizedBox(
                height: 43,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  children: HomeViewModel.categories.map((category) {
                    final selected = viewModel.selectedCategory == category;

                    return Padding(
                      padding: const EdgeInsets.only(right: 9),
                      child: ChoiceChip(
                        label: Text(category),
                        selected: selected,
                        onSelected: (_) => viewModel.selectCategory(category),
                        selectedColor: primary,
                        backgroundColor: Colors.white,
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                        labelStyle: TextStyle(
                          color: selected
                              ? Colors.white
                              : const Color(0xFF484458),
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            // Products heading
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 14),
                child: Text(
                  viewModel.selectedNavIndex == 2
                      ? 'My Wishlist'
                      : viewModel.searchQuery.isNotEmpty
                      ? 'Search Results'
                      : 'Popular Products',
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // Product grid
            if (viewModel.visibleProducts.isEmpty)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(35),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 45,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 12),
                        Text(
                          'No products found',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final product = viewModel.visibleProducts[index];
                    final id = product['id'] as int;
                    final favorite = viewModel.isWishlisted(id);

                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: Padding(
                                    padding: const EdgeInsets.all(9),
                                    child: Image.network(
                                      product['image'] as String,
                                      fit: BoxFit.contain,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return const Center(
                                              child: Icon(
                                                Icons.image_outlined,
                                                size: 42,
                                                color: Colors.grey,
                                              ),
                                            );
                                          },
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 5,
                                  right: 5,
                                  child: Material(
                                    color: Colors.white,
                                    shape: const CircleBorder(),
                                    child: IconButton(
                                      visualDensity: VisualDensity.compact,
                                      onPressed: () =>
                                          viewModel.toggleWishlist(id),
                                      icon: Icon(
                                        favorite
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: favorite
                                            ? Colors.red
                                            : Colors.grey,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(11, 5, 11, 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product['category'] as String,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  product['title'] as String,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star_rounded,
                                      color: Colors.amber,
                                      size: 15,
                                    ),
                                    const SizedBox(width: 3),
                                    Text(
                                      '${product['rating']}',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 11,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      '\$${(product['price'] as num).toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        color: primary,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
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
                  }, childCount: viewModel.visibleProducts.length),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 13,
                    mainAxisSpacing: 13,
                    mainAxisExtent: 245,
                  ),
                ),
              ),
          ],
        ),
      ),
      // Bottom navigation
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: viewModel.selectedNavIndex,
        onTap: viewModel.setNavigationIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category_outlined),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border_rounded),
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

  @override
  HomeViewModel viewModelBuilder(BuildContext context) => HomeViewModel();
}
