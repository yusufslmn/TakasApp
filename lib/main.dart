import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:takasapp/pages/login/login_screen.dart';
import 'package:takasapp/pages/home_view/referance.dart';
import 'package:takasapp/services/firebase_notification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(
      FirebaseNotifications.backgroundMessage);
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final user = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Takas App",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      home: user.currentUser == null ? const LoginPage() : const Referance(),
    );
  }
}
