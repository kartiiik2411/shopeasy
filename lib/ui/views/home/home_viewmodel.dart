import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../domain/entities/auth_user.dart';
import '../../../domain/entities/delivery_address.dart';
import '../../../domain/entities/product.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../domain/repositories/product_repository.dart';
import '../../../domain/use_cases/get_categories_use_case.dart';
import '../../../domain/use_cases/get_current_user_use_case.dart';
import '../../../domain/use_cases/get_products_use_case.dart';
import '../../../domain/use_cases/sign_out_use_case.dart';
import '../../../data/repositories/firestore_address_repository.dart';

class HomeViewModel extends BaseViewModel {
  HomeViewModel({
    GetCurrentUserUseCase? getCurrentUser,
    SignOutUseCase? signOut,
    GetCategoriesUseCase? getCategories,
    GetProductsUseCase? getProducts,
    NavigationService? navigationService,
    FirestoreAddressRepository? addressRepository,
    FirebaseAuth? auth,
  }) : _getCurrentUser =
           getCurrentUser ?? GetCurrentUserUseCase(locator<AuthRepository>()),
       _signOut = signOut ?? SignOutUseCase(locator<AuthRepository>()),
       _getCategories =
           getCategories ?? GetCategoriesUseCase(locator<ProductRepository>()),
       _getProducts =
           getProducts ?? GetProductsUseCase(locator<ProductRepository>()),
       _navigationService = navigationService ?? locator<NavigationService>(),
       _addressRepository = addressRepository ?? FirestoreAddressRepository(),
       _auth = auth ?? FirebaseAuth.instance;

  final GetCurrentUserUseCase _getCurrentUser;
  final SignOutUseCase _signOut;
  final GetCategoriesUseCase _getCategories;
  final GetProductsUseCase _getProducts;
  final NavigationService _navigationService;
  final FirestoreAddressRepository _addressRepository;
  final FirebaseAuth _auth;

  AuthUser? user;

  List<Product> products = [];
  List<String> categories = [];
  final Map<int, Product> _likedProducts = {};
  final Map<int, Product> _cartProducts = {};
  final Map<int, Product> _recentlyViewedProducts = {};

  final searchController = TextEditingController();
  String searchQuery = '';
  String? selectedCategory;
  DeliveryAddress? deliveryAddress;
  String? addressLoadError;
  bool addressCheckComplete = false;
  bool addressPromptShown = false;
  bool addressLoadErrorShown = false;
  bool isSavingAddress = false;

  bool isLoadingProducts = false;
  bool isSigningOut = false;

  int selectedNavigationIndex = 0;
  int profileSubPage = 0;
  List<Product> get likedProducts => _likedProducts.values.toList();
  List<Product> get cartProducts => _cartProducts.values.toList();
  List<Product> get recentlyViewedProducts =>
      _recentlyViewedProducts.values.toList().reversed.toList();
  String get profileName =>
      _auth.currentUser?.displayName ??
      user?.displayName ??
      'ShopEasy Customer';
  String get profileEmail => _auth.currentUser?.email ?? user?.email ?? '';
  String? get profilePhotoUrl => _auth.currentUser?.photoURL ?? user?.photoUrl;
  bool get shouldPromptForAddress =>
      addressCheckComplete &&
      addressLoadError == null &&
      deliveryAddress == null &&
      !addressPromptShown;

  bool isLiked(Product product) => _likedProducts.containsKey(product.id);

  void toggleLike(Product product) {
    if (_likedProducts.containsKey(product.id)) {
      _likedProducts.remove(product.id);
    } else {
      _likedProducts[product.id] = product;
    }
    notifyListeners();
  }

  void addToCart(Product product) {
    _cartProducts[product.id] = product;
    notifyListeners();
  }

  void removeFromCart(Product product) {
    _cartProducts.remove(product.id);
    notifyListeners();
  }

  void recordRecentlyViewed(Product product) {
    _recentlyViewedProducts.remove(product.id);
    _recentlyViewedProducts[product.id] = product;
    while (_recentlyViewedProducts.length > 20) {
      _recentlyViewedProducts.remove(_recentlyViewedProducts.keys.first);
    }
    notifyListeners();
  }

