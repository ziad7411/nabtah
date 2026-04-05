import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nabtah/core/notification_worker.dart';
import 'package:workmanager/workmanager.dart';

class NotificationService {

  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future init() async {

    const android = AndroidInitializationSettings('@drawable/ic_notification');

    const settings = InitializationSettings(
      android: android,
    );

    await _notifications.initialize(settings);

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'plant_channel',
      'Plant Care Reminder',
      description: 'Reminders for watering plants',
      importance: Importance.max,
    );

    final androidPlugin =
        _notifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.createNotificationChannel(channel);
  }

  static Future requestPermission() async {

    final androidPlugin =
        _notifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.requestNotificationsPermission();
  }

  static Future showNotification() async {

    await _notifications.show(
      100,
      "💧 وقت ري النباتات",
      "🌱 نباتاتك تحتاج ماء الآن",
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'plant_channel',
          'Plant Care Reminder',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@drawable/ic_notification',
        ),
      ),
    );
  }

  static Future startWeeklyReminder() async {
    await Workmanager().cancelAll();
  await Workmanager().registerPeriodicTask(
    "water_reminder_task",
    waterReminderTask,
    frequency: const Duration(minutes: 15),
  );

}

static Future stopReminder() async {
  await Workmanager().cancelByUniqueName("water_reminder_task");
}
}