import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:stacked_services/stacked_services.dart';

import 'app/app.locator.dart';
import 'app/app.router.dart';
import 'core/network/notifications_service.dart';
import 'core/theme/app_theme_controller.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  debugPrint('Background FCM message: ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await AppThemeController.load();
  await setupLocator();

  runApp(const ShopEasyApp());

  // Initialize notifications after the first frame.
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    try {
      await locator<NotificationService>().initialize();
    } catch (error, stackTrace) {
      debugPrint('Notification initialization failed: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  });
}

class ShopEasyApp extends StatelessWidget {
  const ShopEasyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppThemeController.mode,
      builder: (context, themeMode, _) => MaterialApp(
        title: 'ShopEasy',
        debugShowCheckedModeBanner: false,
        navigatorKey: StackedService.navigatorKey,
        onGenerateRoute: StackedRouter().onGenerateRoute,
        initialRoute: Routes.splashView,
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
    );
  }
}
