import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:todopushnotification/main.dart';
import 'package:timezone/timezone.dart' as tz;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void showNotification() async {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          "notifications-madhav",
          "Madhav's Notification",
          channelDescription: "Todo reminder notifications",
          priority: Priority.max,
          importance: Importance.max,
        );

    DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    //FOR INSTANT NOTIFICATION
    // await notificationsPlugin.show(
    //   id: 0,
    //   title: "madhav's notify",
    //   body: "This is notify",
    //   notificationDetails: notificationDetails,
    // );

    //FOR SCHEDULING NOTIFICATION

    final scheduledTime = tz.TZDateTime.now(tz.local)
        .add(const Duration(minutes: 1));
    log("Scheduled notification timing: $scheduledTime");
    await notificationsPlugin.zonedSchedule(
      id: 2,
      title: "madhav's notify",
      body: "notification",
      scheduledDate: scheduledTime,
      notificationDetails: notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
    log("notification scheduled successfully");

    final pending = await notificationsPlugin.pendingNotificationRequests();
    log("Pending notifications: ${pending.length.toString()}");

    for (final notification in pending) {
      log("Notification id: ${notification.id.toString()}");
      log("pending title: ${notification.title.toString()}");
      log("pending body: ${notification.body.toString()}");
    }
    // }
    // Future<void> testInstantNotification() async {
    //   const AndroidNotificationDetails androidDetails =
    //       AndroidNotificationDetails(
    //         'test_channel',
    //         'Test Notifications',
    //         channelDescription: 'Testing local notifications',
    //         importance: Importance.max,
    //         priority: Priority.max,
    //       );

    //   const NotificationDetails details = NotificationDetails(
    //     android: androidDetails,
    //   );

    //   await notificationsPlugin.show(
    //     id: 100,
    //     title: 'TEST NOTIFICATION',
    //     body: 'If you can see this, local notifications are working.',
    //     notificationDetails: details,
    //   );

    //   log('Instant notification sent');
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("ToDo App")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showNotification();
          // testInstantNotification();
        },
        child: Icon(Icons.notification_add),
      ),
    );
  }
}
