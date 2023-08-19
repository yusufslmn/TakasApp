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

  Future<TokenModal> getUser(String? userID) async {
    final db = FirebaseFirestore.instance;
    final snapshot =
        await db.collection("users").where("userID", isEqualTo: userID).get();
    final userData =
        snapshot.docs.map((e) => TokenModal.fromSnapshot(e)).single;
    return userData;
  }
}

class TokenModal {
  String? userToken;
  String? userName;

  TokenModal({required this.userToken, required this.userName});

  factory TokenModal.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();
    return TokenModal(userName: data["name"], userToken: data["token"]);
  }
}
