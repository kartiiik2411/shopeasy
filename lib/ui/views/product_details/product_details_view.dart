import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

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
    return Scaffold(
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
                        widget.onBuyNow?.call();
                        Navigator.of(context).pop();
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
        Container(
          height: 300,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Image.network(
            product.thumbnail,
            fit: BoxFit.contain,
            errorBuilder: (_, _, _) => const Icon(
              Icons.image_not_supported_outlined,
              size: 64,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Text(
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
            ),
            IconButton(
              tooltip: isLiked ? 'Remove from wishlist' : 'Add to wishlist',
              onPressed: onLikeToggle,
              icon: Icon(
                isLiked ? Icons.favorite_rounded : Icons.favorite_border,
                color: isLiked ? AppColors.coral : AppColors.textSecondary,
              ),
            ),
            IconButton(
              tooltip: 'Share product',
              onPressed: onShare,
              icon: const Icon(
                Icons.share_outlined,
                color: AppColors.textSecondary,
              ),
            ),
          ],
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
        if (product.rating > 0) ...[
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.star_rounded, color: AppColors.amber, size: 20),
              const SizedBox(width: 4),
              Text(
                '${product.rating.toStringAsFixed(1)}  ·  ${product.stock} in stock',
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            ],
          ),
        ],
        const SizedBox(height: 12),
        Text(
          '\$${product.price.toStringAsFixed(2)}',
          style: const TextStyle(
            color: AppColors.primaryPurple,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (product.brand?.isNotEmpty == true) ...[
          const SizedBox(height: 10),
          Text(
            'Brand: ${product.brand}',
            style: const TextStyle(color: AppColors.textSecondary),
          ),
        ],
        const SizedBox(height: 20),
        _ProductDescriptionCard(description: product.description),
        const SizedBox(height: 16),
        _DeliveryAddressCard(
          address: deliveryAddress,
          onAddAddress: onAddAddress,
        ),
      ],
    );
  }
}

class _ProductDescriptionCard extends StatelessWidget {
  const _ProductDescriptionCard({required this.description});

  final String description;

  @override
  Widget build(BuildContext context) {
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
            'Product description',
            style: TextStyle(
              color: AppColors.black,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(color: AppColors.textSecondary, height: 1.5),
          ),
        ],
      ),
    );
  }
}

class _DeliveryAddressCard extends StatelessWidget {
  const _DeliveryAddressCard({
    required this.address,
    required this.onAddAddress,
  });

  final DeliveryAddress? address;
  final VoidCallback? onAddAddress;

  @override
  Widget build(BuildContext context) {
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
          const Row(
            children: [
              Icon(Icons.location_on_outlined, color: AppColors.primaryPurple),
              SizedBox(width: 8),
              Text(
                'Delivery address',
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (address == null)
            const Text(
              'No delivery address saved yet.',
              style: TextStyle(color: AppColors.textSecondary),
            )
          else ...[
            Text(
              '${address!.fullName}  ·  ${address!.phone}',
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
          if (onAddAddress != null)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: onAddAddress,
                child: Text(address == null ? 'Add address' : 'Edit address'),
              ),
            ),
        ],
      ),
    );
  }
}
