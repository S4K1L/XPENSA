// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class NotificationService {
//   static Future<void> init() async {
//     await AwesomeNotifications().initialize(
//       null, // icon resource (null = default app icon)
//       [
//         NotificationChannel(
//           channelKey: 'task_channel',
//           channelName: 'Task Reminders',
//           channelDescription: 'Reminder notifications',
//           defaultColor: const Color(0xFF0054FB),
//           importance: NotificationImportance.High,
//           ledColor: Colors.white,
//           playSound: true,
//           soundSource: null,
//           // Or leave null to use system default
//         )
//       ],
//       debug: true,
//     );
//   }
//
//   static Future<void> scheduleNotification({
//     required int id,
//     required String title,
//     required String body,
//     required DateTime scheduledDate,
//   }) async {
//     await AwesomeNotifications().createNotification(
//       content: NotificationContent(
//         id: id,
//         channelKey: 'task_channel',
//         title: title,
//         body: body,
//         notificationLayout: NotificationLayout.Default,
//       ),
//       schedule: NotificationCalendar.fromDate(date: scheduledDate, preciseAlarm: true),
//     );
//   }
// }
