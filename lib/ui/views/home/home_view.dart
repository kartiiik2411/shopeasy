import 'dart:async';
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
<<<<<<< HEAD

import 'package:stacked/stacked.dart';

import '../../../core/theme/app_color.dart';

import '../../../domain/entities/product.dart';

=======
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';

import '../../../core/theme/app_color.dart';
import '../../../core/theme/app_theme_controller.dart';
import '../../../domain/entities/delivery_address.dart';
import '../../../domain/entities/product.dart';
import '../product_details/product_details_view.dart';
>>>>>>> origin/devsanika
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
<<<<<<< HEAD
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
=======
    final isHome = viewModel.selectedNavigationIndex == 0;
    if (viewModel.shouldPromptForAddress) {
      viewModel.markAddressPromptShown();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) _showDeliveryAddressPrompt(context, viewModel);
      });
    }
    if (viewModel.addressLoadError != null &&
        !viewModel.addressLoadErrorShown) {
      viewModel.addressLoadErrorShown = true;
      final addressLoadError = viewModel.addressLoadError;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted && addressLoadError != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(addressLoadError)));
        }
      });
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(statusBarColor: Colors.transparent)
          .copyWith(
            statusBarIconBrightness: isHome
                ? Brightness.light
                : Brightness.dark,
            statusBarBrightness: isHome ? Brightness.dark : Brightness.light,
          ),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          top: false,
          bottom: false,
          child: Column(
            children: [
              if (isHome)
                _HomeHeader(
                  viewModel: viewModel,
                  topInset: MediaQuery.paddingOf(context).top,
                ),
              Expanded(
                child: isHome
                    ? _buildBody(viewModel)
                    : SafeArea(child: _buildBody(viewModel)),
              ),
            ],
          ),
        ),
        bottomNavigationBar: viewModel.profileSubPage == 0
            ? _BottomNavigation(
                selectedIndex: viewModel.selectedNavigationIndex,
                onSelected: viewModel.selectDestination,
              )
            : null,
>>>>>>> origin/devsanika
      ),
    );
  }

  Widget _buildBody(HomeViewModel viewModel) {
    switch (viewModel.selectedNavigationIndex) {
      case 1:
        return _CategoriesPage(viewModel: viewModel);
<<<<<<< HEAD

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
=======
      case 2:
        return _WishlistPage(viewModel: viewModel);
      case 3:
        return _CartPage(viewModel: viewModel);
      case 4:
        return switch (viewModel.profileSubPage) {
          1 => _EditProfilePage(viewModel: viewModel),
          2 => _SettingsPage(viewModel: viewModel),
          _ => _ProfilePage(viewModel: viewModel),
        };
      default:
        return _HomeContent(viewModel: viewModel);
    }
  }
}

// -----------------------------------------------------------------------------
// Header and search
// -----------------------------------------------------------------------------

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({required this.viewModel, required this.topInset});

  final HomeViewModel viewModel;
  final double topInset;
>>>>>>> origin/devsanika

  @override
  Widget build(BuildContext context) {
    final name = viewModel.user?.displayName?.trim();
<<<<<<< HEAD

=======
>>>>>>> origin/devsanika
    final greetingName = name == null || name.isEmpty
        ? 'ShopEasy Customer'
        : name;

    return Container(
      width: double.infinity,
<<<<<<< HEAD

      padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),

      decoration: const BoxDecoration(
        color: AppColors.primaryPurple,

        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

=======
      padding: EdgeInsets.fromLTRB(20, topInset + 16, 20, 20),
      decoration: const BoxDecoration(
        color: AppColors.primaryPurple,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
>>>>>>> origin/devsanika
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
<<<<<<< HEAD

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

=======
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
>>>>>>> origin/devsanika
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
<<<<<<< HEAD

              const CircleAvatar(
                backgroundColor: Colors.white24,

=======
              const CircleAvatar(
                backgroundColor: Colors.white24,
>>>>>>> origin/devsanika
                child: Icon(Icons.shopping_bag_outlined, color: Colors.white),
              ),
            ],
          ),
<<<<<<< HEAD

          const SizedBox(height: 20),

          TextField(
=======
          const SizedBox(height: 20),
          TextField(
            controller: viewModel.searchController,
>>>>>>> origin/devsanika
            onChanged: viewModel.search,

            textInputAction: TextInputAction.search,

            decoration: InputDecoration(
              hintText: 'Search products...',

              prefixIcon: const Icon(Icons.search_rounded),
<<<<<<< HEAD

              filled: true,

              fillColor: Colors.white,

              contentPadding: const EdgeInsets.symmetric(vertical: 14),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),

=======
              suffixIcon: viewModel.searchController.text.isEmpty
                  ? null
                  : IconButton(
                      tooltip: 'Clear search',
                      onPressed: viewModel.clearSearch,
                      icon: const Icon(Icons.close_rounded),
                    ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
>>>>>>> origin/devsanika
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
<<<<<<< HEAD

// Home content

// -----------------------------------------------------------------------------

=======
// Home content
// -----------------------------------------------------------------------------

>>>>>>> origin/devsanika
class _HomeContent extends StatelessWidget {
  const _HomeContent({required this.viewModel});

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 20),
<<<<<<< HEAD

      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),

          child: Text(
            'Find your favourites',

            style: TextStyle(
              fontSize: 23,

              fontWeight: FontWeight.bold,

=======
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Find your favourites',
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
>>>>>>> origin/devsanika
              color: AppColors.black,
            ),
          ),
        ),
<<<<<<< HEAD

        const SizedBox(height: 18),

        _CategorySection(viewModel: viewModel),

        const SizedBox(height: 24),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),

=======
        const SizedBox(height: 18),
        _CategorySection(viewModel: viewModel),
        const SizedBox(height: 18),
        const _PromoSlider(),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
>>>>>>> origin/devsanika
          child: Text(
            viewModel.selectedCategory == null
                ? 'Trending Products'
                : 'Filtered Products',
<<<<<<< HEAD

            style: const TextStyle(
              fontSize: 21,

              fontWeight: FontWeight.bold,

=======
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
>>>>>>> origin/devsanika
              color: AppColors.black,
            ),
          ),
        ),
<<<<<<< HEAD

        const SizedBox(height: 14),

=======
        const SizedBox(height: 14),
>>>>>>> origin/devsanika
        _ProductSection(viewModel: viewModel),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
<<<<<<< HEAD

// Categories

=======
// Categories
>>>>>>> origin/devsanika
// -----------------------------------------------------------------------------

class _CategorySection extends StatelessWidget {
  const _CategorySection({required this.viewModel});

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
<<<<<<< HEAD

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

=======
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
>>>>>>> origin/devsanika
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
<<<<<<< HEAD

=======
>>>>>>> origin/devsanika
    required this.onTap,
  });

  final String label;

  final bool selected;
