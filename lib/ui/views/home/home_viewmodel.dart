import 'package:stacked_services/stacked_services.dart';
import 'package:stacked/stacked.dart';

<<<<<<< HEAD
import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../domain/entities/auth_user.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../domain/use_cases/get_current_user_use_case.dart';
import '../../../domain/use_cases/sign_out_use_case.dart';

class HomeViewModel extends BaseViewModel {
  HomeViewModel({
    GetCurrentUserUseCase? getCurrentUser,
    SignOutUseCase? signOut,
    NavigationService? navigationService,
  }) : _getCurrentUser =
           getCurrentUser ?? GetCurrentUserUseCase(locator<AuthRepository>()),
       _signOut = signOut ?? SignOutUseCase(locator<AuthRepository>()),
       _navigationService = navigationService ?? locator<NavigationService>();

  final GetCurrentUserUseCase _getCurrentUser;
  final SignOutUseCase _signOut;
  final NavigationService _navigationService;

  AuthUser? user;

  Future<void> loadUser() async {
    setBusy(true);
    try {
      user = await _getCurrentUser();
    } catch (error) {
      setError(error);
    } finally {
      setBusy(false);
    }
  }

  Future<void> signOut() async {
    setBusy(true);
    try {
      await _signOut();
      await _navigationService.replaceWith(Routes.loginView);
    } catch (error) {
      setError(error);
    } finally {
      setBusy(false);
    }
=======
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
      'title': 'Wireless Headphones',
      'category': 'Electronics',
      'price': 59.99,
      'rating': 4.8,
      'image':
          'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500',
    },
    {
      'id': 2,
      'title': 'Classic Sneakers',
      'category': 'Fashion',
      'price': 74.99,
      'rating': 4.6,
      'image':
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500',
    },
    {
      'id': 3,
      'title': 'Smart Watch',
      'category': 'Electronics',
      'price': 99.99,
      'rating': 4.7,
      'image':
          'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500',
    },
    {
      'id': 4,
      'title': 'Everyday Backpack',
      'category': 'Fashion',
      'price': 44.99,
      'rating': 4.5,
      'image':
          'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=500',
    },
    {
      'id': 5,
      'title': 'Skincare Essentials',
      'category': 'Beauty',
      'price': 29.99,
      'rating': 4.4,
      'image':
          'https://images.unsplash.com/photo-1608248543803-ba4f8c70ae0b?w=500',
    },
    {
      'id': 6,
      'title': 'Minimal Table Lamp',
      'category': 'Home',
      'price': 39.99,
      'rating': 4.3,
      'image':
          'https://images.unsplash.com/photo-1507473885765-e6ed057f782c?w=500',
    },
    {
      'id': 7,
      'title': 'Sport Training Shoes',
      'category': 'Sports',
      'price': 64.99,
      'rating': 4.6,
      'image':
          'https://images.unsplash.com/photo-1460353581641-37baddab0fa2?w=500',
    },
    {
      'id': 8,
      'title': 'Travel Sunglasses',
      'category': 'Fashion',
      'price': 24.99,
      'rating': 4.2,
      'image':
          'https://images.unsplash.com/photo-1511499767150-a48a237f0083?w=500',
    },
  ];

  List<Map<String, dynamic>> get visibleProducts {
    Iterable<Map<String, dynamic>> result = products;

    if (selectedCategory != 'All') {
      result = result.where(
        (product) => product['category'] == selectedCategory,
      );
    }

    if (searchQuery.trim().isNotEmpty) {
      final query = searchQuery.trim().toLowerCase();
      result = result.where(
        (product) =>
            (product['title'] as String).toLowerCase().contains(query) ||
            (product['category'] as String).toLowerCase().contains(query),
      );
    }

    if (selectedNavIndex == 2) {
      result = result.where(
        (product) => _wishlistIds.contains(product['id'] as int),
      );
    }

    return result.toList();
  }

  bool isWishlisted(int id) => _wishlistIds.contains(id);

  void search(String query) {
    searchQuery = query;
    rebuildUi();
  }

  void selectCategory(String category) {
    selectedCategory = category;
    selectedNavIndex = 0;
    rebuildUi();
  }

  void toggleWishlist(int productId) {
    if (!_wishlistIds.add(productId)) {
      _wishlistIds.remove(productId);
    }
    rebuildUi();
  }

  void setNavigationIndex(int index) {
    selectedNavIndex = index;
    rebuildUi();
>>>>>>> origin/devkartik
  }
}
