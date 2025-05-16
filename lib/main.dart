import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:todo/app/todo_app.dart';
import 'package:todo/utils/notification_services.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await Permission.notification.request();
  await NotificationService().initialize();
  runApp(
    const ProviderScope(
      child: TodoApp(),
    ),
  );
}
