import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import '../../../core/theme/app_color.dart';

import '../../../domain/entities/product.dart';

import 'home_viewmodel.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({super.key});

  @override
  void onViewModelReady(HomeViewModel viewModel) {
    viewModel.initialise();
  }

  @override
  HomeViewModel viewModelBuilder(BuildContext context) => HomeViewModel();

  @override
  Widget builder(BuildContext context, HomeViewModel viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        bottom: false,

        child: Column(
          children: [
            _HomeHeader(viewModel: viewModel),

            Expanded(child: _buildBody(viewModel)),
          ],
        ),
      ),

      bottomNavigationBar: _BottomNavigation(
        selectedIndex: viewModel.selectedNavigationIndex,

        onSelected: viewModel.selectDestination,
      ),
    );
  }

  Widget _buildBody(HomeViewModel viewModel) {
    switch (viewModel.selectedNavigationIndex) {
      case 1:
        return _CategoriesPage(viewModel: viewModel);

      case 2:
        return const _EmptyPage(
          icon: Icons.favorite_border_rounded,

          title: 'Your Wishlist',

          subtitle: 'Products you save will appear here.',
        );

      case 3:
        return const _EmptyPage(
          icon: Icons.shopping_cart_outlined,

          title: 'Your Cart',

          subtitle: 'Add products you love to your cart.',
        );

      case 4:
        return _ProfilePage(viewModel: viewModel);

      default:
        return _HomeContent(viewModel: viewModel);
    }
  }
}

// -----------------------------------------------------------------------------

// Header and search

// -----------------------------------------------------------------------------

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({required this.viewModel});

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final name = viewModel.user?.displayName?.trim();

    final greetingName = name == null || name.isEmpty
        ? 'ShopEasy Customer'
        : name;

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),

      decoration: const BoxDecoration(
        color: AppColors.primaryPurple,

        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const Text(
                      'Welcome to ShopEasy,',

                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      greetingName,

                      maxLines: 1,

                      overflow: TextOverflow.ellipsis,

                      style: const TextStyle(
                        color: Colors.white,

                        fontSize: 20,

                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const CircleAvatar(
                backgroundColor: Colors.white24,

                child: Icon(Icons.shopping_bag_outlined, color: Colors.white),
              ),
            ],
          ),

          const SizedBox(height: 20),

          TextField(
            onChanged: viewModel.search,

            textInputAction: TextInputAction.search,

            decoration: InputDecoration(
              hintText: 'Search products...',

              prefixIcon: const Icon(Icons.search_rounded),

              filled: true,

              fillColor: Colors.white,

              contentPadding: const EdgeInsets.symmetric(vertical: 14),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),

                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------

// Home content

// -----------------------------------------------------------------------------

class _HomeContent extends StatelessWidget {
  const _HomeContent({required this.viewModel});

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 20),

      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),

          child: Text(
            'Find your favourites',

            style: TextStyle(
              fontSize: 23,

              fontWeight: FontWeight.bold,

              color: AppColors.black,
            ),
          ),
        ),

        const SizedBox(height: 18),

        _CategorySection(viewModel: viewModel),

        const SizedBox(height: 24),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),

          child: Text(
            viewModel.selectedCategory == null
                ? 'Trending Products'
                : 'Filtered Products',

            style: const TextStyle(
              fontSize: 21,

              fontWeight: FontWeight.bold,

              color: AppColors.black,
            ),
          ),
        ),

        const SizedBox(height: 14),

        _ProductSection(viewModel: viewModel),
      ],
    );
  }
}

// -----------------------------------------------------------------------------

// Categories

// -----------------------------------------------------------------------------

class _CategorySection extends StatelessWidget {
  const _CategorySection({required this.viewModel});

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,

      child: ListView(
        scrollDirection: Axis.horizontal,

        padding: const EdgeInsets.symmetric(horizontal: 20),

        children: [
          _CategoryChip(
            label: 'All',

            selected: viewModel.selectedCategory == null,

            onTap: () => viewModel.selectCategory(null),
          ),

          ...viewModel.categories.map(
            (category) => _CategoryChip(
              label: _formatCategory(category),

              selected: viewModel.selectedCategory == category,

              onTap: () => viewModel.selectCategory(category),
            ),
          ),
        ],
      ),
    );
  }

  String _formatCategory(String value) {
    return value
        .split('-')
        .map(
          (word) => word.isEmpty
              ? word
              : '${word[0].toUpperCase()}${word.substring(1)}',
        )
        .join(' ');
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,

    required this.selected,

    required this.onTap,
  });

  final String label;

  final bool selected;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),

      child: ChoiceChip(
        label: Text(label),

        selected: selected,

        onSelected: (_) => onTap(),

        selectedColor: AppColors.primaryPurple,

        backgroundColor: Colors.white,

        labelStyle: TextStyle(
          color: selected ? Colors.white : AppColors.black,

          fontWeight: FontWeight.w600,
        ),

        side: BorderSide.none,
      ),
    );
  }
}

// -----------------------------------------------------------------------------

// Products

// -----------------------------------------------------------------------------

class _ProductSection extends StatelessWidget {
  const _ProductSection({required this.viewModel});

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    if (viewModel.isLoadingProducts && viewModel.products.isEmpty) {
      return const SizedBox(
        height: 240,

        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (viewModel.products.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20),

        child: Center(child: Text('No products found.')),
      );
    }

