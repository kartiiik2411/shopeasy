import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String notificationsEnabledKey = 'push_notifications';

const String notificationChannelId = 'shopeasy_notifications';
const String notificationChannelName = 'ShopEasy Notifications';

/// Handles Firebase messages when the app is in the background.
///
/// Register this handler in main.dart before runApp().
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  debugPrint('Background notification received: ${message.messageId}');
}

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    notificationChannelId,
    notificationChannelName,
    description: 'ShopEasy shopping updates and test notifications.',
    importance: Importance.high,
  );

  /// Initializes local notifications and foreground message listeners.
  Future<void> initialize() async {
    if (_initialized) return;

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const initializationSettings = InitializationSettings(
      android: androidSettings,
    );

    await _localNotifications.initialize(settings: initializationSettings);

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_channel);

    // Request Android 13+ notification permission when the user
    // enables notifications, rather than automatically at startup.

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      try {
        final preferences = await SharedPreferences.getInstance();

        final enabled = preferences.getBool(notificationsEnabledKey) ?? false;

        if (!enabled) return;

        final notification = message.notification;

        if (notification == null) return;

        await showLocalNotification(
          id: message.hashCode,
          title: notification.title ?? 'ShopEasy',
          body: notification.body ?? 'You have a new update.',
          payload: jsonEncode(message.data),
        );
      } catch (error) {
        debugPrint('Could not display foreground notification: $error');
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('Notification tapped: ${message.data}');

      // Add navigation here when notification destinations
      // are implemented.
    });

    final initialMessage = await _messaging.getInitialMessage();

    if (initialMessage != null) {
      debugPrint('App opened from notification: ${initialMessage.data}');
    }

    _initialized = true;
  }

  /// Requests permission and enables the saved notification setting.
  Future<bool> enableNotifications() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    final allowed =
        settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;

    final preferences = await SharedPreferences.getInstance();

    await preferences.setBool(notificationsEnabledKey, allowed);

    if (!allowed) return false;

    await _messaging.setAutoInitEnabled(true);

    try {
      final token = await _messaging.getToken();

      // Use this token for Firebase Console testing.
      // Never publish device tokens publicly.
      debugPrint('ShopEasy FCM token: $token');
    } catch (error) {
      debugPrint('Could not retrieve FCM token: $error');
    }

    // Subscribe only after notification permission is granted.
    await _messaging.subscribeToTopic('shopeasy_updates');

    return true;
  }

  /// Disables the saved preference and unsubscribes from the topic.
  Future<void> disableNotifications() async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.setBool(notificationsEnabledKey, false);

    await _messaging.unsubscribeFromTopic('shopeasy_updates');
  }

  /// Displays a local notification on the device.

  Future<void> showLocalNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'shopeasy_notifications',
      'ShopEasy Notifications',
      channelDescription: 'Shopping updates and test notifications.',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await _localNotifications.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: notificationDetails,
      payload: payload,
    );
  }

  /// Sends a local test notification.
  Future<void> sendTestNotification() async {
    final preferences = await SharedPreferences.getInstance();

    final enabled = preferences.getBool(notificationsEnabledKey) ?? false;

    if (!enabled) {
      throw Exception('Turn on Push notifications first.');
    }

    await showLocalNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: 'ShopEasy Test Notification',
      body: 'Great! Your notification setting is enabled.',
      payload: jsonEncode({'type': 'test'}),
    );
  }

  /// Re-subscribes when notifications are enabled.
  Future<void> subscribeToUpdates() async {
    final preferences = await SharedPreferences.getInstance();

    final enabled = preferences.getBool(notificationsEnabledKey) ?? false;

    if (enabled) {
      await _messaging.subscribeToTopic('shopeasy_updates');
    }
  }
}
