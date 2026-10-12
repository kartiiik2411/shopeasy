// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// StackedNavigatorGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:async' as _i11;

import 'package:flutter/material.dart' as _i8;
import 'package:flutter/material.dart';
import 'package:shopeasy_app/domain/entities/delivery_address.dart' as _i10;
import 'package:shopeasy_app/domain/entities/product.dart' as _i9;
import 'package:shopeasy_app/ui/views/checkout/checkout_view.dart' as _i7;
import 'package:shopeasy_app/ui/views/home/home_view.dart' as _i5;
import 'package:shopeasy_app/ui/views/login/login_view.dart' as _i4;
import 'package:shopeasy_app/ui/views/onboarding/onboarding_view.dart' as _i3;
import 'package:shopeasy_app/ui/views/product_details/product_details_view.dart'
    as _i6;
import 'package:shopeasy_app/ui/views/splash/splash_view.dart' as _i2;
import 'package:stacked/stacked.dart' as _i1;
import 'package:stacked_services/stacked_services.dart' as _i12;

class Routes {
  static const splashView = '/';

  static const onboardingView = '/onboarding-view';

  static const loginView = '/login-view';

  static const homeView = '/home-view';

  static const productDetailsView = '/product-details-view';

  static const checkoutView = '/checkout-view';

  static const all = <String>{
    splashView,
    onboardingView,
    loginView,
    homeView,
    productDetailsView,
    checkoutView,
  };
}

class StackedRouter extends _i1.RouterBase {
  final _routes = <_i1.RouteDef>[
    _i1.RouteDef(Routes.splashView, page: _i2.SplashView),
    _i1.RouteDef(Routes.onboardingView, page: _i3.OnboardingView),
    _i1.RouteDef(Routes.loginView, page: _i4.LoginView),
    _i1.RouteDef(Routes.homeView, page: _i5.HomeView),
    _i1.RouteDef(Routes.productDetailsView, page: _i6.ProductDetailsView),
    _i1.RouteDef(Routes.checkoutView, page: _i7.CheckoutView),
  ];

  final _pagesMap = <Type, _i1.StackedRouteFactory>{
    _i2.SplashView: (data) {
      final args = data.getArgs<SplashViewArguments>(
        orElse: () => const SplashViewArguments(),
      );
      return _i8.MaterialPageRoute<dynamic>(
        builder: (context) => _i2.SplashView(key: args.key),
        settings: data,
      );
    },
    _i3.OnboardingView: (data) {
      final args = data.getArgs<OnboardingViewArguments>(
        orElse: () => const OnboardingViewArguments(),
      );
      return _i8.MaterialPageRoute<dynamic>(
        builder: (context) => _i3.OnboardingView(key: args.key),
        settings: data,
      );
    },
    _i4.LoginView: (data) {
      final args = data.getArgs<LoginViewArguments>(
        orElse: () => const LoginViewArguments(),
      );
      return _i8.MaterialPageRoute<dynamic>(
        builder: (context) => _i4.LoginView(key: args.key),
        settings: data,
      );
    },
    _i5.HomeView: (data) {
      final args = data.getArgs<HomeViewArguments>(
        orElse: () => const HomeViewArguments(),
      );
      return _i8.MaterialPageRoute<dynamic>(
        builder: (context) => _i5.HomeView(key: args.key),
        settings: data,
      );
    },
    _i6.ProductDetailsView: (data) {
      final args = data.getArgs<ProductDetailsViewArguments>(
        orElse: () => const ProductDetailsViewArguments(),
      );
      return _i8.MaterialPageRoute<dynamic>(
        builder: (context) => _i6.ProductDetailsView(
          key: args.key,
          productId: args.productId,
          product: args.product,
          isLiked: args.isLiked,
          onLikeToggle: args.onLikeToggle,
          deliveryAddress: args.deliveryAddress,
          onAddAddress: args.onAddAddress,
          onAddToCart: args.onAddToCart,
          onBuyNow: args.onBuyNow,
        ),
        settings: data,
      );
    },
    _i7.CheckoutView: (data) {
      final args = data.getArgs<CheckoutViewArguments>(nullOk: false);
      return _i8.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i7.CheckoutView(key: args.key, product: args.product),
        settings: data,
      );
    },
  };

  @override
  List<_i1.RouteDef> get routes => _routes;

  @override
  Map<Type, _i1.StackedRouteFactory> get pagesMap => _pagesMap;
}

class SplashViewArguments {
  const SplashViewArguments({this.key});

