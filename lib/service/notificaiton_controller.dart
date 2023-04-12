import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

// import 'package:fluttertoast/fluttertoast.dart';
int createUniqueID() {
  Random random = Random();
  return random.nextInt(AwesomeNotifications.maxID);
}

class NotificationController extends ChangeNotifier {
  // SINGLETON PATTERN
  static final NotificationController _instance =
      NotificationController._internal();

  factory NotificationController() {
    return _instance;
  }
  NotificationController._internal();

  static Future<void> initializeLocalNotifications(
      {required bool debug}) async {
    await AwesomeNotifications().initialize(
      null,
      // 'resource://drawable/res_download_icon.png',
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          importance: NotificationImportance.Max,
          enableVibration: true,
          defaultColor: Colors.redAccent,
          channelShowBadge: true,
          enableLights: true,
        ),
      ],
      debug: debug,
    );
  }

// firebase listiner
  static fcmListener() {
    FirebaseMessaging.onMessage.listen((remoteMessage) {
      print("onMessage Recevied : ${remoteMessage.toString()}");
      createNotificationFromJson(remoteMessage);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((remoteMessage) {
      print("onMessageOpendedApp recevied : ${remoteMessage}");
    });
  }

  static createNotificationFromJson(RemoteMessage remoteMessage) async {
    print("data : ${remoteMessage.data}");
    await AwesomeNotifications()
        .createNotificationFromJsonData(remoteMessage.data);
  }

  createLocalNotification(RemoteMessage remoteMessage) async {
    print("data : ${remoteMessage.data}");
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 2,
        channelKey: "basic_channel",
        title: "test Notifcaiton",
        body: "this notification is trigger form onMessage listner",
      ),
    );
  }

  static getFCMToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    print("FCM token : $fcmToken");
  }

  static requrestNotificationPermission() async {
    await AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  static getInitialMessage() async {
    final remoteMessage = await FirebaseMessaging.instance.getInitialMessage();
    print("remote message receviced : ${remoteMessage.toString()}");
  }
}
