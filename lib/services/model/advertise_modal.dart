import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdsModal {
  String category;
  String status;
  String adsName;
  String adsSituation;
  String adsID;
  List<dynamic> imagesUrl;
  String adsPrice;
  String userID;
  String? location;

  AdsModal(
      {required this.category,
      required this.status,
      required this.adsName,
      required this.adsSituation,
      required this.adsID,
      required this.imagesUrl,
      required this.adsPrice,
      required this.userID,
      this.location});

  toJson() {
    final firebaseAuth = FirebaseAuth.instance;
    return {
      "userID": firebaseAuth.currentUser!.uid,
      "adsName": adsName,
      "adsCategory": category,
      "adsStatus": status,
      "adsID": adsID,
      "adsSituation": adsSituation,
      "imagesURL": imagesUrl,
      "adsPrice": adsPrice,
      "location": location
    };
  }

  factory AdsModal.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();
    return AdsModal(
        category: data["adsCategory"],
        status: data["adsStatus"],
        adsName: data["adsName"],
        adsSituation: data["adsSituation"],
        adsID: data["adsID"],
        imagesUrl: data["imagesURL"],
        adsPrice: data["adsPrice"],
        userID: data["userID"],
        location: data["location"]);
  }

  Future<void> adsUpload() async {
    final adsCollection = FirebaseFirestore.instance.collection("ads");
    final firebaseAuth = FirebaseAuth.instance;

    await adsCollection.doc(adsID).set({
      "userID": firebaseAuth.currentUser!.uid,
      "adsName": adsName,
      "adsCategory": category,
      "adsStatus": status,
      "adsID": adsID,
      "adsSituation": adsSituation,
      "imagesURL": imagesUrl,
      "adsPrice": adsPrice,
      "location": location,
    });
  }
}