  final _i8.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant SplashViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class OnboardingViewArguments {
  const OnboardingViewArguments({this.key});

  final _i8.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant OnboardingViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class LoginViewArguments {
  const LoginViewArguments({this.key});

  final _i8.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant LoginViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class HomeViewArguments {
  const HomeViewArguments({this.key});

  final _i8.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant HomeViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class ProductDetailsViewArguments {
  const ProductDetailsViewArguments({
    this.key,
    this.productId,
    this.product,
    this.isLiked = false,
    this.onLikeToggle,
    this.deliveryAddress,
    this.onAddAddress,
    this.onAddToCart,
    this.onBuyNow,
  });

  final _i8.Key? key;

  final int? productId;

  final _i9.Product? product;

  final bool isLiked;

  final void Function()? onLikeToggle;

  final _i10.DeliveryAddress? deliveryAddress;

  final _i11.Future<_i10.DeliveryAddress?> Function()? onAddAddress;

  final void Function()? onAddToCart;

  final void Function()? onBuyNow;

  @override
  String toString() {
    return '{"key": "$key", "productId": "$productId", "product": "$product", "isLiked": "$isLiked", "onLikeToggle": "$onLikeToggle", "deliveryAddress": "$deliveryAddress", "onAddAddress": "$onAddAddress", "onAddToCart": "$onAddToCart", "onBuyNow": "$onBuyNow"}';
  }

  @override
  bool operator ==(covariant ProductDetailsViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key &&
        other.productId == productId &&
        other.product == product &&
        other.isLiked == isLiked &&
        other.onLikeToggle == onLikeToggle &&
        other.deliveryAddress == deliveryAddress &&
        other.onAddAddress == onAddAddress &&
        other.onAddToCart == onAddToCart &&
        other.onBuyNow == onBuyNow;
  }

  @override
  int get hashCode {
    return key.hashCode ^
        productId.hashCode ^
        product.hashCode ^
        isLiked.hashCode ^
        onLikeToggle.hashCode ^
        deliveryAddress.hashCode ^
        onAddAddress.hashCode ^
        onAddToCart.hashCode ^
        onBuyNow.hashCode;
  }
}

class CheckoutViewArguments {
  const CheckoutViewArguments({this.key, required this.product});

  final _i8.Key? key;

  final _i9.Product product;

  @override
  String toString() {
    return '{"key": "$key", "product": "$product"}';
  }

  @override
  bool operator ==(covariant CheckoutViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.product == product;
  }

  @override
  int get hashCode {
    return key.hashCode ^ product.hashCode;
  }
}

extension NavigatorStateExtension on _i12.NavigationService {
  Future<dynamic> navigateToSplashView({
    _i8.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.splashView,
      arguments: SplashViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToOnboardingView({
    _i8.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.onboardingView,
      arguments: OnboardingViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToLoginView({
    _i8.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.loginView,
      arguments: LoginViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToHomeView({
    _i8.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.homeView,
      arguments: HomeViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToProductDetailsView({
    _i8.Key? key,
    int? productId,
    _i9.Product? product,
    bool isLiked = false,
    void Function()? onLikeToggle,
    _i10.DeliveryAddress? deliveryAddress,
    _i11.Future<_i10.DeliveryAddress?> Function()? onAddAddress,
    void Function()? onAddToCart,
    void Function()? onBuyNow,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.productDetailsView,
      arguments: ProductDetailsViewArguments(
        key: key,
        productId: productId,
        product: product,
        isLiked: isLiked,
        onLikeToggle: onLikeToggle,
        deliveryAddress: deliveryAddress,
        onAddAddress: onAddAddress,
        onAddToCart: onAddToCart,
        onBuyNow: onBuyNow,
      ),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToCheckoutView({
    _i8.Key? key,
    required _i9.Product product,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.checkoutView,
      arguments: CheckoutViewArguments(key: key, product: product),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithSplashView({
    _i8.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.splashView,
      arguments: SplashViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithOnboardingView({
    _i8.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.onboardingView,
      arguments: OnboardingViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithLoginView({
    _i8.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.loginView,
      arguments: LoginViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithHomeView({
    _i8.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.homeView,
      arguments: HomeViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithProductDetailsView({
    _i8.Key? key,
    int? productId,
    _i9.Product? product,
    bool isLiked = false,
    void Function()? onLikeToggle,
    _i10.DeliveryAddress? deliveryAddress,
    _i11.Future<_i10.DeliveryAddress?> Function()? onAddAddress,
    void Function()? onAddToCart,
    void Function()? onBuyNow,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.productDetailsView,
      arguments: ProductDetailsViewArguments(
        key: key,
        productId: productId,
        product: product,
        isLiked: isLiked,
        onLikeToggle: onLikeToggle,
        deliveryAddress: deliveryAddress,
        onAddAddress: onAddAddress,
        onAddToCart: onAddToCart,
        onBuyNow: onBuyNow,
      ),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithCheckoutView({
    _i8.Key? key,
    required _i9.Product product,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.checkoutView,
      arguments: CheckoutViewArguments(key: key, product: product),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }
}
