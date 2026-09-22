import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:todopushnotification/firebase_api.dart';
import 'package:todopushnotification/firebase_options.dart';
import 'package:todopushnotification/home_screen.dart';

FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();
void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // await FirebaseApi().initNotification();

  await notificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.requestNotificationsPermission();
  AndroidInitializationSettings androidInitializationSettings =
      AndroidInitializationSettings("!mipmap/ic_launcher");

  DarwinInitializationSettings iOSinitializationSettings =
      DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestCriticalPermission: true,
        requestSoundPermission: true,
      );

  InitializationSettings initializationSettings = InitializationSettings();

  bool? initialized = await notificationsPlugin.initialize(
    settings: initializationSettings,
  );

  log("Notification: $initialized");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomeScreen());
  }
}
