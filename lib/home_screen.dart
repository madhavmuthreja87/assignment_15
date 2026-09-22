import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:todopushnotification/main.dart';

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

    await notificationsPlugin.show(
      id: 0,
      title: "madhav's notify",
      body: "This is notify",
      notificationDetails: notificationDetails,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FloatingActionButton(
        onPressed: () {
          showNotification();
        },
        child: Icon(Icons.notification_add),
      ),
    );
  }
}
