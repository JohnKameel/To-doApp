import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:todo/app/todo_app.dart';
import 'package:todo/screens/test_screen.dart';
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

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   // Initialize notifications or any async setup here
//   await NotificationService().initialize();
//
//   runApp(
//     ProviderScope(
//       child: MyApp(),
//     ),
//   );
// }
//
// class MyApp extends StatelessWidget {
//   final _router = GoRouter(
//     routes: [
//       GoRoute(
//         path: '/',
//         builder: (context, state) => const TestScreen(),
//       ),
//     ],
//   );
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp.router(
//       title: 'ToDo App',
//       routerConfig: _router,
//       debugShowCheckedModeBanner: false,
//       // 🔥 This automatically includes MaterialLocalizations
//
//
//     );
//   }
// }

