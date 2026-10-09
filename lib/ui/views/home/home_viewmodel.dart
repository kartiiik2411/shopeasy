import 'package:stacked/stacked.dart';

class HomeViewModel extends BaseViewModel {
  String searchQuery = '';
  String selectedCategory = 'All';
  int selectedNavIndex = 0;

  final Set<int> _wishlistIds = {};

  final List<String> categories = [
    'All',
    'Electronics',
    'Fashion',
    'Beauty',
    'Home',
    'Sports',
  ];

  final List<Map<String, dynamic>> products = [
    {
      'id': 1,
      'name': 'Wireless Headphones',
      'category': 'Electronics',
      'price': 1499.0,
      'rating': 4.8,
      'image':
          'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=600',
    },
    {
      'id': 2,
      'name': 'Classic Sneakers',
      'category': 'Fashion',
      'price': 2199.0,
      'rating': 4.6,
      'image':
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=600',
    },
    {
      'id': 3,
      'name': 'Smart Watch',
      'category': 'Electronics',
      'price': 1899.0,
      'rating': 4.7,
      'image':
          'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=600',
    },
    {
      'id': 4,
      'name': 'Travel Backpack',
      'category': 'Fashion',
      'price': 999.0,
      'rating': 4.5,
      'image':
          'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=600',
    },
    {
      'id': 5,
      'name': 'Skin Care Set',
      'category': 'Beauty',
      'price': 799.0,
      'rating': 4.4,
      'image':
          'https://images.unsplash.com/photo-1608248543803-ba4f8c70ae0b?w=600',
    },
    {
      'id': 6,
      'name': 'Table Lamp',
      'category': 'Home',
      'price': 1299.0,
      'rating': 4.5,
      'image':
          'https://images.unsplash.com/photo-1507473885765-e6ed057f782c?w=600',
    },
  ];

  List<Map<String, dynamic>> get visibleProducts {
    return products.where((product) {
      final matchesCategory =
          selectedCategory == 'All' || product['category'] == selectedCategory;

      final matchesSearch = product['name'].toString().toLowerCase().contains(
        searchQuery.toLowerCase(),
      );

      final matchesWishlist =
          selectedNavIndex != 2 || _wishlistIds.contains(product['id'] as int);

      return matchesCategory && matchesSearch && matchesWishlist;
    }).toList();
  }

  bool isWishlisted(int id) => _wishlistIds.contains(id);

  void search(String value) {
    searchQuery = value;
    rebuildUi();
  }

  void selectCategory(String category) {
    selectedCategory = category;
    selectedNavIndex = 0;
    rebuildUi();
  }

  void toggleWishlist(int id) {
    if (!_wishlistIds.add(id)) {
      _wishlistIds.remove(id);
    }
    rebuildUi();
  }

  void setNavigationIndex(int index) {
    selectedNavIndex = index;
    rebuildUi();
  }
}
