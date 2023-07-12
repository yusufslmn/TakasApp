import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  getUserDetails(String? userID) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(userID)
        .get()
        .then((value) {
      if (value.data()?["profileImageUrl"] != null) {
        return value.data()?["profileImageUrl"];
      }
      return null;
    });
  }
}
