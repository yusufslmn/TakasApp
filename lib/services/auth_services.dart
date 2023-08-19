import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../pages/home_view/referance.dart';

class AuthService {
  final userCollection = FirebaseFirestore.instance.collection("users");
  final firebaseAuth = FirebaseAuth.instance;

  Future<void> registerUser(
      {required String name,
      required String lastname,
      required String email,
      required String password}) async {
    await userCollection.doc(firebaseAuth.currentUser!.uid).set({
      "userID": firebaseAuth.currentUser!.uid,
      "name": name,
      "lastname": lastname,
      "email": email,
      "password": password
    });
  }

  Future<void> registerGoogleUser({User? user}) async {
    await userCollection.doc(user!.uid).set({
      "userID": user.uid,
      "name": user.displayName!.split(' ').first,
      "email": user.email,
      "lastname": user.displayName!.split(' ').last
    });
  }

  Future<void> signUp(
      {required String name,
      required String lastname,
      required String email,
      required String password}) async {
    try {
      final UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        registerUser(
            name: name, lastname: lastname, email: email, password: password);
      }
    } on FirebaseAuthException catch (e) {
      // ignore: avoid_print
      print(e.message);
    }
  }

  Future<void> signIn(BuildContext context,
      {required String email, required String password}) async {
    try {
      final UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const Referance()),
            (route) => false);
      }
    } on FirebaseAuthException catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              titleTextStyle:
                  GoogleFonts.andika(color: const Color.fromARGB(255, 0, 0, 0)),
              title: Text(e.message!, textAlign: TextAlign.center),
              backgroundColor: const Color.fromARGB(255, 222, 208, 196),
              elevation: 0,
              shadowColor: Colors.transparent,
              alignment: Alignment.bottomCenter,
              shape: const StadiumBorder(),
            );
          });
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? gAuth = await gUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth?.accessToken,
        idToken: gAuth?.idToken,
      );
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      // ignore: avoid_print
      print(e.message);
    }
    return null;
  }
}
