import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shopeasy_app/app/app.router.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../core/theme/app_color.dart';
import '../../../domain/entities/delivery_address.dart';
import '../../../domain/entities/product.dart';
import '../../../domain/repositories/product_repository.dart';
import '../../../domain/use_cases/get_product_use_case.dart';

class ProductDetailsView extends StatefulWidget {
  const ProductDetailsView({
    super.key,
    this.productId,
    this.product,
    this.isLiked = false,
    this.onLikeToggle,
    this.deliveryAddress,
    this.onAddAddress,
    this.onAddToCart,
    this.onBuyNow,
  });

  final int? productId;
  final Product? product;
  final bool isLiked;
  final VoidCallback? onLikeToggle;
  final DeliveryAddress? deliveryAddress;
  final Future<DeliveryAddress?> Function()? onAddAddress;
  final VoidCallback? onAddToCart;
  final VoidCallback? onBuyNow;

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  Product? _loadedProduct;
  Object? _loadError;
  bool _isLoading = false;
  late bool _isLiked = widget.isLiked;
  late DeliveryAddress? _deliveryAddress = widget.deliveryAddress;

  @override
  void initState() {
    super.initState();
    if (widget.product == null && widget.productId != null) {
      _isLoading = true;
      _loadProduct();
    }
  }

