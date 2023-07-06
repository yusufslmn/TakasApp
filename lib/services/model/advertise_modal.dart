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

  AdsModal(
      {required this.category,
      required this.status,
      required this.adsName,
      required this.adsSituation,
      required this.adsID,
      required this.imagesUrl,
      required this.adsPrice,
      required this.userID});

  toJson() {
    final firebaseAuth = FirebaseAuth.instance;
    return {
      "userID": firebaseAuth.currentUser!.uid,
      "adsName": this.adsName,
      "adsCategory": this.category,
      "adsStatus": this.status,
      "adsID": this.adsID,
      "adsSituation": this.adsSituation,
      "imagesURL": this.imagesUrl,
      "adsPrice": this.adsPrice
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
        userID: data["userID"]);
  }

  Future<void> adsUpload() async {
    final adsCollection = FirebaseFirestore.instance.collection("ads");
    final firebaseAuth = FirebaseAuth.instance;

    await adsCollection.doc(this.adsID).set({
      "userID": firebaseAuth.currentUser!.uid,
      "adsName": this.adsName,
      "adsCategory": this.category,
      "adsStatus": this.status,
      "adsID": this.adsID,
      "adsSituation": this.adsSituation,
      "imagesURL": this.imagesUrl,
      "adsPrice": this.adsPrice
    });
  }
}