<<<<<<< HEAD

=======
>>>>>>> origin/devsanika
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
<<<<<<< HEAD

=======
>>>>>>> origin/devsanika
      child: ChoiceChip(
        label: Text(label),

        selected: selected,
<<<<<<< HEAD

        onSelected: (_) => onTap(),

        selectedColor: AppColors.primaryPurple,

        backgroundColor: Colors.white,

        labelStyle: TextStyle(
          color: selected ? Colors.white : AppColors.black,

          fontWeight: FontWeight.w600,
        ),

=======
        showCheckmark: false,
        onSelected: (_) => onTap(),
        selectedColor: AppColors.primaryPurple,
        backgroundColor: Colors.white,
        labelStyle: TextStyle(
          color: selected ? Colors.white : AppColors.black,
          fontWeight: FontWeight.w600,
        ),
>>>>>>> origin/devsanika
        side: BorderSide.none,
      ),
    );
  }
}

<<<<<<< HEAD
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
=======
class _PromoSlider extends StatefulWidget {
  const _PromoSlider();

  @override
  State<_PromoSlider> createState() => _PromoSliderState();
}

class _PromoSliderState extends State<_PromoSlider> {
  static const _slides = [
    _PromoSlide(
      title: 'Everyday essentials',
      subtitle: 'Little upgrades that make a big difference.',
      imageUrl:
          'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?auto=format&fit=crop&w=1200&q=85',
      tag: 'STYLE YOUR DAY',
    ),
    _PromoSlide(
      title: 'Make room for comfort',
      subtitle: 'Find the pieces that make home feel like yours.',
      imageUrl:
          'https://images.unsplash.com/photo-1616486338812-3dadae4b4ace?auto=format&fit=crop&w=1200&q=85',
      tag: 'HOME PICKS',
    ),
    _PromoSlide(
      title: 'A little tech magic',
      subtitle: 'Smart finds for work, play, and everything between.',
      imageUrl:
          'https://images.unsplash.com/photo-1498049794561-7780e7231661?auto=format&fit=crop&w=1200&q=85',
      tag: 'TECH FINDS',
    ),
    _PromoSlide(
      title: 'Feel-good favourites',
      subtitle: 'Refresh your routine with something new.',
      imageUrl:
          'https://images.unsplash.com/photo-1608248543803-ba4f8c70ae0b?auto=format&fit=crop&w=1200&q=85',
      tag: 'SELF-CARE',
    ),
    _PromoSlide(
      title: 'Find your next favourite',
      subtitle: 'Great discoveries are just a tap away.',
      imageUrl:
          'https://images.unsplash.com/photo-1441986300917-64674bd600d8?auto=format&fit=crop&w=1200&q=85',
      tag: 'SHOP THE EDIT',
    ),
  ];

  final PageController _pageController = PageController(viewportFraction: .91);
  Timer? _timer;
  int _currentPage = 0;
  int _direction = 1;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted || !_pageController.hasClients) return;
      var nextPage = _currentPage + _direction;
      if (nextPage >= _slides.length || nextPage < 0) {
        _direction *= -1;
        nextPage = _currentPage + _direction;
      }
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 650),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 190,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _slides.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) => AnimatedScale(
              scale: index == _currentPage ? 1 : .96,
              duration: const Duration(milliseconds: 450),
              curve: Curves.easeOutCubic,
              child: _PromoBanner(slide: _slides[index]),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _slides.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              width: index == _currentPage ? 22 : 7,
              height: 7,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: index == _currentPage
                    ? AppColors.primaryPurple
                    : AppColors.primaryPurple.withValues(alpha: .2),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
>>>>>>> origin/devsanika
    );
  }
}

<<<<<<< HEAD
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
=======
class _PromoSlide {
  const _PromoSlide({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.tag,
  });

  final String title;
  final String subtitle;
  final String imageUrl;
  final String tag;
}

class _PromoBanner extends StatelessWidget {
  const _PromoBanner({required this.slide});

