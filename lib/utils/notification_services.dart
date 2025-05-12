import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('icon');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );
  }

  void _onNotificationTap(NotificationResponse response) {
    print('Notification Clicked: ${response.payload}');
  }

  Future<void> requestExactAlarmPermission() async {
    if (await Permission.notification.isGranted) {
      // Check and request for exact alarm permissions if needed
      if (await Permission.notification.isRestricted) {
        openAppSettings();
      }
    } else {
      // Request permission
      await Permission.notification.request();
    }
  }

  Future<void> scheduleNotification(DateTime scheduleDateTime, {required String title, required String body}) async {
    try {
      // Request exact alarm permission for Android 13+
      await requestExactAlarmPermission();

      const AndroidNotificationDetails androidPlatformChannelSpecifies =
      AndroidNotificationDetails(
        'task_channel',
        'Task Reminders',
        channelDescription: 'Reminders for your ToDo tasks',
        importance: Importance.max,
        priority: Priority.high,
        enableVibration: true,
        enableLights: true,
        icon: 'icon',
      );

      const NotificationDetails platformChannelSpecifies =
      NotificationDetails(android: androidPlatformChannelSpecifies);

      await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        title,
        body,
        tz.TZDateTime.from(scheduleDateTime, tz.local),
        platformChannelSpecifies,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: 'scheduled_task',
      );
    } on PlatformException catch (e) {
      print('Error scheduling notification: $e');
      // Optional: You can handle this exception to provide more specific feedback to the user
    }
  }
// to reminder user in the morning
  Future<void> scheduleDailyMorningTaskReminder({
    required String body,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifies =
    AndroidNotificationDetails(
      'daily_morning_channel',
      'Daily Task Summary',
      channelDescription: 'Daily reminder for your tasks',
      importance: Importance.max,
      priority: Priority.high,
      icon: 'icon',
    );

    const NotificationDetails platformChannelSpecifies =
    NotificationDetails(android: androidPlatformChannelSpecifies);

    // Schedule at 8:00 AM local time every day
    final now = tz.TZDateTime.now(tz.local);
    final scheduledTime = tz.TZDateTime(tz.local, now.year, now.month, now.day, 10)
        .add(Duration(days: now.isAfter(tz.TZDateTime(tz.local, now.year, now.month, now.day, 10)) ? 1 : 0));

    await flutterLocalNotificationsPlugin.zonedSchedule(
      1, // Unique ID for this notification
      'Today\'s Tasks',
      body,
      scheduledTime,
      platformChannelSpecifies,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'daily_task_summary',
    );
  }

}

Future<void> requestNotificationPermission() async {
  var status = await Permission.notification.request();

  if (status.isGranted) {
    print('Permission granted!');
  } else if (status.isDenied) {
    print('Permission denied!');
  } else if (status.isPermanentlyDenied) {
    await openAppSettings();
  }
}