  Future<void> updateProfileName(String name) async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser == null) {
      throw StateError('Sign in before updating your profile.');
    }

    await firebaseUser.updateDisplayName(name);
    await firebaseUser.reload();
    user = AuthUser(
      id: firebaseUser.uid,
      email: firebaseUser.email ?? profileEmail,
      displayName: name,
      photoUrl: firebaseUser.photoURL ?? profilePhotoUrl,
    );
    notifyListeners();
  }

  Future<void> updateProfileDetails({
    required String name,
    required String photoUrl,
    required String email,
  }) async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser == null) {
      throw StateError('Sign in before updating your profile.');
    }

    final updatedEmail = email.trim();
    if (updatedEmail.isNotEmpty &&
        updatedEmail.toLowerCase() != (firebaseUser.email ?? '').toLowerCase()) {
      await firebaseUser.verifyBeforeUpdateEmail(updatedEmail);
    }
    await firebaseUser.updateDisplayName(name.trim());
    await firebaseUser.updatePhotoURL(
      photoUrl.trim().isEmpty ? null : photoUrl.trim(),
    );
    await firebaseUser.reload();
    user = AuthUser(
      id: firebaseUser.uid,
      email: firebaseUser.email ?? updatedEmail,
      displayName: name.trim(),
      photoUrl: photoUrl.trim().isEmpty ? null : photoUrl.trim(),
    );
    notifyListeners();
  }

  void openProfileSubPage(int page) {
    profileSubPage = page;
    notifyListeners();
  }

  void closeProfileSubPage() {
    profileSubPage = 0;
    notifyListeners();
  }

  void markAddressPromptShown() {
    addressPromptShown = true;
  }

  Future<void> initialise() async {
    setBusy(true);

    try {
      user = await _getCurrentUser();
      await _loadDeliveryAddress();
      categories = await _getCategories();
      await loadProducts();
    } finally {
      setBusy(false);
    }
  }

  Future<void> _loadDeliveryAddress() async {
    try {
      deliveryAddress = await _addressRepository.getDefaultAddress();
      addressLoadError = null;
    } on FirebaseException catch (error) {
      addressLoadError = _addressFirebaseError(error, action: 'load');
    } on PlatformException catch (error) {
      addressLoadError = _addressChannelError(error, action: 'load');
    } catch (error) {
      addressLoadError = 'Could not load your saved address: $error';
    } finally {
      addressCheckComplete = true;
      notifyListeners();
    }
  }

  Future<void> saveDeliveryAddress(DeliveryAddress address) async {
    isSavingAddress = true;
    notifyListeners();
    try {
      await _addressRepository.saveDefaultAddress(address);
      deliveryAddress = address;
      addressLoadError = null;
    } on FirebaseException catch (error) {
      addressLoadError = _addressFirebaseError(error, action: 'save');
      rethrow;
    } on PlatformException catch (error) {
      addressLoadError = _addressChannelError(error, action: 'save');
      rethrow;
    } finally {
      isSavingAddress = false;
      notifyListeners();
    }
  }

  String _addressFirebaseError(
    FirebaseException error, {
    required String action,
  }) {
    if (error.code == 'channel-error') {
      return 'Firebase could not connect to its native channel while trying '
          'to $action your address. Fully stop and rebuild the app after '
          'checking Firebase platform configuration.';
    }
    if (error.code == 'permission-denied') {
      return 'Address $action was blocked by Firestore security rules. '
          'Deploy firestore.rules and try again. Address data is stored in '
          'the addresses collection under your signed-in user ID.';
    }
    if (error.code == 'unavailable' || error.code == 'network-request-failed') {
      return 'Address $action failed because Firestore is unreachable. '
          'Check your connection and try again.';
    }
    if (error.code == 'failed-precondition') {
      return 'Address $action could not complete. Check that Cloud Firestore '
          'is enabled for this Firebase project.';
    }
    return 'Could not $action your address in Firestore '
        '(${error.code}): ${error.message ?? 'unknown Firebase error'}';
  }

  String _addressChannelError(
    PlatformException error, {
    required String action,
  }) {
    return 'Firebase could not connect to its native channel while trying '
        'to $action your address (${error.code}). Fully stop and rebuild the '
        'app, then verify Firebase platform configuration.';
  }

  Future<DeliveryAddress> getCurrentLocationAddress() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw StateError('Turn on location services and try again.');
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      throw StateError('Location permission was denied.');
    }
    if (permission == LocationPermission.deniedForever) {
      throw StateError(
        'Location permission is disabled. Allow it in device settings.',
      );
    }

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
    final placemarks = await Geocoding().placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    final place = placemarks.isEmpty ? null : placemarks.first;
    final user = _auth.currentUser;

    return DeliveryAddress(
      fullName: user?.displayName ?? '',
      phone: user?.phoneNumber ?? '',
      addressLine1: [
        place?.subThoroughfare,
        place?.thoroughfare,
      ].whereType<String>().where((part) => part.isNotEmpty).join(' '),
      addressLine2: place?.subLocality ?? '',
      city: place?.locality ?? place?.subAdministrativeArea ?? '',
      state: place?.administrativeArea ?? '',
      postalCode: place?.postalCode ?? '',
      country: place?.country ?? '',
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }

  void search(String value) {
    searchQuery = value.trim();
    loadProducts();
  }

  void clearSearch() {
    searchController.clear();
    search('');
  }

  Future<void> selectCategory(String? category) async {
    selectedCategory = category;
    await loadProducts();
  }

  void selectDestination(int index) {
    if (index < 0 || index > 4) return;

    selectedNavigationIndex = index;
    profileSubPage = 0;
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
      await _auth.signOut();
      await _signOut();
      await _navigationService.replaceWith(Routes.loginView);
    } finally {
      isSigningOut = false;
      notifyListeners();
    }
  }

  Future<void> deleteAccount() async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser == null) {
      throw StateError('No signed-in Firebase account is available to delete.');
    }

    await _addressRepository.deleteDefaultAddress();
    await firebaseUser.delete();
    await _signOut();
    await _navigationService.replaceWith(Routes.loginView);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
