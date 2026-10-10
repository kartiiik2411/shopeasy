import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:stacked_services/stacked_services.dart';

import 'app/app.locator.dart';
import 'app/app.router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyCM6u9-h53wKDWM-EH9UGYUQm_kcVzRdCw',
      appId: '1:967783066207:android:f60bde0c3a0403e8cc49ea',
      messagingSenderId: '967783066207',
      projectId: 'shopeasy-56ef9',
      storageBucket: 'shopeasy-56ef9.firebasestorage.app',
    ),
  );

  await setupLocator();

  runApp(const ShopEasyApp());
}

class ShopEasyApp extends StatelessWidget {
  const ShopEasyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShopEasy',
      debugShowCheckedModeBanner: false,
      navigatorKey: StackedService.navigatorKey,
      onGenerateRoute: StackedRouter().onGenerateRoute,
      initialRoute: Routes.splashView,
    );
  }
}
