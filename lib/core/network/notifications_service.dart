import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  NotificationService();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'shopeasy_notifications',
    'ShopEasy Notifications',
    description: 'ShopEasy order updates and notifications',
    importance: Importance.high,
  );

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    // Ask the user for notification permission.
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    debugPrint('Notification permission: ${settings.authorizationStatus}');

    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );

    await _localNotifications.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (response) {
        debugPrint('Local notification tapped: ${response.payload}');
        // Handle navigation here when your target route is ready.
      },
    );

    // Create the Android notification channel.
    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_channel);

    // Allow iOS to display FCM notifications in the foreground.
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Get the FCM token for this device.
    final token = await _messaging.getToken();
    debugPrint('ShopEasy FCM token: $token');

    // Listen for token changes.
    _messaging.onTokenRefresh.listen((newToken) {
      debugPrint('ShopEasy refreshed FCM token: $newToken');
      // Update your backend or Firestore token record here.
    });

    // Handle FCM messages while the app is open.
    FirebaseMessaging.onMessage.listen(_showForegroundNotification);

    // Handle notification taps when the app is in the background.
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    // Handle a notification tap that launches the app.
    final initialMessage = await _messaging.getInitialMessage();

    if (initialMessage != null) {
      _handleNotificationTap(initialMessage);
    }

    _initialized = true;
  }

  Future<void> _showForegroundNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    // iOS foreground banners are handled by FCM presentation settings.
    // Use local notifications here for Android to avoid duplicate banners.
    if (defaultTargetPlatform != TargetPlatform.android) return;

    await _localNotifications.show(
      id: message.hashCode,
      title: notification.title ?? 'ShopEasy',
      body: notification.body ?? '',
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
      payload: message.data.toString(),
    );
  }

  /// Displays a local notification for testing.
  Future<void> showTestNotification() async {
    if (!_initialized) {
      throw StateError(
        'NotificationService must be initialized before testing.',
      );
    }

    await _localNotifications.show(
      id: 1001,
      title: 'ShopEasy Test',
      body: 'Your notifications are working!',
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'shopeasy_notifications',
          'ShopEasy Notifications',
          channelDescription: 'ShopEasy order updates and notifications',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(),
      ),
      payload: 'test',
    );
  }

  void _handleNotificationTap(RemoteMessage message) {
    debugPrint('FCM notification tapped: ${message.data}');

    // Example:
    // final orderId = message.data['orderId'];
    // Navigate to the order details screen using your Stacked router.
  }
}