  Future<void> _loadProduct() async {
    try {
      _loadedProduct = await GetProductUseCase(locator<ProductRepository>())(
        widget.productId!,
      );
    } catch (error) {
      _loadError = error;
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product ?? _loadedProduct;

    debugPrint('--- Product Details Debug ---');
    debugPrint('Received product: ${widget.product?.title}');
    debugPrint('Received product ID: ${widget.productId}');
    debugPrint('Loaded product: ${_loadedProduct?.title}');
    debugPrint('Is loading: $_isLoading');
    debugPrint('Load error: $_loadError');

    return Scaffold(
      // Keep the rest of your existing code unchanged.
      backgroundColor: AppColors.background,
      body: product == null
          ? Center(
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : Text(
                      _loadError == null
                          ? 'Product details are unavailable.'
                          : 'Could not load product details: $_loadError',
                      textAlign: TextAlign.center,
                    ),
            )
          : Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryPurple,
                    AppColors.lightPurple,
                    AppColors.background,
                  ],
                  stops: [0, 0.28, 0.65],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: SafeArea(
                child: _ProductDetailsContent(
                  product: product,
                  isLiked: _isLiked,
                  deliveryAddress: _deliveryAddress,
                  onLikeToggle: _toggleLike,
                  onShare: _shareProduct,
                  onAddAddress: _editAddress,
                ),
              ),
            ),
      bottomNavigationBar: product == null
          ? null
          : SafeArea(
              minimum: const EdgeInsets.fromLTRB(16, 10, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: widget.onAddToCart,
                      icon: const Icon(Icons.add_shopping_cart),
                      label: const Text('Add to cart'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        locator<NavigationService>().navigateToCheckoutView(
                          product: product,
                        );
                      },
                      child: const Text('Buy now'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void _toggleLike() {
    setState(() => _isLiked = !_isLiked);
    widget.onLikeToggle?.call();
  }

  Future<void> _editAddress() async {
    final updatedAddress = await widget.onAddAddress?.call();
    if (!mounted || updatedAddress == null) return;
    setState(() => _deliveryAddress = updatedAddress);
  }

  Future<void> _shareProduct() async {
    final product = widget.product ?? _loadedProduct;
    if (product == null) return;

    try {
      await SharePlus.instance.share(
        ShareParams(
          subject: product.title,
          sharePositionOrigin: Rect.fromLTWH(
            0,
            0,
            MediaQuery.sizeOf(context).width,
            MediaQuery.sizeOf(context).height,
          ),
          text:
              '${product.title}\n'
              '\$${product.price.toStringAsFixed(2)}\n'
              '${product.description}',
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not share this product: $error')),
      );
    }
  }
}

class _ProductDetailsContent extends StatelessWidget {
  const _ProductDetailsContent({
    required this.product,
    required this.isLiked,
    required this.deliveryAddress,
    required this.onLikeToggle,
    required this.onShare,
    required this.onAddAddress,
  });

  final Product product;
  final bool isLiked;
  final DeliveryAddress? deliveryAddress;
  final VoidCallback onLikeToggle;
  final VoidCallback onShare;
  final VoidCallback? onAddAddress;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: Text(
            'Product Details',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // Larger product image with rating pill.
        Container(
          height: 360,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.network(
                  product.thumbnail,
                  fit: BoxFit.contain,
                  errorBuilder: (_, _, _) => const Center(
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      size: 64,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: AppColors.amber,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${product.rating.toStringAsFixed(1)}  |  44',
                        style: const TextStyle(
                          color: AppColors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Column(
                  children: [
                    _ImageActionButton(
                      icon: isLiked
                          ? Icons.favorite_rounded
                          : Icons.favorite_border,
                      color: isLiked
                          ? AppColors.coral
                          : AppColors.textSecondary,
                      tooltip: isLiked
                          ? 'Remove from wishlist'
                          : 'Add to wishlist',
                      onPressed: onLikeToggle,
                    ),
                    const SizedBox(height: 8),
                    _ImageActionButton(
                      icon: Icons.share_outlined,
                      color: AppColors.textSecondary,
                      tooltip: 'Share product',
                      onPressed: onShare,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        Text(
          product.category
              .split('-')
              .map(
                (word) => word.isEmpty
                    ? word
                    : '${word[0].toUpperCase()}${word.substring(1)}',
              )
              .join(' '),
          style: const TextStyle(
            color: AppColors.primaryPurple,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),

        Text(
          product.title,
          style: const TextStyle(
            color: AppColors.black,
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10),

        Row(
          children: [
            Text(
              '\$${product.discountedPrice.toStringAsFixed(2)}',
              style: const TextStyle(
                color: AppColors.primaryPurple,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (product.discountPercentage > 0) ...[
              const SizedBox(width: 8),
              Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${product.discountPercentage.toStringAsFixed(0)}% off',
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),

        const SizedBox(height: 8),

        Row(
          children: [
            const Icon(
              Icons.inventory_2_outlined,
              size: 18,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              product.stock > 0
                  ? '${product.stock} items in stock'
                  : 'Out of stock',
              style: TextStyle(
                color: product.stock > 0
                    ? AppColors.textSecondary
                    : AppColors.coral,
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        _DeliveryAddressCard(
          address: deliveryAddress,
          brand: product.brand,
          onAddAddress: onAddAddress,
        ),

        const SizedBox(height: 14),

        const _ProductAssuranceRow(),

        const SizedBox(height: 20),

        _ProductInfoSection(product: product),
      ],
    );
  }
}

class _ImageActionButton extends StatelessWidget {
  const _ImageActionButton({
    required this.icon,
    required this.color,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final Color color;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      shape: const CircleBorder(),
      child: IconButton(
        tooltip: tooltip,
        onPressed: onPressed,
        icon: Icon(icon, color: color),
      ),
    );
  }
}

class _ProductAssuranceRow extends StatelessWidget {
  const _ProductAssuranceRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Expanded(
          child: _AssuranceItem(
            icon: Icons.assignment_return_outlined,
            label: '10-day return',
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: _AssuranceItem(
            icon: Icons.payments_outlined,
            label: 'Cash on delivery',
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: _AssuranceItem(
            icon: Icons.verified_user_outlined,
            label: 'ShopEasy assured',
          ),
        ),
      ],
    );
  }
}

class _ProductInfoSection extends StatefulWidget {
  const _ProductInfoSection({required this.product});

  final Product product;

  @override
  State<_ProductInfoSection> createState() => _ProductInfoSectionState();
}

class _ProductInfoSectionState extends State<_ProductInfoSection> {
  int _selectedTab = 1;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    const tabs = ['Specifications', 'Description', 'Manufacturer info'];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Product details',
            style: TextStyle(
              color: AppColors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          Row(
            children: List.generate(tabs.length, (index) {
              final selected = _selectedTab == index;

              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedTab = index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 3,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.primaryPurple.withValues(alpha: 0.08)
                          : Colors.transparent,
                      border: Border(
                        bottom: BorderSide(
                          color: selected
                              ? AppColors.primaryPurple
                              : AppColors.border,
                          width: selected ? 2 : 1,
                        ),
                      ),
                    ),
                    child: Text(
                      tabs[index],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: selected
                            ? AppColors.primaryPurple
                            : AppColors.textSecondary,
                        fontSize: 10,
                        fontWeight: selected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),

          const SizedBox(height: 16),

          if (_selectedTab == 0) ...[
            _DetailRow(label: 'Product name', value: product.title),
            _DetailRow(label: 'Brand', value: product.brand ?? 'Not provided'),
            _DetailRow(label: 'Category', value: product.category),
            _DetailRow(
              label: 'Price',
              value: '\$${product.discountedPrice.toStringAsFixed(2)}',
            ),
            _DetailRow(
              label: 'Discount',
              value: '${product.discountPercentage.toStringAsFixed(0)}%',
            ),
            _DetailRow(
              label: 'Availability',
              value: product.stock > 0 ? 'In stock' : 'Out of stock',
            ),
          ] else if (_selectedTab == 1) ...[
            Text(
              product.description.trim().isEmpty
                  ? 'No product description is available.'
                  : product.description,
              style: const TextStyle(
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ),
          ] else ...[
            _DetailRow(
              label: 'Brand / seller',
              value: product.brand?.trim().isNotEmpty == true
                  ? product.brand!
                  : 'Not provided',
            ),
            const _DetailRow(
              label: 'Manufacturer',
              value: 'Information not provided',
            ),
            const _DetailRow(
              label: 'Country of origin',
              value: 'Information not provided',
            ),
          ],
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.black,
                height: 1.4,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AssuranceItem extends StatelessWidget {
  const _AssuranceItem({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.primaryPurple, size: 22),
          const SizedBox(height: 7),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.black,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _DeliveryAddressCard extends StatelessWidget {
  const _DeliveryAddressCard({
    required this.address,
    required this.brand,
    required this.onAddAddress,
  });

  final DeliveryAddress? address;
  final String? brand;
  final VoidCallback? onAddAddress;

  @override
  Widget build(BuildContext context) {
    final seller = brand?.trim().isNotEmpty == true
        ? brand!.trim()
        : 'Seller information unavailable';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                color: AppColors.primaryPurple,
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Delivery details',
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (onAddAddress != null)
                TextButton(
                  onPressed: onAddAddress,
                  child: Text(address == null ? 'Add' : 'Change'),
                ),
            ],
          ),

          const SizedBox(height: 8),

          if (address == null)
            const Text(
              'Add your address to check delivery availability.',
              style: TextStyle(color: AppColors.textSecondary, height: 1.4),
            )
          else ...[
            Text(
              '${address!.fullName} · ${address!.phone}',
              style: const TextStyle(
                color: AppColors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              address!.formattedAddress,
              style: const TextStyle(
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ],

          const Divider(height: 28),

          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.local_shipping_outlined,
                color: AppColors.primaryPurple,
                size: 21,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Estimated delivery',
                      style: TextStyle(
                        color: AppColors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Delivery date will be confirmed at checkout.',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.storefront_outlined,
                color: AppColors.primaryPurple,
                size: 21,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Sold by',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      seller,
                      style: const TextStyle(
                        color: AppColors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
