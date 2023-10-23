import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationManager {
  static Future initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin, Function(NotificationResponse) onNotificationResponse) async {
    var androidInitialize =
        const AndroidInitializationSettings('mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: androidInitialize);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings, onDidReceiveNotificationResponse: (notificationResponse){
      onNotificationResponse(notificationResponse);
    });
  }

  static Future schedule(
      {required String title,
      required String body,
      required DateTime dateTime,
      required FlutterLocalNotificationsPlugin fln}) async {
      AndroidNotificationDetails androidPlatformChannelSpecifics =
          const AndroidNotificationDetails(
        'main',
        'main_channel',
        playSound: true,
        importance: Importance.max,
        priority: Priority.high,
      );
      var not = NotificationDetails(android: androidPlatformChannelSpecifics);
      await fln.zonedSchedule(Random().nextInt((pow(2, 31) - 1) as int), title,
          body, tz.TZDateTime.from(dateTime, tz.local), not,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          payload: '$title;$body;${dateTime.toString()}');
  }
}
