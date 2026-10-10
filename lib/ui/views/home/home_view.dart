import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../core/theme/app_color.dart';
import '../../../core/theme/app_size.dart';
import '../../../domain/entities/product.dart';
import 'home_viewmodel.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({super.key});

  @override
  void onViewModelReady(HomeViewModel viewModel) {
    viewModel.initialise();
  }

  @override
  Widget builder(BuildContext context, HomeViewModel viewModel, Widget? child) {
    final displayName = viewModel.user?.displayName;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              switch (viewModel.selectedNavigationIndex) {
                1 => 'Categories',
                2 => 'Your Cart',
                3 => 'Profile',
                _ =>
                  displayName == null || displayName.isEmpty
                      ? 'ShopEasy'
                      : 'Hi, $displayName',
              },
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.black,
                fontSize: AppSize.fontXXL,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (viewModel.selectedNavigationIndex == 0)
              const Text(
                'Discover your next favorite',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: AppSize.fontS,
                ),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: AppSize.spaceXXL)),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Sign out',
            onPressed: viewModel.isSigningOut ? null : viewModel.signOut,
            icon: viewModel.isSigningOut
                ? const SizedBox(
                    width: AppSize.iconS,
                    height: AppSize.iconS,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.logout_rounded),
          ),
        ],
      ),
      body: _buildDestination(viewModel),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: viewModel.selectedNavigationIndex,
        onTap: viewModel.selectDestination,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.primaryPurple,
        unselectedItemColor: AppColors.textSecondary,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category_outlined),
            activeIcon: Icon(Icons.category_rounded),
            label: 'Category',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            activeIcon: Icon(Icons.shopping_cart_rounded),
            label: 'Cart',
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

  Widget _buildDestination(HomeViewModel viewModel) {
    return switch (viewModel.selectedNavigationIndex) {
      1 => _buildCategories(viewModel),
      2 => _buildCart(),
      3 => _buildProfile(viewModel),
      _ => _buildHome(viewModel),
    };
  }

  Widget _buildHome(HomeViewModel viewModel) {
    return Column(
      children: [
        if (viewModel.accountError != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSize.paddingL,
              AppSize.paddingS,
              AppSize.paddingL,
              0,
            ),
            child: Text(
              'Could not load your account details: ${viewModel.accountError}',
              style: const TextStyle(color: AppColors.errorText),
            ),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSize.paddingL,
            AppSize.paddingS,
            AppSize.paddingL,
            AppSize.paddingM,
          ),
          child: TextField(
            onChanged: viewModel.search,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: 'Search products...',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: viewModel.searchQuery.isEmpty
                  ? null
                  : IconButton(
                      tooltip: 'Clear search',
                      onPressed: () => viewModel.search(''),
                      icon: const Icon(Icons.close_rounded),
                    ),
              filled: true,
              fillColor: AppColors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSize.radiusM),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        if (viewModel.categoriesError != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSize.paddingL),
            child: Text(
              'Could not load categories: ${viewModel.categoriesError}',
              style: const TextStyle(color: AppColors.errorText),
            ),
          )
        else if (viewModel.categories.isNotEmpty)
          SizedBox(
            height: AppSize.buttonHeightS,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: AppSize.paddingL),
              scrollDirection: Axis.horizontal,
              children: [
                _CategoryChip(
                  label: 'All',
                  selected: viewModel.selectedCategory == null,
                  onSelected: () => viewModel.selectCategory(null),
                ),
                ...viewModel.categories.map(
                  (category) => _CategoryChip(
                    label: _prettyCategory(category),
                    selected: viewModel.selectedCategory == category,
                    onSelected: () => viewModel.selectCategory(category),
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: AppSize.spaceS),
        Expanded(
          child: _ProductContent(
            products: viewModel.products,
            isBusy: viewModel.isBusy || viewModel.isLoadingProducts,
            error: viewModel.productsError,
            onRetry: viewModel.loadProducts,
            onProductTap: viewModel.openProduct,
          ),
        ),
      ],
    );
  }

  Widget _buildCategories(HomeViewModel viewModel) {
    if (viewModel.categoriesError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSize.paddingL),
          child: Text(
            'Could not load categories: ${viewModel.categoriesError}',
            style: const TextStyle(color: AppColors.errorText),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    if (viewModel.categories.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      padding: const EdgeInsets.all(AppSize.paddingL),
      children: [
        _CategoryTile(
          label: 'All Products',
          icon: Icons.storefront_outlined,
          onTap: () => viewModel.selectCategoryFromCategories(null),
        ),
        ...viewModel.categories.map(
          (category) => _CategoryTile(
            label: _prettyCategory(category),
            icon: _categoryIcon(category),
            onTap: () => viewModel.selectCategoryFromCategories(category),
          ),
        ),
      ],
    );
  }

  Widget _buildCart() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(AppSize.paddingXXL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              color: AppColors.primaryPurple,
              size: AppSize.iconXXXL,
            ),
            SizedBox(height: AppSize.spaceL),
            Text(
              'Your cart is empty',
              style: TextStyle(
                color: AppColors.black,
                fontSize: AppSize.fontXL,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: AppSize.spaceS),
            Text(
              'Add products you love and they will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfile(HomeViewModel viewModel) {
    final user = viewModel.user;
    final displayName = user?.displayName;
    return ListView(
      padding: const EdgeInsets.all(AppSize.paddingL),
      children: [
        CircleAvatar(
          radius: AppSize.imageS,
          backgroundColor: AppColors.illustrationBackground,
          backgroundImage: user?.photoUrl == null
              ? null
              : NetworkImage(user!.photoUrl!),
          child: user?.photoUrl == null
              ? const Icon(
                  Icons.person_rounded,
                  color: AppColors.primaryPurple,
                  size: AppSize.iconXXL,
                )
              : null,
        ),
        const SizedBox(height: AppSize.spaceM),
        Center(
          child: Text(
            displayName == null || displayName.isEmpty
                ? 'ShopEasy Customer'
                : displayName,
            style: const TextStyle(
              color: AppColors.black,
              fontSize: AppSize.fontXL,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        if (user != null) ...[
          const SizedBox(height: AppSize.spaceS),
          Center(
            child: Text(
              user.email,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
        ],
        if (viewModel.accountError != null) ...[
          const SizedBox(height: AppSize.spaceM),
          Text(
            'Could not load your account details: ${viewModel.accountError}',
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.errorText),
          ),
        ],
        const SizedBox(height: AppSize.spaceXXL),
        OutlinedButton.icon(
          onPressed: viewModel.isSigningOut ? null : viewModel.signOut,
          icon: viewModel.isSigningOut
              ? const SizedBox(
                  width: AppSize.iconS,
                  height: AppSize.iconS,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.logout_rounded),
          label: const Text('Sign out'),
        ),
      ],
    );
  }

  IconData _categoryIcon(String category) {
    if (category.contains('beauty')) return Icons.spa_outlined;
    if (category.contains('fragrance')) return Icons.air_outlined;
    if (category.contains('furniture')) return Icons.chair_outlined;
    if (category.contains('laptop') || category.contains('smartphone')) {
      return Icons.devices_outlined;
    }
    return Icons.sell_outlined;
  }

  String _prettyCategory(String category) => category
      .split('-')
      .map(
        (word) => word.isEmpty
            ? word
            : '${word[0].toUpperCase()}${word.substring(1)}',
      )
      .join(' ');

  @override
  HomeViewModel viewModelBuilder(BuildContext context) => HomeViewModel();
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.white,
      elevation: AppSize.elevationS,
      margin: const EdgeInsets.only(bottom: AppSize.paddingM),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSize.radiusM),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primaryPurple),
        title: Text(label),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: onTap,
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSize.paddingS),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onSelected(),
        selectedColor: AppColors.primaryPurple,
        backgroundColor: AppColors.white,
        labelStyle: TextStyle(
          color: selected ? AppColors.white : AppColors.black,
          fontSize: AppSize.fontS,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ProductContent extends StatelessWidget {
  const _ProductContent({
    required this.products,
    required this.isBusy,
    required this.error,
    required this.onRetry,
    required this.onProductTap,
  });

  final List<Product> products;
  final bool isBusy;
  final String? error;
  final VoidCallback onRetry;
  final ValueChanged<Product> onProductTap;

  @override
  Widget build(BuildContext context) {
    if (isBusy && products.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (error != null && products.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSize.paddingXXL),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(error!, textAlign: TextAlign.center),
              const SizedBox(height: AppSize.spaceL),
              FilledButton(onPressed: onRetry, child: const Text('Try again')),
            ],
          ),
        ),
      );
    }
    if (products.isEmpty) {
      return const Center(child: Text('No products found.'));
    }

    return Stack(
      children: [
        GridView.builder(
          padding: const EdgeInsets.all(AppSize.paddingL),
          itemCount: products.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: AppSize.paddingM,
            mainAxisSpacing: AppSize.paddingM,
            childAspectRatio: 0.68,
          ),
          itemBuilder: (context, index) {
            final product = products[index];
            return _ProductCard(
              product: product,
              onTap: () => onProductTap(product),
            );
          },
        ),
        if (error != null)
          Positioned(
            left: AppSize.paddingL,
            right: AppSize.paddingL,
            top: AppSize.paddingS,
            child: Material(
              color: AppColors.errorBackground,
              borderRadius: BorderRadius.circular(AppSize.radiusS),
              child: Padding(
                padding: const EdgeInsets.all(AppSize.paddingS),
                child: Text(
                  'Refresh failed: $error',
                  style: const TextStyle(color: AppColors.errorText),
                ),
              ),
            ),
          ),
        if (isBusy)
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: LinearProgressIndicator(),
          ),
      ],
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product, required this.onTap});

  final Product product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      color: AppColors.white,
      elevation: AppSize.elevationS,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSize.radiusM),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: Image.network(
                  product.thumbnail,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Center(child: Icon(Icons.image_not_supported)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSize.paddingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 2,
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
                          '\$${product.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: AppColors.primaryPurple,
                            fontSize: AppSize.fontL,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.star_rounded,
                        color: AppColors.accentYellow,
                        size: AppSize.iconS,
                      ),
                      Text(
                        product.rating.toStringAsFixed(1),
                        style: const TextStyle(fontSize: AppSize.fontS),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
