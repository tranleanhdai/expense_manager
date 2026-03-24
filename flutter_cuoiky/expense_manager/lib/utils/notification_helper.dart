import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHelper {
  static final FlutterLocalNotificationsPlugin _notifications =
  FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');

    const settings = InitializationSettings(
      android: android,
    );

    await _notifications.initialize(settings);
  }

  static Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'budget_channel',
      'Budget Alerts',
      importance: Importance.max,
      priority: Priority.high,
    );

    const generalNotificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _notifications.show(
      0,
      title,
      body,
      generalNotificationDetails,
    );
  }
}
