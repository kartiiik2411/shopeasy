// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// StackedNavigatorGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:async' as _i9;

import 'package:flutter/material.dart' as _i6;
import 'package:flutter/material.dart';
import 'package:shopeasy_app/domain/entities/delivery_address.dart' as _i8;
import 'package:shopeasy_app/domain/entities/product.dart' as _i7;
import 'package:shopeasy_app/ui/views/home/home_view.dart' as _i4;
import 'package:shopeasy_app/ui/views/login/login_view.dart' as _i3;
import 'package:shopeasy_app/ui/views/product_details/product_details_view.dart'
    as _i5;
import 'package:shopeasy_app/ui/views/splash/splash_view.dart' as _i2;
import 'package:stacked/stacked.dart' as _i1;
import 'package:stacked_services/stacked_services.dart' as _i10;

class Routes {
  static const splashView = '/';

  static const loginView = '/login-view';

  static const homeView = '/home-view';

  static const productDetailsView = '/product-details-view';

  static const all = <String>{
    splashView,
    loginView,
    homeView,
    productDetailsView,
  };
}

class StackedRouter extends _i1.RouterBase {
  final _routes = <_i1.RouteDef>[
    _i1.RouteDef(Routes.splashView, page: _i2.SplashView),
    _i1.RouteDef(Routes.loginView, page: _i3.LoginView),
    _i1.RouteDef(Routes.homeView, page: _i4.HomeView),
    _i1.RouteDef(Routes.productDetailsView, page: _i5.ProductDetailsView),
  ];

  final _pagesMap = <Type, _i1.StackedRouteFactory>{
    _i2.SplashView: (data) {
      final args = data.getArgs<SplashViewArguments>(
        orElse: () => const SplashViewArguments(),
      );
      return _i6.MaterialPageRoute<dynamic>(
        builder: (context) => _i2.SplashView(key: args.key),
        settings: data,
      );
    },
    _i3.LoginView: (data) {
      final args = data.getArgs<LoginViewArguments>(
        orElse: () => const LoginViewArguments(),
      );
      return _i6.MaterialPageRoute<dynamic>(
        builder: (context) => _i3.LoginView(key: args.key),
        settings: data,
      );
    },
    _i4.HomeView: (data) {
      final args = data.getArgs<HomeViewArguments>(
        orElse: () => const HomeViewArguments(),
      );
      return _i6.MaterialPageRoute<dynamic>(
        builder: (context) => _i4.HomeView(key: args.key),
        settings: data,
      );
    },
    _i5.ProductDetailsView: (data) {
      final args = data.getArgs<ProductDetailsViewArguments>(
        orElse: () => const ProductDetailsViewArguments(),
      );
      return _i6.MaterialPageRoute<dynamic>(
        builder: (context) => _i5.ProductDetailsView(
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
  };

  @override
  List<_i1.RouteDef> get routes => _routes;

  @override
  Map<Type, _i1.StackedRouteFactory> get pagesMap => _pagesMap;
}

class SplashViewArguments {
  const SplashViewArguments({this.key});

  final _i6.Key? key;

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

class LoginViewArguments {
  const LoginViewArguments({this.key});

  final _i6.Key? key;

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

  final _i6.Key? key;

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

  final _i6.Key? key;

  final int? productId;

  final _i7.Product? product;

  final bool isLiked;

  final void Function()? onLikeToggle;

  final _i8.DeliveryAddress? deliveryAddress;

  final _i9.Future<_i8.DeliveryAddress?> Function()? onAddAddress;

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

extension NavigatorStateExtension on _i10.NavigationService {
  Future<dynamic> navigateToSplashView({
    _i6.Key? key,
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

  Future<dynamic> navigateToLoginView({
    _i6.Key? key,
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
    _i6.Key? key,
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
    _i6.Key? key,
    int? productId,
    _i7.Product? product,
    bool isLiked = false,
    void Function()? onLikeToggle,
    _i8.DeliveryAddress? deliveryAddress,
    _i9.Future<_i8.DeliveryAddress?> Function()? onAddAddress,
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

  Future<dynamic> replaceWithSplashView({
    _i6.Key? key,
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

  Future<dynamic> replaceWithLoginView({
    _i6.Key? key,
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
    _i6.Key? key,
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
    _i6.Key? key,
    int? productId,
    _i7.Product? product,
    bool isLiked = false,
    void Function()? onLikeToggle,
    _i8.DeliveryAddress? deliveryAddress,
    _i9.Future<_i8.DeliveryAddress?> Function()? onAddAddress,
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
}
