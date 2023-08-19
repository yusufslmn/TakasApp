import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:grock/grock.dart';
import 'package:takasapp/services/send_notification.dart';

class FirebaseNotifications {
  late final FirebaseMessaging messaging;
  String? token;

  void settingNotification() async {
    await messaging.requestPermission(
      alert: true,
      sound: true,
      badge: true,
    );
  }

  void connectNotification() async {
    await Firebase.initializeApp();
    messaging = FirebaseMessaging.instance;
    messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      sound: true,
      badge: true,
    );

    settingNotification();

    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("${event.notification?.title}");
      print("${event.notification?.body}");
    });

    messaging
        .getToken()
        .then((value) => log("Token: $value", name: "Fcm Token"));
    await messaging.getToken().then((value) => FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({"token": value}));
  }

  static Future<void> backgroundMessage(RemoteMessage message) async {
    await Firebase.initializeApp();
    print("Handling a background message : ${message.messageId}");
  }
}