  final _PromoSlide slide;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              slide.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF8055D9), Color(0xFF382078)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xD96750A4),
                    Color(0x806750A4),
                    Color(0x176750A4),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: .2),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: .32),
                          ),
                        ),
                        child: Text(
                          slide.tag,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            letterSpacing: 1.1,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 9),
                  Text(
                    slide.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(color: Colors.black38, blurRadius: 8)],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    slide.subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      shadows: [Shadow(color: Colors.black38, blurRadius: 8)],
                    ),
>>>>>>> origin/devsanika
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
<<<<<<< HEAD

// Wishlist and cart placeholders

=======
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

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.66,
      ),
      itemCount: viewModel.products.length,
      itemBuilder: (context, index) => _ProductCard(
        product: viewModel.products[index],
        viewModel: viewModel,
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product, required this.viewModel});

  final Product product;
  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      color: AppColors.white,
      elevation: 1,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => _openProductDetails(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    color: const Color(0xFFF7F7FA),
                    padding: const EdgeInsets.all(8),
                    child: Image.network(
                      product.thumbnail,
                      fit: BoxFit.contain,
                      errorBuilder: (_, _, _) => const Center(
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          size: 34,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 5,
                    right: 5,
                    child: Material(
                      color: Colors.white.withValues(alpha: 0.94),
                      shape: const CircleBorder(),
                      child: IconButton(
                        visualDensity: VisualDensity.compact,
                        tooltip: viewModel.isLiked(product)
                            ? 'Remove from wishlist'
                            : 'Add to wishlist',
                        onPressed: () => viewModel.toggleLike(product),
                        icon: Icon(
                          viewModel.isLiked(product)
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          color: viewModel.isLiked(product)
                              ? AppColors.coral
                              : AppColors.textSecondary,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 9, 10, 11),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryPurple,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openProductDetails(BuildContext context) {
    viewModel.recordRecentlyViewed(product);
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ProductDetailsView(
          product: product,
          isLiked: viewModel.isLiked(product),
          onLikeToggle: () => viewModel.toggleLike(product),
          deliveryAddress: viewModel.deliveryAddress,
          onAddAddress: () => _showAddressEditor(context, viewModel),
          onAddToCart: () {
            viewModel.addToCart(product);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Added to your cart.')),
            );
          },
          onBuyNow: () {
            viewModel.addToCart(product);
            viewModel.selectDestination(3);
          },
        ),
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
    final selectedCategory = viewModel.selectedCategory;
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              color: AppColors.white,
              border: Border(right: BorderSide(color: AppColors.border)),
            ),
            child: ListView(
              children: [
                _CategoryRailItem(
                  title: 'All Products',
                  imageUrl: _categoryImageUrl(null),
                  selected: viewModel.selectedCategory == null,
                  onTap: () => viewModel.selectCategory(null),
                ),
                ...viewModel.categories.map(
                  (category) => _CategoryRailItem(
                    title: _formatCategory(category),
                    imageUrl: _categoryImageUrl(category),
                    selected: viewModel.selectedCategory == category,
                    onTap: () => viewModel.selectCategory(category),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 18, 12, 12),
                child: Text(
                  selectedCategory == null
                      ? 'All Products'
                      : _formatCategory(selectedCategory),
                  style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: _CategoryProducts(
                  viewModel: viewModel,
                  products: viewModel.products,
                ),
              ),
            ],
          ),
        ),
      ],
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

class _CategoryRailItem extends StatelessWidget {
  const _CategoryRailItem({
    required this.title,
    required this.imageUrl,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String imageUrl;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.lightPurple : AppColors.white,
      child: InkWell(
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 96),
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: selected ? AppColors.primaryPurple : Colors.transparent,
                width: 4,
              ),
              bottom: const BorderSide(color: AppColors.border),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  imageUrl,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    width: 48,
                    height: 48,
                    color: AppColors.background,
                    child: const Icon(
                      Icons.category_outlined,
                      color: AppColors.primaryPurple,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: selected ? AppColors.primaryPurple : AppColors.black,
                  fontSize: 10,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryProducts extends StatelessWidget {
  const _CategoryProducts({required this.viewModel, required this.products});

  final HomeViewModel viewModel;
  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    if (viewModel.isLoadingProducts && products.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (products.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'No products found in this category.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 10,
        childAspectRatio: 0.58,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return _ProductCard(product: products[index], viewModel: viewModel);
      },
    );
  }
}

class _WishlistPage extends StatelessWidget {
  const _WishlistPage({required this.viewModel});

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final products = viewModel.likedProducts;
    if (products.isEmpty) {
      return const _EmptyPage(
        icon: Icons.favorite_border_rounded,
        title: 'Your Wishlist',
        subtitle: 'Tap the heart on a product to save it here.',
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.66,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) =>
          _ProductCard(product: products[index], viewModel: viewModel),
    );
  }
}

class _CartPage extends StatelessWidget {
  const _CartPage({required this.viewModel});

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final suggestedProducts = viewModel.products.take(10).toList();
    final wishlistProducts = viewModel.likedProducts;
    final cartProducts = viewModel.cartProducts;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 18, 0, 24),
      children: [
        if (cartProducts.isEmpty)
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.shopping_cart_outlined,
                    size: 44,
                    color: AppColors.primaryPurple,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Your cart is empty',
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Find something you love and add it to your cart.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => viewModel.selectDestination(1),
                    child: const Text('Start shopping'),
                  ),
                ],
              ),
            ),
          )
        else ...[
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Text(
              'Your cart (${cartProducts.length})',
              style: const TextStyle(
                color: AppColors.black,
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          ...cartProducts.map(
            (product) => Padding(
              padding: const EdgeInsets.only(right: 16, bottom: 10),
              child: _CartProductTile(
                product: product,
                onRemove: () => viewModel.removeFromCart(product),
              ),
            ),
          ),
        ],
        const SizedBox(height: 24),
        _HorizontalProductSection(
          title: 'Suggested for you',
          products: suggestedProducts,
          emptyMessage: 'Products you might like will appear here.',
          viewModel: viewModel,
        ),
        const SizedBox(height: 24),
        _HorizontalProductSection(
          title: 'Your wishlist',
          products: wishlistProducts,
          emptyMessage: 'Save products with the heart button to see them here.',
          viewModel: viewModel,
        ),
      ],
    );
  }
}

