import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../core/theme/app_color.dart';
import '../../../core/theme/app_size.dart';
import '../../../domain/entities/product.dart';
import 'product_details_viewmodel.dart';

class ProductDetailsView extends StackedView<ProductDetailsViewModel> {
  const ProductDetailsView({required this.productId, super.key});

  final int productId;

  @override
  void onViewModelReady(ProductDetailsViewModel viewModel) {
    viewModel.loadProduct();
  }

  @override
  Widget builder(
    BuildContext context,
    ProductDetailsViewModel viewModel,
    Widget? child,
  ) {
    final product = viewModel.product;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Product details'),
      ),
      body: viewModel.isBusy && product == null
          ? const Center(child: CircularProgressIndicator())
          : viewModel.hasError && product == null
          ? _LoadError(
              message: viewModel.modelError.toString(),
              onRetry: viewModel.loadProduct,
            )
          : product == null
          ? const Center(child: Text('Product not found.'))
          : _ProductDetails(
              product: product,
              selectedImageIndex: viewModel.selectedImageIndex,
              onImageSelected: viewModel.selectImage,
            ),
    );
  }

  @override
  ProductDetailsViewModel viewModelBuilder(BuildContext context) =>
      ProductDetailsViewModel(productId: productId);
}

class _ProductDetails extends StatelessWidget {
  const _ProductDetails({
    required this.product,
    required this.selectedImageIndex,
    required this.onImageSelected,
  });

  final Product product;
  final int selectedImageIndex;
  final ValueChanged<int> onImageSelected;

  List<String> get _images {
    final images = <String>[product.thumbnail, ...product.images];
    return images.where((url) => url.isNotEmpty).toSet().toList();
  }

  @override
  Widget build(BuildContext context) {
    final images = _images;
    final selectedImage = images.isEmpty
        ? product.thumbnail
        : images[selectedImageIndex.clamp(0, images.length - 1)];
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSize.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSize.radiusL),
            child: AspectRatio(
              aspectRatio: 1,
              child: Image.network(
                selectedImage,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const ColoredBox(
                      color: AppColors.illustrationBackground,
                      child: Center(
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          size: AppSize.iconXXXL,
                        ),
                      ),
                    ),
              ),
            ),
          ),
          if (images.length > 1) ...[
            const SizedBox(height: AppSize.spaceM),
            SizedBox(
              height: AppSize.imageS,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(width: AppSize.spaceS),
                itemBuilder: (context, index) => InkWell(
                  onTap: () => onImageSelected(index),
                  borderRadius: BorderRadius.circular(AppSize.radiusS),
                  child: Container(
                    width: AppSize.imageS,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: selectedImageIndex == index
                            ? AppColors.primaryPurple
                            : AppColors.border,
                        width: selectedImageIndex == index ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(AppSize.radiusS),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.network(
                      images[index],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.image_not_supported_outlined),
                    ),
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: AppSize.spaceXL),
          Text(
            product.title,
            style: const TextStyle(
              color: AppColors.black,
              fontSize: AppSize.fontXXL,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSize.spaceM),
          Row(
            children: [
              Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: AppColors.primaryPurple,
                  fontSize: AppSize.fontTitle,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: AppSize.spaceS),
              if (product.discountPercentage > 0)
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.errorBackground,
                    borderRadius: BorderRadius.circular(AppSize.radiusS),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSize.paddingS,
                      vertical: AppSize.paddingXS,
                    ),
                    child: Text(
                      '${product.discountPercentage.toStringAsFixed(0)}% OFF',
                      style: const TextStyle(
                        color: AppColors.errorText,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSize.spaceM),
          Wrap(
            spacing: AppSize.spaceL,
            runSpacing: AppSize.spaceS,
            children: [
              _ProductFact(
                icon: Icons.star_rounded,
                label: product.rating.toStringAsFixed(1),
                color: AppColors.accentBrown,
              ),
              _ProductFact(
                icon: Icons.inventory_2_outlined,
                label: '${product.stock} in stock',
              ),
              if (product.brand case final brand? when brand.isNotEmpty)
                _ProductFact(icon: Icons.sell_outlined, label: brand),
            ],
          ),
          const SizedBox(height: AppSize.spaceXL),
          Text(
            product.category.toUpperCase(),
            style: const TextStyle(
              color: AppColors.textTertiary,
              fontSize: AppSize.fontS,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: AppSize.spaceS),
          const Text(
            'Description',
            style: TextStyle(
              color: AppColors.black,
              fontSize: AppSize.fontXL,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSize.spaceS),
          Text(
            product.description,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: AppSize.fontM,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductFact extends StatelessWidget {
  const _ProductFact({
    required this.icon,
    required this.label,
    this.color = AppColors.primaryPurple,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: AppSize.iconS),
        const SizedBox(width: AppSize.paddingXS),
        Text(label, style: const TextStyle(color: AppColors.textSecondary)),
      ],
    );
  }
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSize.paddingXXL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: AppSize.spaceL),
            FilledButton(onPressed: onRetry, child: const Text('Try again')),
          ],
        ),
      ),
    );
  }
}
