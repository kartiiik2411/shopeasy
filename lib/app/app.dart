import 'package:shopeasy_app/data/repositories/firebase_auth_repository.dart';
import 'package:shopeasy_app/domain/repositories/auth_repository.dart';
import 'package:shopeasy_app/ui/views/home/home_view.dart';
import 'package:shopeasy_app/ui/views/product_list/product_list_view.dart';
import 'package:shopeasy_app/ui/views/login/login_view.dart';
import 'package:shopeasy_app/ui/views/splash/splash_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

@StackedApp(
  routes: [
    MaterialRoute(page: SplashView, initial: true),
    MaterialRoute(page: LoginView),
    MaterialRoute(page: HomeView),
    MaterialRoute(page: ProductListView),
  ],
  dependencies: [
    LazySingleton(classType: FirebaseAuthRepository, asType: AuthRepository),
    LazySingleton(classType: NavigationService),
  ],
)
class App {}