class _HorizontalProductSection extends StatelessWidget {
  const _HorizontalProductSection({
    required this.title,
    required this.products,
    required this.emptyMessage,
    required this.viewModel,
  });

  final String title;
  final List<Product> products;
  final String emptyMessage;
  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Text(
            title,
            style: const TextStyle(
              color: AppColors.black,
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (products.isEmpty)
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Text(
              emptyMessage,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          )
        else
          SizedBox(
            height: 245,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (context, index) => SizedBox(
                width: 160,
                child: _ProductCard(
                  product: products[index],
                  viewModel: viewModel,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _CartProductTile extends StatelessWidget {
  const _CartProductTile({required this.product, required this.onRemove});

  final Product product;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 56,
            height: 56,
            child: Image.network(
              product.thumbnail,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) =>
                  const Icon(Icons.image_not_supported_outlined),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: AppColors.primaryPurple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Remove from cart',
            onPressed: onRemove,
            icon: const Icon(Icons.delete_outline, color: AppColors.coral),
          ),
        ],
      ),
    );
  }
}

String _categoryImageUrl(String? category) {
  const images = <String, String>{
    'all': 'photo-1543168256-418811576931',
    'beauty': 'photo-1596462502278-27bfdc403348',
    'fragrances': 'photo-1594035910387-fea47794261f',
    'furniture': 'photo-1555041469-a586c61ea9bc',
    'groceries': 'photo-1542838132-92c53300491e',
    'home-decoration': 'photo-1600210492486-724fe5c67fb0',
    'kitchen-accessories': 'photo-1556911220-e15b29be8c8f',
    'laptops': 'photo-1496181133206-80ce9b88a853',
    'mens-shirts': 'photo-1598033129183-c4f50c736f10',
    'mens-shoes': 'photo-1542291026-7eec264c27ff',
    'mens-watches': 'photo-1523275335684-37898b6baf30',
    'mobile-accessories': 'photo-1511707171634-5f897ff02aa9',
    'motorcycle': 'photo-1558981806-ec527fa84c39',
    'skin-care': 'photo-1608248543803-ba4f8c70ae0b',
    'smartphones': 'photo-1511707171634-5f897ff02aa9',
    'sports-accessories': 'photo-1461896836934-ffe607ba8211',
    'sunglasses': 'photo-1511499767150-a48a237f0083',
    'tablets': 'photo-1544244015-0df4b3ffc6b0',
    'tops': 'photo-1551232864-3be6b4ff7c75',
    'vehicle': 'photo-1492144534655-ae79c964c9d7',
    'womens-bags': 'photo-1584917865442-de89df76afd3',
    'womens-dresses': 'photo-1595777457583-95e059d581b8',
    'womens-jewellery': 'photo-1515562141207-7a88fb7ce338',
    'womens-shoes': 'photo-1543163521-1fa8ca47b92d',
    'womens-watches': 'photo-1523275335684-37898b6baf30',
  };
  final photoId =
      images[category?.toLowerCase() ?? 'all'] ??
      'photo-1543168256-418811576931';
  return 'https://images.unsplash.com/$photoId?auto=format&fit=crop&w=120&h=120&q=80';
}

// -----------------------------------------------------------------------------
// Profile page
// -----------------------------------------------------------------------------

class _ProfilePage extends StatelessWidget {
  const _ProfilePage({required this.viewModel});

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Hey, ${viewModel.profileName}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.black,
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ActionChip(
              avatar: const Icon(
                Icons.help_outline_rounded,
                size: 18,
                color: AppColors.primaryPurple,
              ),
              label: const Text('Help'),
              onPressed: () => _showProfileInfo(
                context,
                'Help',
                'Contact ShopEasy support for help with your account or orders.',
              ),
              backgroundColor: AppColors.lightPurple,
              side: BorderSide.none,
            ),
          ],
        ),
        const SizedBox(height: 16),
        _ProfileDetailsCard(viewModel: viewModel),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _ProfileQuickAction(
                icon: Icons.receipt_long_outlined,
                label: 'Orders',
                onTap: () => _showProfileInfo(
                  context,
                  'Orders',
                  'Your orders will appear here after you place an order.',
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ProfileQuickAction(
                icon: Icons.favorite_border_rounded,
                label: 'Wishlists',
                onTap: () => viewModel.selectDestination(2),
              ),
            ),
          ],
        ),
        const SizedBox(height: 22),
        _HorizontalProductSection(
          title: 'Recently viewed',
          products: viewModel.recentlyViewedProducts,
          emptyMessage: 'Products you view will appear here.',
          viewModel: viewModel,
        ),
        const SizedBox(height: 22),
        _HorizontalProductSection(
          title: 'Your wishlist',
          products: viewModel.likedProducts,
          emptyMessage: 'Products you save will appear here.',
          viewModel: viewModel,
        ),
        const SizedBox(height: 20),
        const Divider(height: 1),
        const SizedBox(height: 12),
        const _ProfileSectionHeading(title: 'Payment and wallet'),
        _ProfileOptionTile(
          icon: Icons.card_giftcard_outlined,
          title: 'Gift cards',
          onTap: () => _showProfileInfo(
            context,
            'Gift cards',
            'Your gift cards and balances will appear here.',
          ),
        ),
        _ProfileOptionTile(
          icon: Icons.account_balance_wallet_outlined,
          title: 'Saved payment methods',
          onTap: () => _showProfileInfo(
            context,
            'Saved payment methods',
            'No payment methods have been saved yet.',
          ),
        ),
        const SizedBox(height: 8),
        const Divider(height: 1),
        const SizedBox(height: 12),
        const _ProfileSectionHeading(title: 'Settings'),
        _ProfileOptionTile(
          icon: Icons.settings_outlined,
          title: 'App settings',
          onTap: () => viewModel.openProfileSubPage(2),
        ),
        const SizedBox(height: 8),
        const Divider(height: 1),
        const SizedBox(height: 12),
        const _ProfileSectionHeading(title: 'Privacy and security'),
        _ProfileOptionTile(
          icon: Icons.lock_outline_rounded,
          title: 'Privacy and security',
          onTap: () => _showProfileInfo(
            context,
            'Privacy and security',
            'Manage your account security and privacy preferences here.',
          ),
        ),
        const SizedBox(height: 8),
        const Divider(height: 1),
        const SizedBox(height: 12),
        const _ProfileSectionHeading(title: 'Frequently asked questions'),
        const _ProfileFaqTile(
          question: 'How can I track my order?',
          answer:
              'Open Orders from your profile to see updates for your purchases.',
        ),
        const _ProfileFaqTile(
          question: 'How do I change my delivery address?',
          answer:
              'Open a product and use the delivery address card to add or edit your saved address.',
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: viewModel.isSigningOut ? null : viewModel.signOut,
          icon: const Icon(Icons.logout_rounded),
          label: Text(viewModel.isSigningOut ? 'Signing out...' : 'Sign out'),
        ),
      ],
    );
  }
}

