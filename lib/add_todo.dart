import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:todopushnotification/home_screen.dart';
import 'package:todopushnotification/main.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:todopushnotification/models/todo_model.dart';
import 'package:todopushnotification/provider/todo_provider.dart';

class AddTodo extends StatefulWidget {
  const new({super.key});

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  TextEditingController todoController = TextEditingController();
  tz.TZDateTime? scheduledTime;

  final AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
        "notifications-madhav",
        "Madhav's Notification",
        channelDescription: "Todo reminder notifications",
        priority: Priority.max,
        importance: Importance.max,
      );

  final DarwinNotificationDetails darwinNotificationDetails =
      DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

  late NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
    iOS: darwinNotificationDetails,
  );

  Future<tz.TZDateTime?> setDateTime() async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (selectedDate == null) return null;

    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime == null) return null;

    //finally combine date + time
    final DateTime userDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    log("time selected: $userDateTime");

    //convert to timexone dateTime
    scheduledTime = tz.TZDateTime.from(userDateTime, tz.local);

    setState(() {
      scheduledTime;
    });
    return scheduledTime;
  }

  @override
  Widget build(BuildContext context) {
    final t = context.watch<TodoProvider>();
    return Scaffold(
      appBar: AppBar(title: Text("Add Todo")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Card(
            child: Column(
              children: [
                TextField(
                  controller: todoController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(14)),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => setDateTime(),
                      child: Container(
                        width: MediaQuery.sizeOf(context).width / 1.5,
                        height: 60,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 134, 214, 251),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: GestureDetector(
                          child: Center(child: Text("Tap for set time")),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Text(
                            scheduledTime?.hour.toString() ?? "_",
                            style: TextStyle(fontSize: 25),
                          ),
                          Text(":", style: TextStyle(fontSize: 25)),
                          Text(
                            scheduledTime?.minute.toString() ?? "_",
                            style: TextStyle(fontSize: 25),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () async {
                    context.read<TodoProvider>().addTodo(
                      TodoModel(
                        id: (t.td.length + 1).toString(),
                        todoname: todoController.text,
                        time: scheduledTime!,
                      ),
                    );
                    await notificationsPlugin.zonedSchedule(
                      id: 2,
                      title: todoController.text,
                      body: "notification",
                      scheduledDate: scheduledTime!,
                      notificationDetails: notificationDetails,
                      androidScheduleMode:
                          AndroidScheduleMode.exactAllowWhileIdle,
                      payload: "notification-payload",
                    );

                    log("Notification sheduled for $scheduledTime");
                    log("!!! New todo Added !!!");
                  },

                  child: Text("Set"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
