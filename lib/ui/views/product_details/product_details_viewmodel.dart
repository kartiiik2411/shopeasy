import 'package:stacked/stacked.dart';

class ProductDetailsViewModel extends BaseViewModel {
  // Sample product data
  final String productName = 'Essence Mascara Lash Princess';
  final String category = 'Beauty';
  final String imageUrl =
      'https://cdn.dummyjson.com/product-images/beauty/essence-mascara-lash-princess/1.webp';

  final String description =
      'A high-quality mascara designed to provide volume '
      'and length for beautiful, defined lashes.';

  final String rating = '4.5';
  final String price = '8.94';
  final String originalPrice = '9.99';
  final String discount = '10';

  final bool inStock = true;

  int quantity = 1;
  bool isWishlisted = false;

  void increaseQuantity() {
    quantity++;
    notifyListeners();
  }

  void decreaseQuantity() {
    if (quantity > 1) {
      quantity--;
      notifyListeners();
    }
  }

  void toggleWishlist() {
    isWishlisted = !isWishlisted;
    notifyListeners();
  }

  void addToCart() {
    // Connect your shared cart service here.
  }

  void buyNow() {
    // Connect your checkout flow here.
  }
}