class _ProfileDetailsCard extends StatelessWidget {
  const _ProfileDetailsCard({required this.viewModel});

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final address = viewModel.deliveryAddress;
    final photoUrl = viewModel.profilePhotoUrl;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 34,
                    backgroundColor: AppColors.lightPurple,
                    backgroundImage: photoUrl == null || photoUrl.isEmpty
                        ? null
                        : NetworkImage(photoUrl),
                    child: photoUrl == null || photoUrl.isEmpty
                        ? const Icon(
                            Icons.person_rounded,
                            size: 38,
                            color: AppColors.primaryPurple,
                          )
                        : null,
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppColors.primaryPurple,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt_outlined,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      viewModel.profileName,
                      style: const TextStyle(
                        color: AppColors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (viewModel.profileEmail.isNotEmpty) ...[
                      const SizedBox(height: 5),
                      Text(
                        viewModel.profileEmail,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Edit profile',
                onPressed: () => viewModel.openProfileSubPage(1),
                icon: const Icon(
                  Icons.edit_outlined,
                  color: AppColors.primaryPurple,
                ),
              ),
            ],
          ),
          const Divider(height: 28),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.location_on_outlined,
                color: AppColors.primaryPurple,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Delivery address',
                      style: TextStyle(
                        color: AppColors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      address?.formattedAddress ?? 'No address added yet',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () => _showAddressEditor(context, viewModel),
                child: Text(address == null ? 'Add' : 'Edit'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EditProfilePage extends StatefulWidget {
  const _EditProfilePage({required this.viewModel});

  final HomeViewModel viewModel;

  @override
  State<_EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<_EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late final Map<String, TextEditingController> _fields = {
    'name': TextEditingController(text: widget.viewModel.profileName),
    'email': TextEditingController(text: widget.viewModel.profileEmail),
    'photoUrl': TextEditingController(
      text: widget.viewModel.profilePhotoUrl ?? '',
    ),
    'phone': TextEditingController(
      text:
          widget.viewModel.deliveryAddress?.phone ??
          FirebaseAuth.instance.currentUser?.phoneNumber ??
          '',
    ),
    'addressLine1': TextEditingController(
      text: widget.viewModel.deliveryAddress?.addressLine1 ?? '',
    ),
    'addressLine2': TextEditingController(
      text: widget.viewModel.deliveryAddress?.addressLine2 ?? '',
    ),
    'city': TextEditingController(
      text: widget.viewModel.deliveryAddress?.city ?? '',
    ),
    'state': TextEditingController(
      text: widget.viewModel.deliveryAddress?.state ?? '',
    ),
    'postalCode': TextEditingController(
      text: widget.viewModel.deliveryAddress?.postalCode ?? '',
    ),
    'country': TextEditingController(
      text: widget.viewModel.deliveryAddress?.country ?? '',
    ),
  };
  bool _saving = false;

  @override
  void dispose() {
    for (final controller in _fields.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
      children: [
        _SubPageHeader(
          title: 'Edit profile',
          onBack: widget.viewModel.closeProfileSubPage,
        ),
        const SizedBox(height: 16),
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _ProfileSectionHeading(title: 'Personal information'),
              _editField('name', 'Full name', required: true),
              _editField(
                'email',
                'Email address',
                keyboardType: TextInputType.emailAddress,
              ),
              _editField('photoUrl', 'Profile image URL'),
              const SizedBox(height: 18),
              const _ProfileSectionHeading(title: 'Delivery information'),
              _editField(
                'phone',
                'Phone number',
                keyboardType: TextInputType.phone,
              ),
              _editField('addressLine1', 'Address line 1', required: true),
              _editField('addressLine2', 'Address line 2'),
              _editField('city', 'City', required: true),
              _editField('state', 'State / province', required: true),
              _editField('postalCode', 'Postal code', required: true),
              _editField('country', 'Country', required: true),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _saving ? null : _save,
                  icon: _saving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save_outlined),
                  label: Text(_saving ? 'Saving...' : 'Save changes'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _editField(
    String key,
    String label, {
    bool required = false,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: TextFormField(
        controller: _fields[key],
        keyboardType: keyboardType,
        textCapitalization: keyboardType == TextInputType.emailAddress
            ? TextCapitalization.none
            : TextCapitalization.words,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        ),
        validator: required
            ? (value) => value == null || value.trim().isEmpty
                  ? '$label is required'
                  : null
            : null,
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final address = DeliveryAddress(
      fullName: _fields['name']!.text.trim(),
      phone: _fields['phone']!.text.trim(),
      addressLine1: _fields['addressLine1']!.text.trim(),
      addressLine2: _fields['addressLine2']!.text.trim(),
      city: _fields['city']!.text.trim(),
      state: _fields['state']!.text.trim(),
      postalCode: _fields['postalCode']!.text.trim(),
      country: _fields['country']!.text.trim(),
      latitude: widget.viewModel.deliveryAddress?.latitude,
      longitude: widget.viewModel.deliveryAddress?.longitude,
    );
    try {
      await widget.viewModel.updateProfileDetails(
        name: _fields['name']!.text,
        email: _fields['email']!.text,
        photoUrl: _fields['photoUrl']!.text,
      );
      await widget.viewModel.saveDeliveryAddress(address);
      if (!mounted) return;
      widget.viewModel.closeProfileSubPage();
      _showMessage(context, 'Profile and delivery details saved.');
    } catch (error) {
      if (mounted) {
        _showMessage(context, 'Could not save profile changes: $error');
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}

class _SettingsPage extends StatefulWidget {
  const _SettingsPage({required this.viewModel});

  final HomeViewModel viewModel;

  @override
  State<_SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<_SettingsPage> {
  static const _settingDefaults = <String, bool>{
    'push_notifications': true,
    'order_updates': true,
    'promotional_emails': false,
    'location_personalization': false,
    'biometric_lock': false,
  };

  Map<String, bool> _settings = _settingDefaults;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      if (!mounted) return;
      setState(() {
        _settings = {
          for (final entry in _settingDefaults.entries)
            entry.key: preferences.getBool(entry.key) ?? entry.value,
        };
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _loading = false);
      _showMessage(context, 'Could not load saved settings: $error');
    }
  }

  Future<void> _setSetting(String key, bool value) async {
    try {
      final preferences = await SharedPreferences.getInstance();
      await preferences.setBool(key, value);
      if (mounted) setState(() => _settings = {..._settings, key: value});
    } catch (error) {
      if (mounted) _showMessage(context, 'Could not save this setting: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
      children: [
        _SubPageHeader(
          title: 'Settings',
          onBack: widget.viewModel.closeProfileSubPage,
        ),
        const SizedBox(height: 16),
        const _ProfileSectionHeading(title: 'Appearance'),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(
            Icons.palette_outlined,
            color: AppColors.primaryPurple,
          ),
          title: const Text('Theme'),
          subtitle: const Text('Choose light, dark, or follow your device'),
          trailing: ValueListenableBuilder<ThemeMode>(
            valueListenable: AppThemeController.mode,
            builder: (context, mode, _) => DropdownButton<ThemeMode>(
              value: mode,
              underline: const SizedBox.shrink(),
              items: const [
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text('System'),
                ),
                DropdownMenuItem(value: ThemeMode.light, child: Text('Light')),
                DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark')),
              ],
              onChanged: (value) {
                if (value != null) AppThemeController.setMode(value);
              },
            ),
          ),
        ),
        const Divider(),
        const _ProfileSectionHeading(title: 'Notifications'),
        if (_loading)
          const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          )
        else ...[
          _settingSwitch(
            'push_notifications',
            'Push notifications',
            'Allow app notifications on this device',
            Icons.notifications_outlined,
          ),
          _settingSwitch(
            'order_updates',
            'Order updates',
            'Get delivery and order status updates',
            Icons.local_shipping_outlined,
          ),
          _settingSwitch(
            'promotional_emails',
            'Offers and recommendations',
            'Receive shopping offers and product recommendations',
            Icons.local_offer_outlined,
          ),
          const Divider(),
          const _ProfileSectionHeading(title: 'Privacy and security'),
          _settingSwitch(
            'location_personalization',
            'Location personalization',
            'Use your location when you request nearby delivery details',
            Icons.location_on_outlined,
          ),
          _settingSwitch(
            'biometric_lock',
            'App lock preference',
            'Save your preference for biometric app locking',
            Icons.fingerprint,
          ),
        ],
        const Divider(),
        const _ProfileSectionHeading(title: 'Account'),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(
            Icons.logout_rounded,
            color: AppColors.primaryPurple,
          ),
          title: const Text('Log out'),
          onTap: widget.viewModel.isSigningOut
              ? null
              : widget.viewModel.signOut,
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(
            Icons.delete_forever_outlined,
            color: AppColors.coral,
          ),
          title: const Text('Delete account'),
          subtitle: const Text('Permanently delete your Firebase account'),
          onTap: _confirmDeleteAccount,
        ),
      ],
    );
  }

  Widget _settingSwitch(
    String key,
    String title,
    String subtitle,
    IconData icon,
  ) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      secondary: Icon(icon, color: AppColors.primaryPurple),
      title: Text(title),
      subtitle: Text(subtitle),
      value: _settings[key] ?? false,
      onChanged: (value) => _setSetting(key, value),
    );
  }

  Future<void> _confirmDeleteAccount() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete account?'),
        content: const Text(
          'This permanently deletes your Firebase account. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.coral),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete account'),
          ),
        ],
      ),
    );
    if (!mounted || confirmed != true) return;
    try {
      await widget.viewModel.deleteAccount();
    } catch (error) {
      if (mounted) {
        _showMessage(
          context,
          'Could not delete your account. You may need to sign in again: $error',
        );
      }
    }
  }
}

