import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  late final String name;
  late final String lastname;
  late final String email;
  late final String password;
  final String? userID;
  Users(
      {required this.name,
      required this.lastname,
      required this.email,
      required this.password,
      this.userID});

  factory Users.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();
    return Users(
        email: data["email"],
        name: data["name"],
        lastname: data["lastname"],
        password: data["password"],
        userID: data["userID"]);
  }
}
