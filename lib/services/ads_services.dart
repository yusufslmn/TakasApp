import 'package:cloud_firestore/cloud_firestore.dart';
import 'model/advertise_modal.dart';

Future<AdsModal> getAdsDetails(String adsId) async {
  final db = FirebaseFirestore.instance;
  final snapshot =
      await db.collection("ads").where("adsID", isEqualTo: adsId).get();
  final adsData = snapshot.docs.map((e) => AdsModal.fromSnapshot(e)).single;
  return adsData;
}

Future<List<AdsModal>> getAllAds() async {
  final db = FirebaseFirestore.instance;
  final snapshot = await db.collection("ads").get();
  final adsData = snapshot.docs.map((e) => AdsModal.fromSnapshot(e)).toList();
  return adsData;
}

Future<List<AdsModal>> getUserAds(String? userID) async {
  final db = FirebaseFirestore.instance;
  final snapshot =
      await db.collection("ads").where("userID", isEqualTo: userID).get();
  final adsData = snapshot.docs.map((e) => AdsModal.fromSnapshot(e)).toList();
  return adsData;
}