class _SubPageHeader extends StatelessWidget {
  const _SubPageHeader({required this.title, required this.onBack});

  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onBack,
          tooltip: 'Back to profile',
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        const SizedBox(width: 4),
        Text(
          title,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _ProfileQuickAction extends StatelessWidget {
  const _ProfileQuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryPurple,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}

class _ProfileSectionHeading extends StatelessWidget {
  const _ProfileSectionHeading({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 6),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _ProfileOptionTile extends StatelessWidget {
  const _ProfileOptionTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: AppColors.primaryPurple),
      title: Text(title, style: const TextStyle(color: AppColors.black)),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: AppColors.textSecondary,
      ),
      onTap: onTap,
    );
  }
}

class _ProfileFaqTile extends StatelessWidget {
  const _ProfileFaqTile({required this.question, required this.answer});

  final String question;
  final String answer;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      childrenPadding: const EdgeInsets.only(bottom: 12),
      title: Text(
        question,
        style: const TextStyle(
          color: AppColors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            answer,
            style: const TextStyle(color: AppColors.textSecondary, height: 1.4),
          ),
        ),
      ],
    );
  }
}

void _showProfileInfo(BuildContext context, String title, String message) {
  showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}

// -----------------------------------------------------------------------------
// Wishlist and cart placeholders
>>>>>>> origin/devsanika
// -----------------------------------------------------------------------------

