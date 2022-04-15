import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:task_reminder/model/task.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class NotifyHelper {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project

  initiliazeNotificication() async {
    tz.initializeTimeZones();

    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            onDidReceiveLocalNotification: onDidReceiveLocalNotification,
            requestSoundPermission: false,
            requestAlertPermission: false,
            requestBadgePermission: false);

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  void requestIOSPermissons() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          /* The ?. operator is used as the result will be null when run on other platforms.
           Developers may alternatively choose to guard this call by checking the platform their application 
          is running on.*/
          alert: true,
          badge: true,
          sound: true,
        );
  }

  //displayNotification is good working in IOS/Android with plainned title, body and default sound
  displayNotification({required String title, required String body}) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
    );

    var iosPlatformChannelSpecifics = const IOSNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iosPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      title, //plain title
      body, //plain body
      platformChannelSpecifics,
      payload: 'Default_sound', //item x
    );
  }

  scheduledNotification(
    int hour,
    int minutes, {
    required title,
    required body,
  }) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        title,
        body,
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'your channel id',
            'your channel name',
            channelDescription: 'your channel description',
          ),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  Future selectNotification(String? payload) async {
    if (payload != null) {
      print("notification payload: $payload");
    } else {
      print("Notificiation Done");
    }
    Get.to(() => Container(
          child: Center(
            child: Text("You clicked the notification"),
          ),
        ));
  }
}

Future onDidReceiveLocalNotification(
    int id, String? title, String? body, String? payload) async {
  Get.dialog(Text("Welcome to Flutter"));
}