    return SizedBox(
      height: 285,

      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),

        scrollDirection: Axis.horizontal,

        itemCount: viewModel.products.length,

        separatorBuilder: (_, _) => const SizedBox(width: 14),

        itemBuilder: (context, index) {
          final product = viewModel.products[index];

          return SizedBox(
            width: 190,
            child: GestureDetector(
              onTap: viewModel.openProductDetails,
              child: _ProductCard(product: product),
            ),
          );
        },
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,

      color: AppColors.white,

      elevation: 2,

      clipBehavior: Clip.antiAlias,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Expanded(
            child: Container(
              width: double.infinity,

              color: const Color(0xFFF7F7FA),

              padding: const EdgeInsets.all(10),

              child: Image.network(
                product.thumbnail,

                fit: BoxFit.contain,

                errorBuilder: (_, _, _) {
                  return const Center(
                    child: Icon(Icons.image_not_supported_outlined, size: 36),
                  );
                },
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  product.title,

                  maxLines: 2,

                  overflow: TextOverflow.ellipsis,

                  style: const TextStyle(
                    fontSize: 14,

                    fontWeight: FontWeight.w600,

                    color: AppColors.black,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  '\$${product.price.toStringAsFixed(2)}',

                  style: const TextStyle(
                    fontSize: 17,

                    fontWeight: FontWeight.bold,

                    color: AppColors.primaryPurple,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------

// Categories page

// -----------------------------------------------------------------------------

class _CategoriesPage extends StatelessWidget {
  const _CategoriesPage({required this.viewModel});

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),

      children: [
        ListTile(
          leading: const Icon(Icons.storefront_outlined),

          title: const Text('All Products'),

          trailing: const Icon(Icons.chevron_right),

          onTap: () => viewModel.selectCategoryFromCategories(null),
        ),

        ...viewModel.categories.map(
          (category) => ListTile(
            leading: const Icon(Icons.category_outlined),

            title: Text(category),

            trailing: const Icon(Icons.chevron_right),

            onTap: () => viewModel.selectCategoryFromCategories(category),
          ),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------

// Profile page

// -----------------------------------------------------------------------------

class _ProfilePage extends StatelessWidget {
  const _ProfilePage({required this.viewModel});

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final user = viewModel.user;

    final displayName = user?.displayName;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),

        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            const CircleAvatar(
              radius: 38,

              backgroundColor: Color(0xFFEDE7F6),

              child: Icon(
                Icons.person_rounded,

                size: 42,

                color: AppColors.primaryPurple,
              ),
            ),

            const SizedBox(height: 16),

            Text(
              displayName?.isNotEmpty == true
                  ? displayName!
                  : 'ShopEasy Customer',

              style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
            ),

            if (user != null) ...[
              const SizedBox(height: 8),

              Text(
                user.email,

                style: const TextStyle(color: AppColors.textSecondary),
              ),
            ],

            const SizedBox(height: 24),

            FilledButton.icon(
              onPressed: viewModel.isSigningOut ? null : viewModel.signOut,

              icon: const Icon(Icons.logout_rounded),

              label: Text(
                viewModel.isSigningOut ? 'Signing out...' : 'Sign out',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------

// Wishlist and cart placeholders

// -----------------------------------------------------------------------------

class _EmptyPage extends StatelessWidget {
  const _EmptyPage({
    required this.icon,

    required this.title,

    required this.subtitle,
  });

  final IconData icon;

  final String title;

  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),

        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            Icon(icon, size: 60, color: AppColors.primaryPurple),

            const SizedBox(height: 16),

            Text(
              title,

              style: const TextStyle(
                fontSize: 22,

                fontWeight: FontWeight.bold,

                color: AppColors.black,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              subtitle,

              textAlign: TextAlign.center,

              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------

// Bottom navigation

// -----------------------------------------------------------------------------

class _BottomNavigation extends StatelessWidget {
  const _BottomNavigation({
    required this.selectedIndex,

    required this.onSelected,
  });

  final int selectedIndex;

  final ValueChanged<int> onSelected;

  static const _items = [
    (Icons.home_outlined, Icons.home_rounded, 'Home'),

    (Icons.grid_view_outlined, Icons.grid_view_rounded, 'Categories'),

    (Icons.favorite_border_rounded, Icons.favorite_rounded, 'Wishlist'),

    (Icons.shopping_cart_outlined, Icons.shopping_cart_rounded, 'Cart'),

    (Icons.person_outline_rounded, Icons.person_rounded, 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,

        border: Border(top: BorderSide(color: AppColors.border)),
      ),

      child: SafeArea(
        top: false,

        child: Row(
          children: List.generate(_items.length, (index) {
            final item = _items[index];

            final selected = selectedIndex == index;

            return Expanded(
              child: InkWell(
                onTap: () => onSelected(index),

                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),

                  child: Column(
                    mainAxisSize: MainAxisSize.min,

                    children: [
                      Icon(
                        selected ? item.$2 : item.$1,

                        color: selected
                            ? AppColors.primaryPurple
                            : AppColors.textSecondary,

                        size: 24,
                      ),

                      const SizedBox(height: 4),

                      Text(
                        item.$3,

                        maxLines: 1,

                        style: TextStyle(
                          fontSize: 10,

                          color: selected
                              ? AppColors.primaryPurple
                              : AppColors.textSecondary,

                          fontWeight: selected
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