class _EmptyPage extends StatelessWidget {
  const _EmptyPage({
    required this.icon,
<<<<<<< HEAD

    required this.title,

=======
    required this.title,
>>>>>>> origin/devsanika
    required this.subtitle,
  });

  final IconData icon;
<<<<<<< HEAD

  final String title;

=======
  final String title;
>>>>>>> origin/devsanika
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
<<<<<<< HEAD

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

=======
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
>>>>>>> origin/devsanika
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
<<<<<<< HEAD

// Bottom navigation

=======
// Bottom navigation
>>>>>>> origin/devsanika
// -----------------------------------------------------------------------------

class _BottomNavigation extends StatelessWidget {
  const _BottomNavigation({
    required this.selectedIndex,
<<<<<<< HEAD

=======
>>>>>>> origin/devsanika
    required this.onSelected,
  });

  final int selectedIndex;
<<<<<<< HEAD

=======
>>>>>>> origin/devsanika
  final ValueChanged<int> onSelected;

  static const _items = [
    (Icons.home_outlined, Icons.home_rounded, 'Home'),
<<<<<<< HEAD

    (Icons.grid_view_outlined, Icons.grid_view_rounded, 'Categories'),

    (Icons.favorite_border_rounded, Icons.favorite_rounded, 'Wishlist'),

    (Icons.shopping_cart_outlined, Icons.shopping_cart_rounded, 'Cart'),

=======
    (Icons.grid_view_outlined, Icons.grid_view_rounded, 'Categories'),
    (Icons.favorite_border_rounded, Icons.favorite_rounded, 'Wishlist'),
    (Icons.shopping_cart_outlined, Icons.shopping_cart_rounded, 'Cart'),
>>>>>>> origin/devsanika
    (Icons.person_outline_rounded, Icons.person_rounded, 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
<<<<<<< HEAD

        border: Border(top: BorderSide(color: AppColors.border)),
      ),

      child: SafeArea(
        top: false,

        child: Row(
          children: List.generate(_items.length, (index) {
            final item = _items[index];

=======
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: List.generate(_items.length, (index) {
            final item = _items[index];
>>>>>>> origin/devsanika
            final selected = selectedIndex == index;

            return Expanded(
              child: InkWell(
                onTap: () => onSelected(index),
<<<<<<< HEAD

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

=======
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
>>>>>>> origin/devsanika
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
<<<<<<< HEAD
=======

enum _AddressPromptChoice { manual, currentLocation, later }

Future<void> _showDeliveryAddressPrompt(
  BuildContext context,
  HomeViewModel viewModel,
) async {
  final choice = await showDialog<_AddressPromptChoice>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Add a delivery address'),
      content: const Text(
        'Save an address for delivery, or use your current location to fill it in.',
      ),
      actions: [
        TextButton(
          onPressed: () =>
              Navigator.pop(dialogContext, _AddressPromptChoice.later),
          child: const Text('Later'),
        ),
        OutlinedButton(
          onPressed: () =>
              Navigator.pop(dialogContext, _AddressPromptChoice.manual),
          child: const Text('Enter address'),
        ),
        FilledButton.icon(
          onPressed: () => Navigator.pop(
            dialogContext,
            _AddressPromptChoice.currentLocation,
          ),
          icon: const Icon(Icons.my_location),
          label: const Text('Use current location'),
        ),
      ],
    ),
  );
  if (!context.mounted ||
      choice == null ||
      choice == _AddressPromptChoice.later) {
    return;
  }

  var initialAddress =
      viewModel.deliveryAddress ??
      DeliveryAddress(
        fullName: FirebaseAuth.instance.currentUser?.displayName ?? '',
        phone: FirebaseAuth.instance.currentUser?.phoneNumber ?? '',
        addressLine1: '',
        city: '',
        state: '',
        postalCode: '',
        country: '',
      );

  if (choice == _AddressPromptChoice.currentLocation) {
    try {
      initialAddress = await viewModel.getCurrentLocationAddress();
    } catch (error) {
      if (!context.mounted) return;
      _showMessage(context, 'Could not get your current location: $error');
    }
  }

  if (context.mounted) {
    await _showAddressEditor(
      context,
      viewModel,
      initialAddress: initialAddress,
    );
  }
}

Future<DeliveryAddress?> _showAddressEditor(
  BuildContext context,
  HomeViewModel viewModel, {
  DeliveryAddress? initialAddress,
}) async {
  final savedAddress = await showDialog<DeliveryAddress>(
    context: context,
    builder: (_) => _DeliveryAddressForm(
      initialAddress:
          initialAddress ??
          viewModel.deliveryAddress ??
          DeliveryAddress(
            fullName: FirebaseAuth.instance.currentUser?.displayName ?? '',
            phone: FirebaseAuth.instance.currentUser?.phoneNumber ?? '',
            addressLine1: '',
            city: '',
            state: '',
            postalCode: '',
            country: '',
          ),
    ),
  );
  if (!context.mounted || savedAddress == null) return null;

  try {
    await viewModel.saveDeliveryAddress(savedAddress);
    if (context.mounted) _showMessage(context, 'Delivery address saved.');
    return savedAddress;
  } catch (error) {
    final message =
        viewModel.addressLoadError ?? 'Could not save your address: $error';
    viewModel.addressLoadErrorShown = true;
    if (context.mounted) {
      _showMessage(context, message);
    }
    return null;
  }
}

void _showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

class _DeliveryAddressForm extends StatefulWidget {
  const _DeliveryAddressForm({required this.initialAddress});

  final DeliveryAddress initialAddress;

  @override
  State<_DeliveryAddressForm> createState() => _DeliveryAddressFormState();
}

class _DeliveryAddressFormState extends State<_DeliveryAddressForm> {
  final _formKey = GlobalKey<FormState>();
  late final Map<String, TextEditingController> _controllers = {
    'fullName': TextEditingController(text: widget.initialAddress.fullName),
    'phone': TextEditingController(text: widget.initialAddress.phone),
    'addressLine1': TextEditingController(
      text: widget.initialAddress.addressLine1,
    ),
    'addressLine2': TextEditingController(
      text: widget.initialAddress.addressLine2,
    ),
    'city': TextEditingController(text: widget.initialAddress.city),
    'state': TextEditingController(text: widget.initialAddress.state),
    'postalCode': TextEditingController(text: widget.initialAddress.postalCode),
    'country': TextEditingController(text: widget.initialAddress.country),
  };

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delivery address'),
      content: SizedBox(
        width: 440,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _field('fullName', 'Full name'),
                _field(
                  'phone',
                  'Phone number',
                  keyboardType: TextInputType.phone,
                ),
                _field('addressLine1', 'Street address'),
                _field('addressLine2', 'Apartment, suite, etc. (optional)'),
                _field('city', 'City'),
                _field('state', 'State / region'),
                _field(
                  'postalCode',
                  'Postal code',
                  keyboardType: TextInputType.number,
                ),
                _field('country', 'Country'),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _save, child: const Text('Save address')),
      ],
    );
  }

  Widget _field(String key, String label, {TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: _controller(key),
        keyboardType: keyboardType,
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: key == 'addressLine2'
            ? null
            : (value) {
                if (value == null || value.trim().isEmpty) {
                  return '$label is required.';
                }
                if (key == 'phone' &&
                    value.replaceAll(RegExp(r'\D'), '').length < 7) {
                  return 'Enter a valid phone number.';
                }
                return null;
              },
      ),
    );
  }

  void _save() {
    final formState = _formKey.currentState;
    if (formState == null || !formState.validate()) return;
    String text(String key) => _controller(key).text.trim();
    Navigator.pop(
      context,
      DeliveryAddress(
        fullName: text('fullName'),
        phone: text('phone'),
        addressLine1: text('addressLine1'),
        addressLine2: text('addressLine2'),
        city: text('city'),
        state: text('state'),
        postalCode: text('postalCode'),
        country: text('country'),
        latitude: widget.initialAddress.latitude,
        longitude: widget.initialAddress.longitude,
      ),
    );
  }

  TextEditingController _controller(String key) {
    final controller = _controllers[key];
    if (controller == null) {
      throw StateError('No delivery address field is configured for "$key".');
    }
    return controller;
  }
}
>>>>>>> origin/devsanika
