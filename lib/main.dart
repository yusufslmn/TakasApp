import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:takasapp/pages/login_screen.dart';
import 'package:takasapp/pages/referance.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final user = FirebaseAuth.instance;
  // This widget is the root of your application.
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
