import 'dart:async';

import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
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
           getCategories ??
           GetCategoriesUseCase(locator<ProductRepository>()),
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
  String? productsError;
  String? categoriesError;
  String? accountError;
  bool isLoadingProducts = false;
  bool isSigningOut = false;
  int selectedNavigationIndex = 0;
  Timer? _searchDebounce;
  int _productRequestId = 0;

  Future<void> initialise() async {
    setBusy(true);
    try {
      await Future.wait<void>([
        _getCurrentUser().then<void>(
          (value) => user = value,
          onError: (Object error) => accountError = error.toString(),
        ),
        _getCategories().then<void>(
          (value) => categories = value,
          onError: (Object error) => categoriesError = error.toString(),
        ),
      ]);
      await loadProducts();
    } finally {
      setBusy(false);
      notifyListeners();
    }
  }

  void search(String value) {
    searchQuery = value.trim();
    _searchDebounce?.cancel();
    _searchDebounce = Timer(
      const Duration(milliseconds: 350),
      loadProducts,
    );
    notifyListeners();
  }

  Future<void> selectCategory(String? category) async {
    selectedCategory = category;
    await loadProducts();
  }

  void selectDestination(int index) {
    selectedNavigationIndex = index;
    notifyListeners();
  }

  Future<void> selectCategoryFromCategories(String? category) async {
    selectedCategory = category;
    selectedNavigationIndex = 0;
    notifyListeners();
    await loadProducts();
  }

  Future<void> loadProducts() async {
    final requestId = ++_productRequestId;
    isLoadingProducts = true;
    productsError = null;
    notifyListeners();
    try {
      final results = await _getProducts(
        query: searchQuery,
        category: selectedCategory,
      );
      if (requestId == _productRequestId) {
        products = results;
      }
    } catch (error) {
      if (requestId == _productRequestId) {
        productsError = error.toString();
      }
    } finally {
      if (requestId == _productRequestId) {
        isLoadingProducts = false;
        notifyListeners();
      }
    }
  }

  Future<void> openProduct(Product product) {
    return _navigationService.navigateToProductDetailsView(
      productId: product.id,
    );
  }

  Future<void> signOut() async {
    isSigningOut = true;
    notifyListeners();
    try {
      await _signOut();
      await _navigationService.replaceWith(Routes.loginView);
    } catch (error) {
      setError(error);
    } finally {
      isSigningOut = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    super.dispose();
  }
}
