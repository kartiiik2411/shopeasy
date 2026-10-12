// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// StackedLocatorGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs, implementation_imports, depend_on_referenced_packages

import 'package:stacked_services/src/navigation/navigation_service.dart';
import 'package:stacked_shared/stacked_shared.dart';

import '../core/network/notifications_service.dart';
import '../data/repositories/dummy_json_auth_repository.dart';
import '../data/repositories/dummy_json_product_repository.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/repositories/product_repository.dart';

final locator = StackedLocator.instance;

Future<void> setupLocator({
  String? environment,
  EnvironmentFilter? environmentFilter,
}) async {
  // Register environments
  locator.registerEnvironment(
    environment: environment,
    environmentFilter: environmentFilter,
  );

  // Register dependencies
  locator.registerLazySingleton<AuthRepository>(
    () => DummyJsonAuthRepository(),
  );
  locator.registerLazySingleton<ProductRepository>(
    () => DummyJsonProductRepository(),
  );
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => NotificationService());
}
