import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:stacked_services/stacked_services.dart';

import 'app/app.locator.dart';
import 'app/app.router.dart';
import 'core/theme/app_theme_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

<<<<<<< HEAD
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyCM6u9-h53wKDWM-EH9UGYUQm_kcVzRdCw',
      appId: '1:967783066207:android:f60bde0c3a0403e8cc49ea',
      messagingSenderId: '967783066207',
      projectId: 'shopeasy-56ef9',
      storageBucket: 'shopeasy-56ef9.firebasestorage.app',
    ),
  );
=======
  await Firebase.initializeApp();
  await AppThemeController.load();
>>>>>>> origin/devsanika

  await setupLocator();

  runApp(const ShopEasyApp());
}

class ShopEasyApp extends StatelessWidget {
  const ShopEasyApp({super.key});

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return MaterialApp(
      title: 'ShopEasy',
      debugShowCheckedModeBanner: false,
      navigatorKey: StackedService.navigatorKey,
      onGenerateRoute: StackedRouter().onGenerateRoute,
      initialRoute: Routes.splashView,
=======
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppThemeController.mode,
      builder: (context, themeMode, _) => MaterialApp(
        title: 'ShopEasy',
        debugShowCheckedModeBanner: false,
        navigatorKey: StackedService.navigatorKey,
        onGenerateRoute: StackedRouter().onGenerateRoute,
        initialRoute: Routes.loginView,
        themeMode: themeMode,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4)),
          scaffoldBackgroundColor: const Color(0xFFF8F7FC),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF9A82DB),
            brightness: Brightness.dark,
          ),
          scaffoldBackgroundColor: const Color(0xFF17141E),
          useMaterial3: true,
        ),
        scrollBehavior: const MaterialScrollBehavior().copyWith(
          physics: const ClampingScrollPhysics(),
        ),
      ),
>>>>>>> origin/devsanika
    );
  }
}
