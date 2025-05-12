// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:todo/utils/notification_services.dart';
//
// class TestScreen extends StatefulWidget {
//   const TestScreen({super.key});
//
//   static TestScreen builder(BuildContext context, GoRouterState state) =>
//       const TestScreen();
//
//   @override
//   State<TestScreen> createState() => _TestScreenState();
// }
//
// class _TestScreenState extends State<TestScreen> {
//   final NotificationService _notificationService = NotificationService();
//   DateTime selectedDate = DateTime.now();
//   TimeOfDay selectedTime = TimeOfDay.now();
//
//   Future<void> _scheduleNotification() async {
//     final DateTime scheduleDateTime = DateTime(
//       selectedDate.year,
//       selectedDate.month,
//       selectedDate.day,
//       selectedTime.hour,
//       selectedTime.minute,
//     );
//
//     if (scheduleDateTime.isBefore(DateTime.now())) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Please select a future date and time'),
//           backgroundColor: Colors.redAccent,
//         ),
//       );
//       return;
//     }
//
//     await _notificationService.scheduleNotification(scheduleDateTime);
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           'Notification scheduled for ${scheduleDateTime.toString()}',
//         ),
//         backgroundColor: Colors.green,
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text('Notification Scheduler'),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Text('Selected date: ${selectedDate.toLocal()}'),
//               Text('Selected time: ${selectedTime.format(context)}'),
//               ElevatedButton(
//                 onPressed: _scheduleNotification,
//                 child: const Text('Schedule Notification'),
//               ),
//               ElevatedButton(
//                 onPressed: _notificationService.showInstantNotification,
//                 child: const Text('Send Instant Notification'),
//               ),
//             ],
//           ),
//         ),
//     );
//   }
// }
