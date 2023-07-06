import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:takasapp/services/model/users_modal.dart';
import '../pages/referance.dart';

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
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const Referance()));
      }
    } on FirebaseAuthException catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              titleTextStyle:
                  GoogleFonts.andika(color: const Color.fromARGB(255, 0, 0, 0)),
              title: Text(e.message!, textAlign: TextAlign.center),
              backgroundColor: Color.fromARGB(255, 222, 208, 196),
              elevation: 0,
              shadowColor: Colors.transparent,
              alignment: Alignment.bottomCenter,
              shape: const StadiumBorder(),
            );
          });
    }
  }

  Future<Users> getUserDetails(String userID) async {
    final db = FirebaseFirestore.instance;
    final snapshot =
        await db.collection("users").where("userID", isEqualTo: userID).get();
    final userData = snapshot.docs.map((e) => Users.fromSnapshot(e)).single;
    return userData;
  }

  FutureBuilder getUserName(String userID) => FutureBuilder(
      future: AuthService().getUserDetails(userID),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return Text(
              snapshot.data!.name + " " + snapshot.data!.lastname,
              style: const TextStyle(color: Colors.black),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else {
            return const Center(child: Text("bir şeyler yanlış gitti..."));
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      }));
}
