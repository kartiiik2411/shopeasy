import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

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

  static const List<Map<String, Object>> products = [
    {
      'id': 1,
      'title': 'Everyday Headphones',
      'category': 'electronics',
      'price': 49.99,
      'rating': 4.6,
      'image':
          'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=600',
    },
    {
      'id': 2,
      'title': 'Classic Wrist Watch',
      'category': 'jewelery',
      'price': 79.00,
      'rating': 4.4,
      'image':
          'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=600',
    },
    {
      'id': 3,
      'title': 'Casual Everyday Shirt',
      'category': "men's clothing",
      'price': 34.50,
      'rating': 4.7,
      'image':
          'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=600',
    },
    {
      'id': 4,
      'title': 'Minimal Shoulder Bag',
      'category': "women's clothing",
      'price': 59.95,
      'rating': 4.8,
      'image':
          'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=600',
    },
  ];

  static const List<String> categories = [
    'All',
    'electronics',
    'jewelery',
    "men's clothing",
    "women's clothing",
  ];

  AuthUser? user;

  String searchQuery = '';
  String selectedCategory = 'All';
  int selectedNavIndex = 0;

  final Set<int> _wishlist = {};

  List<Map<String, Object>> get visibleProducts {
    return products
        .where((product) {
          final id = product['id']! as int;

          final matchesWishlist =
              selectedNavIndex != 2 || _wishlist.contains(id);

          final matchesCategory =
              selectedCategory == 'All' ||
              product['category'] == selectedCategory;

          final title = product['title']! as String;
          final category = product['category']! as String;

          final query = searchQuery.toLowerCase();

          final matchesSearch =
              title.toLowerCase().contains(query) ||
              category.toLowerCase().contains(query);

          return matchesWishlist && matchesCategory && matchesSearch;
        })
        .toList(growable: false);
  }

  void search(String value) {
    searchQuery = value.trim();
    rebuildUi();
  }

  void selectCategory(String category) {
    selectedCategory = category;
    selectedNavIndex = 0;
    rebuildUi();
  }

  void setNavigationIndex(int index) {
    selectedNavIndex = index;
    rebuildUi();
  }

  bool isWishlisted(int productId) => _wishlist.contains(productId);

  void toggleWishlist(int productId) {
    if (!_wishlist.add(productId)) {
      _wishlist.remove(productId);
    }
    rebuildUi();
  }

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
  }
}
