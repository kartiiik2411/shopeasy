import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../domain/entities/auth_user.dart';
import '../../../domain/entities/product.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../domain/repositories/product_repository.dart';
import '../../../domain/use_cases/get_categories_use_case.dart';
import '../../../domain/use_cases/get_current_user_use_case.dart';
import '../../../domain/use_cases/get_products_use_case.dart';
import '../../../domain/use_cases/sign_out_use_case.dart';

class HomeViewModel extends BaseViewModel {
  HomeViewModel({
    GetCurrentUserUseCase? getCurrentUser,
    SignOutUseCase? signOut,
    GetCategoriesUseCase? getCategories,
    GetProductsUseCase? getProducts,
    NavigationService? navigationService,
  }) : _getCurrentUser =
           getCurrentUser ?? GetCurrentUserUseCase(locator<AuthRepository>()),
       _signOut = signOut ?? SignOutUseCase(locator<AuthRepository>()),
       _getCategories =
           getCategories ?? GetCategoriesUseCase(locator<ProductRepository>()),
       _getProducts =
           getProducts ?? GetProductsUseCase(locator<ProductRepository>()),
       _navigationService = navigationService ?? locator<NavigationService>();

  final GetCurrentUserUseCase _getCurrentUser;
  final SignOutUseCase _signOut;
  final GetCategoriesUseCase _getCategories;
  final GetProductsUseCase _getProducts;
  final NavigationService _navigationService;

  AuthUser? user;

  List<Product> products = [];
  List<String> categories = [];

  String searchQuery = '';
  String? selectedCategory;

  bool isLoadingProducts = false;
  bool isSigningOut = false;

  int selectedNavigationIndex = 0;

  Future<void> initialise() async {
    setBusy(true);

    try {
      user = await _getCurrentUser();
      categories = await _getCategories();
      await loadProducts();
    } finally {
      setBusy(false);
    }
  }

  void search(String value) {
    searchQuery = value.trim();
    loadProducts();
  }

  Future<void> selectCategory(String? category) async {
    selectedCategory = category;
    await loadProducts();
  }

  Future<void> selectCategoryFromCategories(String? category) async {
    selectedCategory = category;
    selectedNavigationIndex = 0;
    notifyListeners();

    await loadProducts();
  }

  void selectDestination(int index) {
    if (index < 0 || index > 4) return;

    selectedNavigationIndex = index;
    notifyListeners();
  }

  Future<void> loadProducts() async {
    isLoadingProducts = true;
    notifyListeners();

    try {
      products = await _getProducts(
        query: searchQuery,
        category: selectedCategory,
      );
    } finally {
      isLoadingProducts = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    if (isSigningOut) return;

    isSigningOut = true;
    notifyListeners();

    try {
      await _signOut();
      await _navigationService.replaceWith('/login');
    } finally {
      isSigningOut = false;
      notifyListeners();
    }
  }
}
