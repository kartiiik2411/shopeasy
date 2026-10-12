import 'package:shopeasy_app/data/repositories/dummy_json_auth_repository.dart';
import 'package:shopeasy_app/data/repositories/dummy_json_product_repository.dart';
import 'package:shopeasy_app/domain/repositories/auth_repository.dart';
import 'package:shopeasy_app/domain/repositories/product_repository.dart';
import 'package:shopeasy_app/ui/views/checkout/checkout_view.dart';
import 'package:shopeasy_app/ui/views/home/home_view.dart';
import 'package:shopeasy_app/ui/views/login/login_view.dart';
import 'package:shopeasy_app/ui/views/onboarding/onboarding_view.dart';
import 'package:shopeasy_app/ui/views/product_details/product_details_view.dart';
import 'package:shopeasy_app/ui/views/splash/splash_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

@StackedApp(
  routes: [
    MaterialRoute(page: SplashView, initial: true),
    MaterialRoute(page: OnboardingView),
    MaterialRoute(page: LoginView),
    MaterialRoute(page: HomeView),
    // MaterialRoute(page: WishlistView),
    MaterialRoute(page: ProductDetailsView),
    MaterialRoute(page: CheckoutView),
  ],
  dependencies: [
    LazySingleton(classType: DummyJsonAuthRepository, asType: AuthRepository),
    LazySingleton(
      classType: DummyJsonProductRepository,
      asType: ProductRepository,
    ),
    LazySingleton(classType: NavigationService),
  ],
)
class App {}
